#!/usr/bin/env ruby

require 'json'

entries = JSON.parse(File.read('./base.json')).each_with_object([]) do |entiry, result|
  file = File.join('./entries', '%s.json' % entiry['id'])

  next if !File.exists?(file)

  puts "loading #{file} ..."

  entiry['data'] = JSON.parse(File.read(file))

  result << entiry
end

content = File.read('./template.html')
content.sub! '__LIST__', JSON.dump(entries)

File.write '../store.html', content

puts "store.html created."
