require 'fileutils'

def xmllib
  File.dirname(__FILE__) + '/../../vendor/plugins/systir/lib'  
end

def prepare(environment)
  #ENV['xmltestrunner_environment'] = environment
  FileUtils.mkdir_p './target/test-reports/'
  Test::Unit::AutoRunner::RUNNERS[:xml] = proc do |r|
    $: << xmllib()
    Test::Unit::UI::XML::TestRunner
  end
end

desc 'Test all units and functionals'
namespace :test do
  task :xml   do
    ENV['XMLTEST_OUTPUT'] = 'TEST-unit.xml'
    Rake::Task["test:xml:units"].invoke       rescue got_error = true
    ENV['XMLTEST_OUTPUT'] = 'TEST-functional.xml'
    Rake::Task["test:xml:functionals"].invoke rescue got_error = true
  
    if File.exist?("test/integration")
      ENV['XMLTEST_OUTPUT'] = 'TEST-integration.xml'
      Rake::Task["test:integration"].invoke rescue got_error = true
    end

    raise "Test failur`es" if got_error
  end
end

namespace :test do
  namespace :xml do
  desc "Run the uni  t tests in test/unit"
    Rake::TestTask.new(:units => "db:test:prepare") do |t|
      prepare('units')
      t.ruby_opts << '-rtest/unit/ui/xml/testrunner'
      t.options = "--runner=xml"
      t.libs << "test"
      t.libs << xmllib()
      t.pattern = 'test/unit/**/*_test.rb'
      t.verbose = false
    end

    desc "Run the functional tests in test/functional"
    Rake::TestTask.new(:functionals => "db:test:prepare") do |t|
      prepare('functionals')
      t.ruby_opts << '-rtest/unit/ui/xml/testrunner'
      t.options = "--runner=xml"
      t.libs << "test"
      t.libs << xmllib()
      t.pattern = 'test/functional/**/*_test.rb'
      t.verbose = false
    end
  end
end