# 
# Configure fast_gettext to use MO files.
# Generate MO files from PO files as needed.
# 
require 'fast_gettext'

Object.send(:include, FastGettext::Translation)

FastGettext.add_text_domain('socialp', :path => 'config/locales')
FastGettext.available_locales = [:en]
FastGettext.text_domain = 'socialp'

