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
          f.write rewrite_local_urls(current_response_body)
        end

        if CucumberScreenshot.snap_url_present?
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
        else
          self.response_body_for_last_screenshot = current_response_body
          true
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

      # So that references to stylesheets, javascript and images will work
      def rewrite_local_urls(response_html) # :nodoc:
        if base_url
          doc = Nokogiri::HTML::Document.parse response_html
          if head = doc.xpath("//head").first
            base = Nokogiri::HTML::DocumentFragment.parse "<base href=\"#{base_url}\">"
            head.child && head.child.add_previous_sibling(base)
            doc.to_html
          else
            response_html
          end
        elsif doc_root
          # TODO: replace with nokogiri calls
          response_html.gsub(/"\/([^"]*)"/, %{"#{doc_root}} + '/\1"')
        else
          response_html
        end
      end

      def report_error_running_screenshot_command(command)
        STDERR.puts "
Unable to make screenshot, to find out what went wrong try the following from the command line

    #{command}

"
      end

      def config
        config_file = File.expand_path(File.join(RAILS_ROOT, 'config', 'cucumber_screenshot.yml'))
        @config ||= if File.exist?(config_file)
          YAML::load(File.open(config_file))
        else
          {}
        end
      end

      def base_url
        config['base_url']
      end

      def doc_root
        File.expand_path(File.join(RAILS_ROOT, 'public'))
      end
  end
end
