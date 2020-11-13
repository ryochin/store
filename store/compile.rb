#!/usr/bin/env ruby

require 'json'

entries = JSON.parse(File.read('./base.json')).each_with_object([]) do |entiry, result|
  file = File.join('./entries', '%s.json' % entiry['id'])

  next if !File.exist?(file)

  puts "loading #{file} ..."

  entiry['data'] = JSON.parse(File.read(file))

  result << entiry
end

content = File.read('./template.html')
content.sub! '__LIST__', JSON.dump(entries)
content.sub! '__UPDATED_AT__', Time.now.to_s.split(' ')[0].gsub('-', '/')

File.write '../store.html', content

puts 'store.html created.'
