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

    describe 'Html#embed_image' do
      it 'should build link and image' do
        formatter = Cucumber::Formatter::Html.new(@step_mother, @io, {})
        builder = mock('builder')
        formatter.stub!(:builder => builder)
        builder.should_receive(:a)
        builder.should_receive(:img)
        formatter.embed_image('/tmp/foo.png')
      end
    end
  end
end
