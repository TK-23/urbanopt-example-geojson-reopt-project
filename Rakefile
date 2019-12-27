#*********************************************************************************
# URBANopt, Copyright (c) 2019, Alliance for Sustainable Energy, LLC, and other
# contributors. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:
#
# Redistributions of source code must retain the above copyright notice, this list
# of conditions and the following disclaimer.
#
# Redistributions in binary form must reproduce the above copyright notice, this
# list of conditions and the following disclaimer in the documentation and/or other
# materials provided with the distribution.
#
# Neither the name of the copyright holder nor the names of its contributors may be
# used to endorse or promote products derived from this software without specific
# prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
# IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
# INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
# OF THE POSSIBILITY OF SUCH DAMAGE.
#*********************************************************************************

require 'openstudio/extension'
require 'openstudio/extension/rake_task'
require 'urbanopt/scenario'
require 'urbanopt/geojson'
require 'urbanopt/reopt_scenario'
require 'urbanopt/reopt'
require_relative 'developer_nrel_key'

module URBANopt
  module ExampleGeoJSONProject
    class ExampleGeoJSONProject < OpenStudio::Extension::Extension
     
      # number of datapoints(features) you want to run in parallel 
      # based on the number of available processors on your local machine.
      OpenStudio::Extension::Extension::NUM_PARALLEL = 7

      # set MAX_DATAPOINTS
      OpenStudio::Extension::Extension::MAX_DATAPOINTS = 1000

      def initialize
        super
        @root_dir = File.absolute_path(File.dirname(__FILE__))
      end
      
      # Return the absolute path of the measures or nil if there is none, can be used when configuring OSWs
      def measures_dir
        nil
      end
      
      # Relevant files such as weather data, design days, etc.
      # Return the absolute path of the files or nil if there is none, used when configuring OSWs
      def files_dir
        return File.absolute_path(File.join(@root_dir, 'weather'))
      end
      
      # Doc templates are common files like copyright files which are used to update measures and other code
      # Doc templates will only be applied to measures in the current repository
      # Return the absolute path of the doc templates dir or nil if there is none
      def doc_templates_dir
        return File.absolute_path(File.join(@root_dir, 'doc_templates'))
      end
      
    end
  end
end

def root_dir
  return File.dirname(__FILE__)
end

def baseline_scenario
  name = 'Baseline Scenario'
  run_dir = File.join(File.dirname(__FILE__), 'run/baseline_scenario/')
  feature_file_path = File.join(File.dirname(__FILE__), 'example_project.json')
  csv_file = File.join(File.dirname(__FILE__), 'baseline_scenario.csv')
  mapper_files_dir = File.join(File.dirname(__FILE__), 'mappers/')
  reopt_files_dir = File.join(File.dirname(__FILE__), 'reopt/')
  scenario_reopt_assumptions_file_name = 'base_assumptions.json'
  num_header_rows = 1

  feature_file = URBANopt::GeoJSON::GeoFile.from_file(feature_file_path)
  scenario = URBANopt::Scenario::REoptScenarioCSV.new(name, root_dir, run_dir, feature_file, mapper_files_dir, csv_file, num_header_rows, reopt_files_dir, scenario_reopt_assumptions_file_name)
  return scenario
end

def high_efficiency_scenario
  name = 'High Efficiency Scenario'
  run_dir = File.join(File.dirname(__FILE__), 'run/high_efficiency_scenario/')
  feature_file_path = File.join(File.dirname(__FILE__), 'example_project.json')
  csv_file = File.join(File.dirname(__FILE__), 'high_efficiency_scenario.csv')
  mapper_files_dir = File.join(File.dirname(__FILE__), 'mappers/')
  reopt_files_dir = File.join(File.dirname(__FILE__), 'reopt/')
  scenario_reopt_assumptions_file_name = 'base_assumptions.json'
  num_header_rows = 1

  feature_file = URBANopt::GeoJSON::GeoFile.from_file(feature_file_path)
  scenario = URBANopt::Scenario::REoptScenarioCSV.new(name, root_dir, run_dir, feature_file, mapper_files_dir, csv_file, num_header_rows, reopt_files_dir, scenario_reopt_assumptions_file_name)
  return scenario
end

def mixed_scenario
  name = 'Mixed Scenario'
  run_dir = File.join(File.dirname(__FILE__), 'run/mixed_scenario/')
  feature_file_path = File.join(File.dirname(__FILE__), 'example_project.json')
  csv_file = File.join(File.dirname(__FILE__), 'mixed_scenario.csv')
  mapper_files_dir = File.join(File.dirname(__FILE__), 'mappers/')
  reopt_files_dir = File.join(File.dirname(__FILE__), 'reopt/')
  scenario_reopt_assumptions_file_name = 'base_assumptions.json'
  num_header_rows = 1

  feature_file = URBANopt::GeoJSON::GeoFile.from_file(feature_file_path)
  scenario = URBANopt::Scenario::REoptScenarioCSV.new(name, root_dir, run_dir, feature_file, mapper_files_dir, csv_file, num_header_rows, reopt_files_dir, scenario_reopt_assumptions_file_name)
  return scenario
end

# Load in the rake tasks from the base extension gem
rake_task = OpenStudio::Extension::RakeTask.new
rake_task.set_extension_class(URBANopt::ExampleGeoJSONProject::ExampleGeoJSONProject)

### Baseline 

desc 'Clear Baseline Scenario'
task :clear_baseline do
  puts 'Clearing Baseline Scenario...'
  baseline_scenario.clear
end

desc 'Run Baseline Scenario'
task :run_baseline do
  puts 'Running Baseline Scenario...'

  scenario_runner = URBANopt::Scenario::ScenarioRunnerOSW.new
  scenario_runner.run(baseline_scenario)

end

desc 'Post Process Baseline Scenario'
task :post_process_baseline do
  puts 'Post Processing Baseline Scenario...'
  default_reopt_post_processor = URBANopt::Scenario::ScenarioDefaultPostProcessor.new(baseline_scenario) 
  scenario_report = default_reopt_post_processor.run
  scenario_base = default_reopt_post_processor.scenario_base
  reopt_post_processor = URBANopt::REopt::REoptPostProcessor.new(scenario_report,scenario_base.scenario_reopt_assumptions_file, scenario_base.reopt_feature_assumptions, DEVELOPER_NREL_KEY) 
  
  #Run Aggregate Scenario
  scenario_report_scenario = reopt_post_processor.run_scenario_report(scenario_report)
  scenario_report_scenario.save('baseline_scenario')

  #Run features individually  
  scenario_report_features = reopt_post_processor.run_scenario_report_features(scenario_report)
  scenario_report_features.save('baseline_features')

  # reopt_post_processor.scenario_reopt_default_assumptions_hash[:Scenario][:Site][:Storage][:min_kw] = 17845.3772
  # reopt_post_processor.scenario_reopt_default_assumptions_hash[:Scenario][:Site][:Storage][:max_kw] = 17845.3772
  # reopt_post_processor.scenario_reopt_default_assumptions_hash[:Scenario][:Site][:Storage][:min_kwh] = 74997.2017
  # reopt_post_processor.scenario_reopt_default_assumptions_hash[:Scenario][:Site][:Storage][:max_kwh] = 74997.2017
  # scenario_report = reopt_post_processor.run_scenario_report(scenario_report, reopt_post_processor.scenario_reopt_default_assumptions_hash, reopt_post_processor.scenario_reopt_default_output_file, reopt_post_processor.scenario_timeseries_default_output_file)
  # scenario_report.save('baseline_scenario_sized_to_features')

  # modified_inputs = []
  # reopt_post_processor.feature_reports_reopt_default_assumption_hashes.each do |h|

  #   h[:Scenario][:Site][:Storage][:min_kw] = 1519.3045 / 13 
  #   h[:Scenario][:Site][:Storage][:max_kw] = 1519.3045 / 13 
  #   h[:Scenario][:Site][:Storage][:min_kwh] = 7790.9747 / 13
  #   h[:Scenario][:Site][:Storage][:max_kwh] = 7790.9747 / 13
  #   modified_inputs << h
  # end

  # scenario_report = reopt_post_processor.run_scenario_report_features(scenario_report, modified_inputs, reopt_post_processor.feature_reports_reopt_default_output_files, reopt_post_processor.feature_reports_timeseries_default_output_files)
  # scenario_report.save('baseline_features_sized_to_scenario')




end

### High Efficiency 

desc 'Clear High Efficiency Scenario'
task :clear_high_efficiency do
  puts 'Clearing High Efficiency Scenario...'
  high_efficiency_scenario.clear
end

desc 'Run High Efficiency Scenario'
task :run_high_efficiency do
  puts 'Running High Efficiency Scenario...'

  scenario_runner = URBANopt::Scenario::ScenarioRunnerOSW.new
  scenario_runner.run(high_efficiency_scenario)
end

desc 'Post Process High Efficiency Scenario'
task :post_process_high_efficiency do
  puts 'Post Processing High Efficiency Scenario...'
  
  default_reopt_post_processor = URBANopt::Scenario::ScenarioDefaultPostProcessor.new(high_efficiency_scenario) 
  scenario_report = default_reopt_post_processor.run
  scenario_base = default_reopt_post_processor.scenario_base
  reopt_post_processor = URBANopt::REopt::REoptPostProcessor.new(scenario_report,scenario_base.scenario_reopt_assumptions_file, scenario_base.reopt_feature_assumptions, DEVELOPER_NREL_KEY) 
  
  #Run Aggregate Scenario
  scenario_report_scenario = reopt_post_processor.run_scenario_report(scenario_report, reopt_post_processor.scenario_reopt_default_assumptions_hash, reopt_post_processor.scenario_reopt_default_output_file, reopt_post_processor.scenario_timeseries_default_output_file)
  scenario_report_scenario.save('highE_scenario')
  
  #Run features individually  
  scenario_report_features = reopt_post_processor.run_scenario_report_features(scenario_report, reopt_post_processor.feature_reports_reopt_default_assumption_hashes, reopt_post_processor.feature_reports_reopt_default_output_files, reopt_post_processor.feature_reports_timeseries_default_output_files)
  scenario_report_features.save('highE_features')
end

### Mixed

desc 'Clear Mixed Scenario'
task :clear_mixed do
  puts 'Clearing Mixed Scenario...'
  mixed_scenario.clear
end

desc 'Run Mixed Scenario'
task :run_mixed do
  puts 'Running Mixed Scenario...'

  scenario_runner = URBANopt::Scenario::ScenarioRunnerOSW.new
  scenario_runner.run(mixed_scenario)
end

desc 'Post Process Mixed Scenario'
task :post_process_mixed do
  puts 'Post Processing Mixed Scenario...'
  
  default_reopt_post_processor = URBANopt::Scenario::ScenarioDefaultPostProcessor.new(mixed_scenario) 
  scenario_report = default_reopt_post_processor.run
  scenario_base = default_reopt_post_processor.scenario_base
  reopt_post_processor = URBANopt::REopt::REoptPostProcessor.new(scenario_report,scenario_base.scenario_reopt_assumptions_file, scenario_base.reopt_feature_assumptions, DEVELOPER_NREL_KEY) 
  
  #Run Aggregate Scenario
  scenario_report_scenario = reopt_post_processor.run_scenario_report(scenario_report, reopt_post_processor.scenario_reopt_default_assumptions_hash, reopt_post_processor.scenario_reopt_default_output_file, reopt_post_processor.scenario_timeseries_default_output_file)
  scenario_report_scenario.save('mixed_scenario')
  
  #Run features individually  
  scenario_report_features = reopt_post_processor.run_scenario_report_features(scenario_report, reopt_post_processor.feature_reports_reopt_default_assumption_hashes, reopt_post_processor.feature_reports_reopt_default_output_files, reopt_post_processor.feature_reports_timeseries_default_output_files)
  scenario_report_features.save('mixed_features')
  
end

### All

desc 'Clear all scenarios'
task :clear_all => [ :clear_high_efficiency, :clear_mixed] do
  # clear all the scenarios
end

desc 'Run all scenarios'
task :run_all => [ :run_baseline, :run_high_efficiency, :run_mixed] do
  # run all the scenarios
end

desc 'Post process all scenarios'
task :post_process_all => [ :post_process_baseline, :post_process_high_efficiency, :post_process_mixed] do
  # post_process all the scenarios
end

desc 'Run and post process all scenarios'
task :update_all => [:run_all, :post_process_all] do
  # run and post_process all the scenarios
end
              
task :default => :update_all
