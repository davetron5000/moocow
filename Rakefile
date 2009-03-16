require 'rake/clean'
require 'rake/testtask'
require 'hanna/rdoctask'
require 'rcov/rcovtask'
require 'rubygems'
require 'rake/gempackagetask'
$: << '../grancher/lib'
require 'grancher/task'

Grancher::Task.new do |g|
  g.branch = 'gh-pages'
  g.push_to = 'origin'
  g.directory 'html'
end

Rake::RDocTask.new do |rd|
  rd.main = "README.rdoc"
  rd.rdoc_files.include("README.rdoc","lib/**/*.rb","bin/**/*","ext/**/*.rb")
  rd.title = 'Ruby Client for Remember The Milk'
end

spec = eval(File.read('rtm.gemspec'))
 
Rake::GemPackageTask.new(spec) do |pkg|
    pkg.need_tar = true
end

Rake::TestTask.new do |t|
  t.libs << "test"
  t.libs << 'ext'
  t.test_files = FileList['test/tc_*.rb']
end

desc 'Measures test coverage'
task :coverage => :rcov do
  system("open coverage/index.html") if PLATFORM['darwin']
end

Rcov::RcovTask.new do |t|
  t.libs << 'test'
  t.libs << 'ext'
  t.test_files = FileList['test/tc_*.rb']
end



task :default => :test

task :publish_rdoc => [:rdoc,:publish]
