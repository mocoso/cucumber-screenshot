require 'rubygems'
require 'cucumber_screenshot'

require "nokogiri"
require "webrat/core/matchers"

Spec::Runner.configure do |config|
  config.include(Webrat::Matchers)
end

