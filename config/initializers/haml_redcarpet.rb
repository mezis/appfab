# encoding: utf-8
require "redcarpet"

# Adds Redcarpet support to Haml's :markdown filter.
module Haml::Filters::Markdown
  include Haml::Filters::Base

  def render(text)
    Object.new.extend(PipelineHelper).pipeline_render(text)
  end
end
