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

# 先に更新日を差し込む（後で埋め込むJSON側の文字列を誤って置換しないため）
updated_at = Time.now.to_s.split(' ')[0].gsub('-', '/')
content.sub!('__UPDATED_AT__', updated_at) or raise 'placeholder __UPDATED_AT__ not found in template.html'

# __LIST__ を含む行の先頭インデントに合わせて、埋め込むJSONの継続行を揃える
indent = content[/^([ \t]*)[^\n]*__LIST__/, 1] || ''
# <script> 内へ raw 埋め込みするため </ を潰し、</script> によるタグ脱出を防ぐ
list_json = JSON.pretty_generate(entries).gsub('</') { '<\/' }.gsub("\n", "\n#{indent}")
content.sub!('__LIST__', list_json) or raise 'placeholder __LIST__ not found in template.html'

File.write '../index.html', content

puts 'index.html created.'
