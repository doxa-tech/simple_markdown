module SimpleMarkdown
  class Railtie < ::Rails::Railtie
    initializer "simple_markdown.configure_view_controller" do |app|
      ActiveSupport.on_load :action_view do
        include SimpleMarkdown::ActionView::Helpers
      end
    end
  end
end