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

    module Html
      def self.included(base)
        unless base.method_defined?(:embed_image)
          # TODO: needs style
          # TODO: Place to right of or below step result (when captured with AfterStep)
          base.send(:define_method, :embed_image) do |image_path|
            builder.a('Screenshot', :class => 'announcement', :href => '#', :onclick => "img=document.getElementById('#{image_path}'); img.style.display = (img.style.display == 'none' ? 'block' : 'none');")
            builder.img(:id => image_path, :src => image_path, :style => 'display: none')
          end
        end
      end
    end
  end
end

Cucumber::StepMother.send(:include, CucumberScreenshot::Extensions::StepMother)

Cucumber::Ast::TreeWalker.send(:include, CucumberScreenshot::Extensions::TreeWalker)

Cucumber::Formatter::Pretty.send(:include, CucumberScreenshot::Extensions::Console)
Cucumber::Formatter::Html.send(:include, CucumberScreenshot::Extensions::Html)
