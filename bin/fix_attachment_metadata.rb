#!/usr/bin/env ruby
#
# Converts attachment metadata for a format suitable for Dragonfly 1.0
#

# require 'rubygems'
# require 'bundler/setup'

dir = File.expand_path('../..', __FILE__)
$:.unshift(dir) unless $:.include?(dir)

require 'config/environment'

Storage::File.find_each do |file|
  file.metadata = JSON.parse(file.metadata.to_json)
  file.save!
end

