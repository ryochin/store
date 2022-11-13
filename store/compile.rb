#!/usr/bin/env ruby

require 'json'

entries = JSON.parse(File.read('./base.json')).each_with_object([]) do |entity, result|
  file = File.join('./entries', '%s.json' % entity['id'])

  next if !File.exist?(file)

  puts "loading #{file} ..."

  entity['data'] = JSON.parse(File.read(file))

  next if entity['data'].length === 0

  result << entity
end

content = File.read('./template.html')
content.sub! '__LIST__', JSON.pretty_generate(entries)
content.sub! '__UPDATED_AT__', Time.now.to_s.split(' ')[0].gsub('-', '/')

File.write '../store.html', content

puts 'store.html created.'
