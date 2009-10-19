require File.dirname(__FILE__) + '/../spec_helper'

module CucumberScreenshot
  describe Formatter do
    describe '#visit_scenario_named' do
      before(:each) do
        @formatter = Formatter.new(stub('step_mother'), nil, {})
      end
      it "set current_scenario_segment from scenario name" do
        lambda { @formatter.visit_scenario_name(nil, 'Login (when already has an account)', 1, 2) }.should change(@formatter, :current_scenario_segment).to('login_when_already_has_an_account')
      end
    end
  end
end
