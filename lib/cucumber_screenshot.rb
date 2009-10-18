require 'cucumber'
require 'webrat'

require 'cucumber_screenshot/formatter'
require 'cucumber_screenshot/webrat/session'

# Add formatter to Cucumber's built in list so you can use
#
#   --format screenshot
#
# as well as
#
#   --format Cucumber::Format::Screenshot
Cucumber::Cli::Configuration::BUILTIN_FORMATS['screenshot'] = 'CucumberScreenshot::Formatter'

# Make screenshot method available to steps
Webrat::Methods.delegate_to_session :screenshot
