# 
# side renderer --
# 
# leverages ActionMailer to render templates or partials
# outside of any request context.
# 
# useful in edge cases like rendering 
# 
require 'pathname'

class SideRenderer
  def initialize(extra_view_paths:[], mailer_class:nil)
    @mailer_class = mailer_class || begin
      ApplicationMailer
    rescue NameError
       ActionMailer::Base
    end
    @extra_view_paths = extra_view_paths
  end

  def side_render(render_options = {})
    fake_mailer.lazy_renderer(render_options).body.encoded
  end

  module Controller
    def side_render(options = {})
      object_options = options.slice(:extra_view_paths, :mailer_class)
      SideRenderer.new(object_options).side_render(options)
    end
  end

  private

  attr_reader :extra_view_paths, :mailer_class


  module RoadieFixer
    def self.included(by)
      by.alias_method_chain :side_render, :roadie
    end

    private

    def side_render_with_roadie(*args)
      config = Roadie.app.config.roadie
      @enabled = config.enabled
      config.enabled = false
      side_render_without_roadie(*args)
    ensure
      config.enabled = @enabled
    end
  end

  include RoadieFixer if defined?(Roadie)


  def fake_mailer
    paths = @extra_view_paths
    @fake_mailer ||= Class.new(@mailer_class).class_eval do
      layout nil

      append_view_path Pathname.new(__FILE__).parent.to_s
      paths.each { |path| append_view_path path }

      def lazy_renderer(render_options = {})
        @render_options = render_options
        mail(to: "nil@nil.com", subject:"nil", template_path:'.', template_name:'side_renderer')
      end

      self
    end
  end
end
