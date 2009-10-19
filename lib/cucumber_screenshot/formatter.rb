module CucumberScreenshot
  class Formatter < Cucumber::Ast::Visitor

    attr_accessor :response_body_for_last_screenshot, :screenshot_index, :screenshot_directory, :current_feature_segment, :current_scenario_segment

    # Currently ignores io and options arguments
    def initialize(step_mother, io, options)
      super(step_mother)
      @io = io
      @options = options
    end

    def visit_step_result(keyword, step_match, multiline_arg, status, exception, source_indent, background)
      if screenshot_due?
        self.screenshot_index = screenshot_index.next
        exit unless session.screenshot(screenshot_directory_name, "screenshot-#{format('%03d', screenshot_index)}")
        self.response_body_for_last_screenshot = current_response_body
      end
      super
    end

    def visit_scenario_name(keyword, name, file_colon_line, source_indent)
      puts "Scenario #{name}"
      self.response_body_for_last_screenshot = nil
      self.screenshot_index = 0
      self.current_scenario_segment = segment_for_scenario_named(name)
    end

    def visit_feature(feature)
      self.current_feature_segment = segment_for_feature(feature)
      super
    end

    def visit_feature_name(name)
      puts(name)
    end

    protected
      def screenshot_directory_name
        File.join(session.base_screenshot_directory_name, current_feature_segment, current_scenario_segment)
      end

      def segment_for_feature(feature)
        feature.file.gsub(/^features\//, '').gsub(/\.feature$/, '')
      end

      def segment_for_scenario_named(name)
        name.downcase.gsub(' ', '_').gsub(/(\(|\))/, '')
      end

      def session
        step_mother.current_world.webrat_session
      end

      def current_response_body
        session.send(:response) && session.response_body
      end

      def screenshot_due?
        current_response_body && current_response_body != response_body_for_last_screenshot && !session.redirect?
      end
  end
end
