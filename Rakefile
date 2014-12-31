require 'rake/clean'
require 'rake/testtask'
require 'rdoc/task'
require 'rubygems'
require 'bundler'
require 'sdoc'
require 'minitest/autorun'

Bundler::GemHelper.install_tasks

Rake::RDocTask.new do |rd|
  rd.main = "README.rdoc"
  rd.rdoc_files.include("README.rdoc","lib/**/*.rb","bin/**/*","ext/**/*.rb")
  rd.options << '--fmt' << 'shtml'
  rd.template = 'direct'
  rd.title = 'Ruby Client for Remember The Milk'
end

Rake::TestTask.new do |t|
  t.libs << "test"
  t.libs << 'ext'
  t.test_files = FileList['test/tc_*.rb']
end

task :default => :test

task :publish_rdoc => [:rdoc,:publish]
