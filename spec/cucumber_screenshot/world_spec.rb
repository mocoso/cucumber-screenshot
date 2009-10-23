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
      FileUtils.stub!(:mkdir_p => true)
      File.stub!(:open => true)
      @session.stub!(:base_screenshot_directory_name => 'tmp/features/screenshots', :response_body => 'foo')
      @session.stub!(:'`' => 'foo')
      # While $? is not being set by the backtick stub
      @session.stub!(:report_error_running_screenshot_command => true)
    end

    it 'should call File.makedirs' do
      FileUtils.should_receive(:mkdir_p).with('1/2/html').and_return(true)
      @session.screenshot('1/2', 'snapshot-001')
    end
  end

  describe '#embed_image' do

  end

  describe 'protected' do
    describe '#rewrite_javascript_and_css_and_image_references' do
      before(:each) do
        @session.stub!(:webrat_session => stub('webrat_session', :adapter => stub('rails_adapter', :doc_root => '/tmp/public')))
      end

      it 'should replace relative /javascripts/ references with file references' do
        @session.send(:rewrite_javascript_and_css_and_image_references, '<script src="/javascripts/application.js?1255077419" type="text/javascript"></script>').
          should == '<script src="/tmp/public/javascripts/application.js?1255077419" type="text/javascript"></script>'
      end

      it 'should replace relative /javascripts/ references with file references' do
        @session.send(:rewrite_javascript_and_css_and_image_references, '<link href="/stylesheets/application.css" media="screen" rel="stylesheet" type="text/css" />').
          should == '<link href="/tmp/public/stylesheets/application.css" media="screen" rel="stylesheet" type="text/css" />'
      end
    end
  end
end
