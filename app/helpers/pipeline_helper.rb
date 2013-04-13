module PipelineHelper

  def pipeline_render(text, summarize:false)
    hash = Digest::SHA1.hexdigest(text)
    Rails.cache.fetch("#{__method__}/v#{CACHE_VERSION}/#{hash}/summarize:#{summarize}") do
      text = text.gsub(/(\r?\n){2}.*/m, '') if summarize
      markdown.render(text)
    end
  end

  private

  CACHE_VERSION = 1

  PARSER_OPTIONS = {
    no_intra_emphasis:    true,
    tables:               true,
    fenced_code_blocks:   true,
    autolink:             true,
    strikethrough:        true,
    lax_spacing:          true,
    space_after_headers:  true,
    superscript:          true,
  }

  RENDERER_OPTIONS = {
    filter_html:          true,
    no_images:            true,
    no_links:             false,
    no_styles:            true,
    safe_links_only:      true,
    with_toc_data:        false,
    hard_wrap:            true,
    xhtml:                true,
  }

  def markdown
    @markdown ||= begin
      renderer = Redcarpet::Render::XHTML.new(RENDERER_OPTIONS)
      Redcarpet::Markdown.new(renderer, PARSER_OPTIONS)
    end
  end
end
