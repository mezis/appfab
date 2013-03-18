module ErrorsFormHelper

  def errors_for_field(record, field, options={})
    errors = record.errors[field]
    return if errors.empty?
    classes = [options[:class], 'help-block error'].compact.join(' ')
    content_tag(:div, class:classes) do
      record.errors[field].join(', ')
    end
  end
end