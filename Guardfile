guard :minitest, spring: true do
  watch(%r{^test/test_helper\.rb$})      { 'test' }

  watch(%r{^test/concepts})
  watch(%r{^app/concepts/(.+)/(.*)\.rb}) { |m| "test/concepts/#{m[1]}" }

  watch(%r{^test/integration})
  watch(%r{^test/concepts})              { 'test/integration' }
  watch(%r{^app/views})                  { 'test/integration' }
  watch(%r{^app/controllers})            { 'test/integration' }
end

# A sample Guardfile
# More info at https://github.com/guard/guard#readme

## Uncomment and set this to only include directories you want to watch
# directories %w(app lib config test spec features) \
#  .select{|d| Dir.exists?(d) ? d : UI.warning("Directory #{d} does not exist")}

## Note: if you are using the `directories` clause above and you are not
## watching the project directory ('.'), then you will want to move
## the Guardfile to a watched dir and symlink it back, e.g.
#
#  $ mkdir config
#  $ mv Guardfile config/
#  $ ln -s config/Guardfile .
#
# and, you'll have to watch "config/Guardfile" instead of "Guardfile"

# guard 'zeus' do
#   require 'ostruct'

#   rspec = OpenStruct.new
#   rspec.spec_dir = 'spec'
#   rspec.spec = ->(m) { "#{rspec.spec_dir}/#{m}_spec.rb" }
#   rspec.spec_helper = "#{rspec.spec_dir}/spec_helper.rb"

#   # matchers
#   rspec.spec_files = /^#{rspec.spec_dir}\/.+_spec\.rb$/

#   # Ruby apps
#   ruby = OpenStruct.new
#   ruby.lib_files = /^(lib\/.+)\.rb$/

#   watch(rspec.spec_files)
#   watch(rspec.spec_helper) { rspec.spec_dir }
#   watch(ruby.lib_files) { |m| rspec.spec.call(m[1]) }

#   # Rails example
#   rails = OpenStruct.new
#   rails.app_files = /^app\/(.+)\.rb$/
#   rails.views_n_layouts = /^app\/(.+(?:\.erb|\.haml|\.slim))$/
#   rails.controllers = %r{^app/controllers/(.+)_controller\.rb$}

#   watch(rails.app_files) { |m| rspec.spec.call(m[1]) }
#   watch(rails.views_n_layouts) { |m| rspec.spec.call(m[1]) }
#   watch(rails.controllers) do |m|
#     [
#       rspec.spec.call("routing/#{m[1]}_routing"),
#       rspec.spec.call("controllers/#{m[1]}_controller"),
#       rspec.spec.call("acceptance/#{m[1]}")
#     ]
#   end

#   # TestUnit
#   # watch(%r|^test/(.*)_test\.rb$|)
#   # watch(%r|^lib/(.*)([^/]+)\.rb$|)     { |m| "test/#{m[1]}test_#{m[2]}.rb" }
#   # watch(%r|^test/test_helper\.rb$|)    { "test" }
#   # watch(%r|^app/controllers/(.*)\.rb$|) { |m| "test/functional/#{m[1]}_test.rb" }
#   # watch(%r|^app/models/(.*)\.rb$|)      { |m| "test/unit/#{m[1]}_test.rb" }
# end
