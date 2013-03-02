# Exposes +render_ujs+.
module Traits::RenderUjs
  protected 
  def render_ujs(record_or_collection)
    render partial:'ujs', locals: { content:record_or_collection }
  end
end
