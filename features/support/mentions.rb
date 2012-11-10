module Mentions
  extend self

  def [](model)
    @mentions[model] or raise "No #{model.name} mentionned yet"
  end

  def []=(model, instance)
    raise unless instance.kind_of?(model)
    @mentions[model] = instance
  end

  def clear
    @mentions = {}
  end
end


Before do
  Mentions.clear
end
