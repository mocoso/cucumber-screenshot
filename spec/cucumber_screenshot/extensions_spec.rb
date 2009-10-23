require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe CucumberScreenshot::Extensions do

  describe 'formatters' do
    before(:each) do
      @step_mother = mock('step_mother')
      @io = mock('io')
    end

    describe 'Pretty#embed_image' do
      it 'should call announce' do
        formatter = Cucumber::Formatter::Pretty.new(@step_mother, @io, {})
        formatter.should_receive(:announce).with('- Image saved to /tmp/foo.png')
        formatter.embed_image('/tmp/foo.png')
      end
    end
  end
end
