# encoding: UTF-8
module WithConstants

  def with_constants(options = {})
    old_values = {}
    options.each_pair do |constant_name, value|
      old_values[constant_name] = const_get(constant_name)
      silence_warnings do
        const_set(constant_name, value)
      end
    end

    yield

    old_values.each_pair do |constant_name, value|
      silence_warnings do
        const_set(constant_name, value)
      end
    end    
  end

  Object.send(:include, self)
end