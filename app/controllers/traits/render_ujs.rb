# Exposes +render_ujs+.
module Traits::RenderUjs
  protected 
  def render_ujs(record_or_collection, options={})
    render partial:'ujs', locals: { content:record_or_collection, options:options }
  end
end
