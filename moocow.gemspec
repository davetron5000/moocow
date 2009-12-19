spec = Gem::Specification.new do |s| 
  s.name = 'moocow'
  s.version = '1.0.0'
  s.author = 'David Copeland'
  s.email = 'davidcopeland@naildrivin5.com'
  s.homepage = 'http://davetron5000.github.com/moocow'
  s.platform = Gem::Platform::RUBY
  s.summary = 'Ruby Client Library for Remember The Milk'
  s.description = 'Basic ruby client library for accessing Remember The Milk via their API'
  s.files = %w(
ext/hash_array.rb
ext/string_rtmize.rb
lib/moocow/auth.rb
lib/moocow/endpoint.rb
lib/moocow/moocow.rb
lib/moocow.rb
bin/rtm
  )
  s.require_paths << 'ext'
  s.require_paths << 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc']
  s.rdoc_options << '--title' << 'Remember The Milk Ruby Client' << '--main' << 'README.rdoc' << '-ri'
  s.add_dependency('httparty', '>= 0.3.1')
  s.add_dependency('gli', '>= 0.1.5')
  s.bindir = 'bin'
  s.rubyforge_project = 'moocow'
  s.executables << 'rtm'
end

