module PipelineHelper

  def pipeline_render(text)
    hash = Digest::SHA1.hexdigest(text)
    Rails.cache.fetch("pipeline_render/#{pipeline_cache_version}/#{hash}") do
      pipeline_default.call(text)[:output].to_s
    end
  end

  private

  def pipeline_default
    pipeline = HTML::Pipeline.new [
      HTML::Pipeline::MarkdownFilter,
      HTML::Pipeline::SyntaxHighlightFilter,
      HTML::Pipeline::EmojiFilter
    ], { gfm:true }
  end

  def pipeline_cache_version
    1
  end
end