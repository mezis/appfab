# encoding: UTF-8
require 'fast_gettext'
require 'gettext_i18n_rails/string_interpolate_fix'

Object.send(:include, FastGettext::Translation)

FastGettext.add_text_domain('socialp', :path => 'config/locales')
FastGettext.default_text_domain = 'socialp'
