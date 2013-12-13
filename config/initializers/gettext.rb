# encoding: UTF-8
require 'fast_gettext'

Object.send(:include, FastGettext::Translation)

FastGettext.available_locales = [:en]
FastGettext.add_text_domain('app_fab', :path => 'config/locales')
FastGettext.default_text_domain = 'app_fab'

GettextI18nRails.translations_are_html_safe = true

# TODO: this can go away when the following PR is released to Rails
# https://github.com/rails/rails/pull/13310
ActiveSupport::SafeBuffer.class_eval do
  def %(args)
    escaper = ->(arg) { (!html_safe? || arg.html_safe?) ? arg : ERB::Util.h(arg) }
    case args
    when Hash
      escaped_args = Hash[args.map { |k,arg| [k, escaper.call(arg)] }]
    else
      escaped_args = Array(args).map { |arg| escaper.call(arg) }
    end

    self.class.new(super(escaped_args))
  end
end
