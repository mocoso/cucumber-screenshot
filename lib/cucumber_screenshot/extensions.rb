module CucumberScreenshot
  module Extensions

    module StepMother
      def self.included(base)
        unless base.method_defined?(:embed_image)
          base.send(:define_method, :embed_image) do |image_path|
            @visitor.embed_image(image_path)
          end
        end
      end
    end

    module TreeWalker
      def self.included(base)
        unless base.method_defined?(:embed_image)
          base.send(:define_method, :embed_image) do |image_path|
            broadcast(image_path)
          end
        end
      end
    end

    module Console
      def self.included(base)
        unless base.method_defined?(:embed_image)
          base.send(:define_method, :embed_image) do |image_path|
            announce("- Image saved to #{image_path}")
          end
        end
      end
    end
  end
end

Cucumber::StepMother.send(:include, CucumberScreenshot::Extensions::StepMother)

Cucumber::Ast::TreeWalker.send(:include, CucumberScreenshot::Extensions::TreeWalker)

Cucumber::Formatter::Pretty.send(:include, CucumberScreenshot::Extensions::Console)
