module Mentions
  class Error < Exception ; end
  extend self

  def [](model)
    @mentions[model] or raise Error.new("No #{model.name} mentioned yet")
  end

  def []=(model, instance)
    raise Error.new('No model passed') unless instance.kind_of?(model)
    @mentions[model] = instance
  end

  def clear
    @mentions = {}
  end
end


Before do
  Mentions.clear
end
