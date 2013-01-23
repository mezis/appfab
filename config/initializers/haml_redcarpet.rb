# encoding: utf-8

# Adds Redcarpet support to Haml's :markdown filter.
module Haml::Filters::Markdown
  include Haml::Filters::Base
  lazy_require "redcarpet"

  def render(text)
    Object.new.extend(PipelineHelper).pipeline_render(text)
  end
end
