require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

class TestWorld
  include CucumberScreenshot::World
end

describe CucumberScreenshot::World do
  before(:each) do
    @session = TestWorld.new
  end

  describe '#base_screenshot_directory_name' do
    it "add features/screenshots to rails root" do
      ::RAILS_ROOT = 'tmp'
      TestWorld.new.base_screenshot_directory_name.should == 'tmp/features/screenshots'
    end
  end

  describe '#screenshot' do
    before(:each) do
      @session.stub!(
        :webrat_session => stub('webrat_session', :send => true, :response_body => 'response html'),
        :rewrite_local_urls => 'rewritten response html',
        :embed => true
      )

      # Stub with a command line call, required because don't know of other way to set $? to 0
      # TODO: Replace with mechanism that doesn't require this call
      @session.stub!(:'`').and_return { |args| `ruby -e 'true'` }

      FileUtils.stub!(:mkdir_p => true)
      @file = stub('file', :write => true)
      File.stub!(:open).and_yield(@file)
    end

    it 'should call File.makedirs' do
      FileUtils.should_receive(:mkdir_p).with('/1/2/html').and_return(true)
      @session.screenshot('/1/2', 'snapshot-001')
    end

    it 'should open a file ' do
      File.should_receive(:open).with('/1/2/html/snapshot-001.html', 'w').and_yield(@file)
      @session.screenshot('/1/2', 'snapshot-001')
    end

    it 'should write to file' do
      @file.should_receive(:write).with('rewritten response html')
      @session.screenshot('/1/2', 'snapshot-001')
    end

    describe 'when snapurl is installed' do
      before(:each) do
        CucumberScreenshot.stub!(:snap_url_present? => true)
      end

      it 'should call snapurl' do
        @session.should_receive(:'`') do |args|
          args.should == 'snapurl file:///1/2/html/snapshot-001.html --no-thumbnail --no-clip --filename snapshot-001 --output-dir /1/2'
        end
        @session.screenshot('/1/2', 'snapshot-001')
      end

      it 'should embed image' do
        @session.should_receive(:embed).with('/1/2/snapshot-001.png', 'image/png')
        @session.screenshot('/1/2', 'snapshot-001')
      end

      it 'should set response_body_for_last_screenshot' do
        lambda { @session.screenshot('/1/2', 'snapshot-001') }.should change(@session, :response_body_for_last_screenshot).to('response html')
      end

      describe 'when snapurl fails' do
        before(:each) do
          @session.stub!(:'`').and_return { |args| `ruby -e 'exit(1)'` }
          @session.stub!(:report_error_running_screenshot_command)
        end

        it 'should not embed image' do
          @session.should_not_receive(:embed)
          @session.screenshot('/1/2', 'snapshot-001')
        end

        it 'should not set response_body_for_last_screenshot' do
          lambda { @session.screenshot('/1/2', 'snapshot-001') }.should_not change(@session, :response_body_for_last_screenshot)
        end

        it 'should call report_error_running_screenshot_command' do
          @session.should_receive(:report_error_running_screenshot_command)
          @session.screenshot('/1/2', 'snapshot-001')
        end
      end
    end
  end

  describe 'protected' do
    describe '#rewrite_local_urls' do
      before(:each) do
        @session.stub!(:doc_root => '/tmp/public')
      end

      it 'should replace local urls with file references' do
        @session.send(:rewrite_local_urls, '<script src="/javascripts/application.js?1255077419" type="text/javascript"></script>').
          should == '<script src="/tmp/public/javascripts/application.js?1255077419" type="text/javascript"></script>'
      end
    end
  end
end
