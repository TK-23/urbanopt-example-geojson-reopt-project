# REopt Lite enabled URBANopt Example Project

This project demonstrates how to integrate the REopt Gem into an URBANopt project. The REopt Gem makes calls to the <a target="\_blank" href="https://reopt.nrel.gov/tool">REopt Lite</a> decision support platform via API in order to determine cost-optimal sizing and dispatch of distributed energy resource (DER) technologies for a building (i.e. Feature Report) and/or collection of buildings (i.e. Scenario Report). 

REopt Lite is supported by a technoeconomic model which employs mixed integer linear programming and accessible via API. It is capable of selecting from Solar PV, Wind, Storage and Diesel Generation technologies and accepts a number of inputs regarding site location, load profile, electric tariff and financial assumptions (i.e. capital costs, escalation rates, incentives). Most inputs to the API are shown on the <a target="\_blank" href="https://reopt.nrel.gov/tool">REopt Lite</a> _You will need to expand *Advanced Options* to see all inputs._ For a complete set of inputs and more information about the API, see the <a target="\_blank" href="https://developer.nrel.gov/docs/energy-optimization/reopt-v1/">REopt Lite documentation</a>. 

The REopt Gem accomplishes three basic functions:

	1. Accept a json/hash of assumptions
	2. Updates the distributed_generation attributes of a Feature Report or Scenario Report based on a cost-optimal DER system
	3. Updates the timeseries attributes of a Feature Report or Scenario Report based on the dispatch of a cost-optimal DER system

The REopt Gem can be run in several modes, either on:

	 * a Feature Report, 
	 * a collection of Feature Reports - 
	 * all the features in a Scenario Report before aggregating results at the scenario level
	 * the collection of features in aggregate as summarized in a Scenario Report

You'll find a description of common workflows below, but for more information regarding the REopt Gem itself, see: https://github.com/urbanopt/urbanopt-reopt-gem/

The sections in this document include:

  1. Workflow Overview
  2. Jupyter Notebook Workflow Example
  3. Workflow Example
  4. Running a Complete Project

## Workflow Overview

The REopt Lite Gem is activated during post-processing of previously generated URBANopt::Scenario::DefaultReports::ScenarioReport and URBANopt::Scenario::DefaultReports::FeatureReport objects. The URBANopt::REopt::REoptRunner class is used to establish connections with the REopt Lite API and update ScenarioReports and FeatureReports. REoptRunner is instantiated with at least an API Key, as follows:

```
DEVELOPER_NREL_KEY = '<insert API Key here>'
reopt_runner = URBANopt::REopt::REoptRunner.new(DEVELOPER_NREL_KEY)
```

Now the REopt Runner is ready to be used in the post-processing of a collection of features in aggregate (i.e. all loads are aggregating into one load profile that is sent to REopt Lite) or for a collection of features individually (i.e. REopt Lite is called on multiple load profiles before results are aggregated at the scenario level). The results from the former approach (which is invoked by the the REoptRunner _run_scenario_report_ method) would be reflective of centralized community scale assets. The later would reflect individual asset ownership and operation, and is invoked by _run_scenario_report_features_. See the <a target="\_blank" href="https://github.com/urbanopt/urbanopt-reopt-gem/">REopt Gem documentation</a> for other approaches to calling a Feature Report or set of Feature Reports.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; To call REopt Lite on a Scenario Report in aggregate:<br/> 
```
updated_scenario_report = reopt_runner.run_scenario_report(scenario_report)
```
<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; To call REopt Lite on a Scenario Report's features individually before aggregating results at the Scenario Report:<br/> 

```
updated_feature_report = reopt_runner.run_feature_report(feature_report)
```
<br/>
Regardless of approach, REopt results are stored in the Feature or Scenario Report's distributed_generation attributes, formatted as shown in an example below:

```
	"distributed_generation": {
	      "lcc_us_dollars": 100000000.0,
	      "npv_us_dollars": 10000000.0,
	      "year_one_energy_cost_us_dollars": 7000000.0,
	      "year_one_demand_cost_us_dollars": 3000000.0,
	      "year_one_bill_us_dollars": 10000000.0,
	      "total_energy_cost_us_dollars": 70000000.0,
	      "solar_pv": {
	        "size_kw": 30000.0
	      },
	      "wind": {
	        "size_kw": 0.0
	      },
	      "generator": {
	        "size_kw": 0.0
	      },
	      "storage": {
	        "size_kw": 2000.0,
	        "size_kwh": 5000.0
	      }
	    }
```

Moreover, the following optimal dispatch fields are added to a Feature Report or Scenario Reports's timeseries CSV after calling REopt Lite via the REopt gem. Where no system component is recommended the dispatch will be all zero for all timesteps (i.e. if no solar PV is recommended ElectricityProduced:PV:Total will be zero for all timesteps)

|            output                        |  unit   |
| -----------------------------------------| ------- |
| ElectricityProduced:Total                | kWh     |
| Electricity:Load:Total                   | kWh     |
| Electricity:Grid:ToLoad                  | kWh     |
| Electricity:Grid:ToBattery               | kWh     |
| Electricity:Storage:ToLoad               | kWh     |
| Electricity:Storage:ToGrid               | kWh     |
| Electricity:Storage:StateOfCharge        | kWh     |
| ElectricityProduced:Generator:Total      | kWh     |
| ElectricityProduced:Generator:ToBattery  | kWh     |
| ElectricityProduced:Generator:ToLoad     | kWh     |
| ElectricityProduced:Generator:ToGrid     | kWh     |
| ElectricityProduced:PV:Total             | kWh     |
| ElectricityProduced:PV:ToBattery         | kWh     |
| ElectricityProduced:PV:ToLoad            | kWh     |
| ElectricityProduced:PV:ToGrid            | kWh     |
| ElectricityProduced:Wind:Total           | kWh     |
| ElectricityProduced:Wind:ToBattery       | kWh     |
| ElectricityProduced:Wind:ToLoad          | kWh     |
| ElectricityProduced:Wind:ToGrid          | kWh     |
    
## Jupyter Notebook Workflow Example

For a Jupyter Notebook based tutorial, first run:

	$ bundle install
	$ bundle update

Next, run the following to open a notebook that will open in a browser window:

	$  iruby notebook 'WorkflowTutorial.ipynb'

Otherwise, see the workflow section that follows.
## Workflow Example

To understand how to use the REopt Gem in the context of a larger URBANopt project, see the Rakefile in this directory for a demonstration which runs three scenarios: a baseline, a high efficiency case, and a mixed case. 

### Setup
To help illustrate the setup process, we have reproduced code from the Rakefile for the baseline scenario below.  
The setup is important to a REopt analysis in that it sets up which REopt Lite assumptions (i.e. choice of technologies to analyze, captial cost assumptions, etc) to use for Feature Reports and Scenario Reports. If you wish to use standard default assumptions from the API then you do not actually need to set up assumptions as shown here. Note, however, that at the time of writing this documentation, setting the utility rate is only possible as an update to assumptions. If no utility rate is specified, the REopt Gem will assume a constant rate of $0.13/kWh with no demand charges. 

REopt Lite assumptions themselves are stored as .json files, formatted according to the conventions established in the <a target="\_blank" href="https://developer.nrel.gov/docs/energy-optimization/reopt-v1/">REopt Lite documentation</a>, and saved in a common directory (See the _reopt_ directory).  Assumptions are mapped to Feature and Scenario Reports during the instantiation of a **URBANopt::Scenario::REoptScenarioCSV**. Feature Report assumption mapping is defined in the the fourth column of the scenario's input CSV (See _baseline_scenario.csv_) and to Scenario Reports via input parameters to the **REoptScenarioCSV** . _Importantly_, if custom REopt assumptions are to be used for either a Feature Report or Scenario Report, then the **REoptScenarioCSV** must be instantiated with the path to a common REopt Lite assumptions folder (i.e. _reopt_) and asssumption .json files must all be saved in this folder; otherwise this _reopt_files_dir_ input is optional. 

```
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
```

### Running the Scenario and Post Processing
REopt Lite is not actually run on a Feature Report or Scenario Report until post-processing. Again, to illustrate this process we have reproduced code for the baseline scenario below. 

First, the scenario setup is passed to a **URBANopt::Scenario::ScenarioDefaultPostProcessor** to parse the OpenStudio model results, and then retrieve the updated scenario_base object. 

Next, the resulting scenario report and scenario_base are passed to a **URBANopt::REopt::REoptPostProcessor**. If REopt assumption to Feature Report mappings were made in the CSV loaded by REoptScenarioCSV (see previous step), then the associated .json files will be parsed into an ordered list of hashes that matches the order of Feature Reports within the REoptPostProcessor as an attribute called _feature_reports_reopt_default_assumption_hashes_. Likewise, if the REoptScenarioCSV is instantiated with scenario level REopt Lite assumptions then these assumptions will be available as a hash called _scenario_reopt_default_assumptions_hash_. Successful creation of _feature_reports_reopt_default_assumption_hashes_ and _scenario_reopt_default_assumptions_hash_ attributes requires that the REoptScenarioCSV be instantiated with a _reopt_files_dir_ parameter.

Moreover, if the REoptPostProcessor is instantiated with a Scenario Report as the first argument, the REoptPostProcessor will automatically contain attributes that are helpful in future steps, including:
	_scenario_reopt_default_output_file_ - the default location to write scenario level REopt results
	_scenario_timeseries_default_output_file_ - the default location to write scenario level updated timeseries CSV files
	_feature_reports_reopt_default_output_files_ - an ordered list of default locations to write feature level REopt results
	_feature_reports_timeseries_default_output_files_ - an ordered list of default locations to write feature level timeseries CSV files

```
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

end
```

After instantiating the REoptPostProcessor, the code above runs an analysis at the scenario level, and then at the feature level. In each case, custom REopt assumption hashes, REopt result file locations, and updated timeseries CSV file locations are all parsed from the REoptPostProcessor. Each of these settings can also be overwritten by passing addtional optional parameters to the _run_scenario_report_ and _run_scenario_report_features_ methods as described in the <a target="\_blank" href="https://github.com/urbanopt/urbanopt-reopt-gem/">REopt Gem documentation</a>.

Ultimately, in this example updated scenario and feature level results are exported as separate files for further analysis.


## Running a Complete Project

To run the full example project, including the baseline, high efficiency and mixed scenarios, run:

```
bundle install
bundle update
bundle exec rake
```
This example project includes 13 commercial and residential sites. All sites are first simulated for one year in OpenStudio  according to the scenario's mapper files. This initial process creates and populates a "run" folder, with subfolders for each scenario. 

Next, for each scenario, REopt is used to assess optimal solar and storage configurations at both the feature level (i.e. individual ownership of assets) and aggregated scenario level (i.e. community-scale resources). This process creates updated Scenario Report hashes and timeseries CSV files in the scenario's subfolder within the "run" folder that can be furthermore visualized and analyzed.
