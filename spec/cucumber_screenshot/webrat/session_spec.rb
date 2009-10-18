require File.dirname(__FILE__) + '/../../spec_helper'

module CucumberScreenshot
  module Webrat
    describe Session do
      describe '#base_screenshot_directory_name' do
        it "add features/screenshots to rails root" do
          ::RAILS_ROOT = 'tmp'
          ::Webrat::Session.new.base_screenshot_directory_name.should == 'tmp/features/screenshots'
        end
      end

      describe '#screenshot' do
        before(:each) do
          @html_file = stub('html_file', :write => true)
          File.stub!(:makedirs => true, :open => @html_file)
          @session = ::Webrat::Session.new
          @session.stub!(:base_screenshot_directory_name => 'tmp/features/screenshots', :response_body => 'foo')
          @session.stub!(:` => 'foo')
          @session.stub!(:report_error_running_screenshot_command => true) # While $? is not being set by the backtick stub
        end

        it 'should call File.makedirs' do
          File.should_receive(:makedirs).with('1/2/html').and_return(true)
          @session.screenshot('1/2', 'snapshot-001')
        end
      end
    end
  end
end
