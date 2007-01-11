#!/usr/bin/env ruby

#
# Copyright (c) 2005, Gregory D. Fast
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
# 
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
# TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

require 'test/unit/ui/testrunnermediator'
require 'test/unit/ui/testrunnerutilities'
require 'test/unit/ui/console/testrunner'
require 'test/unit/autorunner'
require 'rexml/document'
require 'pp'

module Test
  module Unit
    module UI
      module XML

        #
        # XML::TestRunner - generate xml output for test results
        #
        # Example use:
        #
        #   $ ruby -rtest/unit/ui/xml/testrunner test/test_1.rb --runner=xml
        #
        # You can set the environment variable $XMLTEST_OUTPUT to
        # a filename to send the output to that file.
        #
        class TestRunner < Test::Unit::UI::Console::TestRunner

          def output_file
            ENV['XMLTEST_OUTPUT']
          end
          
          def initialize(suite, output_level=NORMAL, io="target/test-reports/TEST-testresults.xml")
            super(suite)

            io = "target/test-reports/#{output_file}"
            
            if io.is_a? String
              fn = io
              dir = File.dirname(io)
              puts "Creating #{dir}"
              FileUtils.mkdir_p(dir)
              puts "Writing to #{fn}"
              @io = File.open( fn, "w" )
            else
              @io = io
            end
            create_document
          end

          def create_document
            @doc = REXML::Document.new
            decl = REXML::XMLDecl.new
            decl.encoding = 'UTF-8'
            @doc << decl
            
            e = REXML::Element.new("testsuite")
            @doc << e
          end

          def to_s
            @doc.to_s
          end

          def start
            @current_test = nil
            # setup_mediator
            @mediator = TestRunnerMediator.new( @suite )
            suite_name = @suite.to_s
            if @suite.kind_of?(Module)
              suite_name = @suite.name
            end
            @doc.root.attributes['name'] = suite_name
            # attach_to_mediator - define callbacks
            @mediator.add_listener( TestResult::FAULT, 
                                    &method(:add_fault) )
            @mediator.add_listener( TestRunnerMediator::STARTED,
                                    &method(:started) )
            @mediator.add_listener( TestRunnerMediator::FINISHED,
                                    &method(:finished) )
            @mediator.add_listener( TestCase::STARTED, 
                                    &method(:test_started) )
            @mediator.add_listener( TestCase::FINISHED, 
                                    &method(:test_finished) )
            # return start_mediator
            return @mediator.run_suite
          end

          # callbacks

          def add_fault( fault )
            @faults << fault
            e = REXML::Element.new( "failure" )
            e.attributes['message'] = fault.message
            e.attributes['type'] = fault.class.name
            e << REXML::CData.new( fault.long_display ) 
            @current_test << e
          end

          def started( result )
            #STDERR.puts "Started"
            @result = result
            #dump_suite_hierarchy()
          end

          def finished( elapsed_time )
            @doc.root.attributes['errors'] = @result.error_count
            @doc.root.attributes['failures'] = @result.failure_count
            @doc.root.attributes['tests'] = @result.run_count
            @doc.root.attributes['time'] = sprintf("%2.4f", elapsed_time)

            @doc.root << REXML::Element.new( "properties")
            @doc.root << REXML::Element.new( "system-out")
            @doc.root << REXML::Element.new( "system-err")

            @io.puts( @doc.to_s )
          end
          
          def test_started( name )
            @test_started_time = Time.now
            #STDERR.puts "Test: #{name} started"
            e = REXML::Element.new( "testcase" )
            
            #JUnit: <testcase classname="com.radarnetworks.thingspot.CategoryControllerTest" name="testAddDuplicate" time="0.0040"></testcase>
            #Ruby: name='test_truth(QueueControllerTest)' - break it apart and reassemble xml
            name =~ /^(.*)\((.*)\)$/
            e.attributes['name'] = $1
            e.attributes['classname'] = $2
            e.attributes['time'] = '0.0000'
            @doc.root << e
            @current_test = e
          end
          
          #Given method(class), returns [ class, method ]
          def split_name(name)
            name =~ /^(.*)\((.*)\)$/
            return [ $2, $1 ]
          end

          def test_finished( name )
            @test_finished_time = Time.now
            puts @test_started_time
            puts @test_finished_time
            @current_test.attributes['time'] = sprintf( "%2.4f", (@test_finished_time.to_f - @test_started_time.to_f) )
            @current_test = nil
            puts "Looking for name: #{name}"
            pieces = split_name(name)
            test = find_test(pieces[0], pieces[1])
          end
          
          def find_suite( suite, suite_name)
            suite.tests.each { | test | 
              return test if test.name == suite_name
              if test.is_a?(Test::Unit::TestSuite)
                result = find_suite(test, suite_name)
                return result if result
              end
            }
            return nil
          end
          
          def find_method( suite, method_name )
            for test in suite.tests
              return test if test.method_name == method_name
            end
            return nil
          end
          
          def find_test( class_name, method_name )
            #puts "Searching #{@suite.to_s} for #{class_name}.#{method_name}"
            suite = find_suite(@suite, class_name)
            return nil unless suite
            return find_method(suite, method_name)
          end
          
          def dump_suite_hierarchy()
            puts "*" * 80
            dump_suite_hierarchy_internal(@suite)
            puts "*" * 80
          end
          
          def dump_suite_hierarchy_internal(suite, indent = '')
            if suite.is_a?(Test::Unit::TestSuite)
              puts "#{indent}SUITE: #{suite.name}"
              for test in suite.tests
                dump_suite_hierarchy_internal(test, indent + '  ')
              end
              return
            elsif suite.is_a?(Test::Unit::TestCase)
              puts "#{indent}TEST: #{suite.class.name}.#{suite.method_name}"
              return
            else
              puts "#{indent}UNKNOWN: #{suite.class.name}  #{suite}"
              c = suite.class
              while c
                puts "#{indent}  #{c.name}"
                c = c.superclass
              end
              return
            end
          end

        end
      end
    end
  end
end

# "plug in" xmltestrunner into autorunner's list of known runners
# This enables the "--runner=xml" commandline option.
Test::Unit::AutoRunner::RUNNERS[:xml] = proc do |r|
  require 'test/unit/ui/xml/testrunner'
  Test::Unit::UI::XML::TestRunner
end

if __FILE__ == $0
  Test::Unit::UI::XML::TestRunner.start_command_line_test
end

