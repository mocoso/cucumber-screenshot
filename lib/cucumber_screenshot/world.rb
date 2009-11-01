module CucumberScreenshot
  module World

    attr_accessor :response_body_for_last_screenshot, :screenshot_index, :screenshot_directory, :current_feature_segment, :current_scenario_segment

    def base_screenshot_directory_name
      # TODO: Make this configurable
      # TODO: Make this work for other frameworks e.g. sinatra
      "#{RAILS_ROOT}/features/screenshots"
    end

    def screenshot(directory_name = base_screenshot_directory_name, file_name = "screenshot-#{(Time.now.to_f * 100).to_i}")
      if current_response_body
        FileUtils.mkdir_p("#{directory_name}/html")

        html_file_name = "#{directory_name}/html/#{file_name}.html"
        File.open(html_file_name, "w") do |f|
          f.write rewrite_javascript_and_css_and_image_references(current_response_body)
        end

        command = "snapurl file://#{html_file_name} --no-thumbnail --no-clip --filename #{file_name} --output-dir #{directory_name}"
        `#{command}`
        if $? == 0
          embed "#{directory_name}/#{file_name}.png", 'image/png'
          self.response_body_for_last_screenshot = current_response_body
          true
        else
          report_error_running_screenshot_command(command)
          false
        end
      end
    end

    def screenshot_due?
      current_response_body && current_response_body != response_body_for_last_screenshot && !webrat_session.redirect?
    end

    protected
      def current_response_body
        webrat_session.send(:response) && webrat_session.response_body
      end

      def rewrite_javascript_and_css_and_image_references(response_html) # :nodoc:
        doc_root = webrat_session.adapter.doc_root
        return response_html unless doc_root
        response_html.gsub(/"\/(javascripts|stylesheets|images)\//, '"' + doc_root + '/\1/')
      end

      def report_error_running_screenshot_command(command)
        STDERR.puts "
Unable to make screenshot, to find out what went wrong try the following from the command line

    #{command}

Please remember need to have installed the gem snapurl to take screenshots

    gem install snapurl

"
      end
  end
end
