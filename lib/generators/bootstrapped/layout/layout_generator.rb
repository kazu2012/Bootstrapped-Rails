require 'rails/generators'

module Bootstrapped
  module Generators
    class LayoutGenerator < ::Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)
      desc "This generator generates layout file with navigation."
      argument :layout_name, :type => :string, :default => "application"
      argument :layout_type, :type => :string, :default => "fixed",
               :banner => "*fixed or fluid"

      attr_reader :app_name, :container_class

      def generate_layout
        app = ::Rails.application
        @app_name = app.class.to_s.split("::").first
        @container_class = layout_type == "fluid" ? "container-fluid" : "container"
        ext = app.config.generators.options[:rails][:template_engine] || :erb
        template "layout.html.#{ext}", "app/views/layouts/#{layout_name}.html.#{ext}"
        template "_bootstrapped-navigation.html.#{ext}", "app/views/layouts/_bootstrapped-navigation.html.#{ext}"
        template '_apple_icon.html.erb', "app/views/layouts/_apple_icon.html.#{ext}"
        template '_sidebar.html.erb', "app/views/layouts/_sidebar.html.#{ext}"
        # Add our own require:
        
      end
      def application_controller_should_default_use_newly_generated_layout
        layout_name_here = %Q{  layout \'#{layout_name}\'\n}
        insert_into_file('app/controllers/application_controller.rb', after: "protect_from_forgery\n") do
          layout_name_here
        end
      end
    end
  end
end
