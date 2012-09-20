#!/usr/bin/env ruby
require 'rubygems'
require 'rake'
require 'yaml'

# activesupport/lib/active_support/inflector/methods.rb, line 48
  def underscore(camel_cased_word)
    word = camel_cased_word.to_s.dup
    word.gsub!(/::/, '/')
    word.gsub!(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
    word.gsub!(/([a-z\d])([A-Z])/, '\1_\2')
    word.tr!("-", "_")
    word.downcase!
    word
  end

# extract options
gem_class_name = ARGV[0]
gem_description = ARGV[1]
if not gem_class_name or not gem_description
  abort "Usage: ./template/copy.rb MyNewLib 'A great lib to do stuff'"
end
gem_name = underscore gem_class_name

# load settings
here = File.dirname(__FILE__)
SETTINGS = YAML.load_file("#{here}/.copy.yml")

# copy files
files_to_copy = Dir["#{here}/**/**"] + ["#{here}/.rvmrc", "#{here}/.travis.yml"] - ["#{here}/copy.rb"]
files_to_copy.reject! { |f| File.directory?(f) }

files_to_copy.each do |file_to_copy|
  # make new dir and file
  new_file = file_to_copy
  new_file = new_file.sub(here, '').sub(%r{^/}, '').sub('GEM_NAME', gem_name)
  new_file = "#{gem_name}/#{new_file}"
  sh "mkdir -p #{File.dirname(new_file)} 2>&1"

  # write modified content
  content = File.read(file_to_copy)
  content.gsub!('AUTHOR_GITHUB', SETTINGS['github'])
  content.gsub!('AUTHOR_EMAIL', SETTINGS['email'])
  content.gsub!('AUTHOR_HOMEPAGE', SETTINGS['homepage'])
  content.gsub!('AUTHOR_NAME', SETTINGS['name'])
  content.gsub!('GEM_NAME', gem_name)
  content.gsub!('GEM_CLASS_NAME', gem_class_name)
  content.gsub!('GEM_DESCRIPTION', gem_description)
  File.open(new_file, 'w') { |f| f.write content }
end

# commit everything into 'initial'
sh "cd #{gem_name} && git init && git add . && git commit -m 'initial by http://github.com/grosser/project_template'"

puts "#{gem_name} is now ready at ./#{gem_name}"


