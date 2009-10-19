module CucumberScreenshot
  module Webrat
    module Session #:nodoc:

      def base_screenshot_directory_name
        # TODO: Make this configurable
        # TODO: Make this work for other frameworks e.g. sinatra
        "#{RAILS_ROOT}/features/screenshots"
      end

      def screenshot(directory_name = base_screenshot_directory_name, file_name = "screenshot-#{Time.now.to_i}")
        File.makedirs("#{directory_name}/html")

        html_file_name = "#{directory_name}/html/#{file_name}.html"
        File.open(html_file_name, "w") do |f|
          f.write rewrite_javascript_and_css_and_image_references(response_body)
        end

        command = "snapurl file://#{html_file_name} --no-thumbnail --no-clip --filename #{file_name} --output-dir #{directory_name}"
        `#{command}`
        if $? == 0
          puts "- Screenshot saved to #{directory_name}/#{file_name}.png\n"
          true
        else
          report_error_running_screenshot_command(command)
          false
        end
      end

      protected
        def rewrite_javascript_and_css_and_image_references(response_html) # :nodoc:
          return response_html unless doc_root
          rewrite_css_and_image_references(response_html).gsub(/"\/(javascript)/, doc_root + '/\1')
        end

        def report_error_running_screenshot_command(command)
          STDERR.puts "
Unable to make screenshot, to find out what went wrong try the following from the command line

    #{command}

Please remember need to have installed the gem mocoso-snapshoturl to take screenshots

    gem install mocoso-snapshoturl

"
        end
    end
  end
end

Webrat::Session.send(:include, CucumberScreenshot::Webrat::Session)

