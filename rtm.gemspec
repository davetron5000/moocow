spec = Gem::Specification.new do |s| 
  s.name = 'rtm'
  s.version = '0.1.0'
  s.author = 'David Copeland'
  s.email = 'davidcopeland@naildrivin5.com'
  s.homepage = 'http://davetron5000.github.com/rtm'
  s.platform = Gem::Platform::RUBY
  s.summary = 'client to access the Remember The Milk API'
  s.files = %w(
  )
  s.require_paths << 'ext'
  s.require_paths << 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc']
  s.rdoc_options << '--title' << 'Remember The Milk Ruby Client' << '--main' << 'README.rdoc' << '-ri'
  s.add_dependency('httparty', '>= 0.3.1')
  s.add_dependency('davetron5000-gli', '>= 0.1.4')
  s.bindir = 'bin'
  s.executables << 'rtm'
end

