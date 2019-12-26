# REopt Lite enabled URBANopt Example Project

This project demonstrates how to integrate the REopt Gem into an URBANopt project. The REopt Gem makes calls to the <StaticLink target="\_blank" href="https://reopt.nrel.gov/tool">REopt Lite</StaticLink> decision support platform via API in order to determine cost-optimal sizing and dispatch of distributed energy resource (DER) technologies for a building (i.e. Feature Report) and/or collection of buildings (i.e. Scenario Report). 

REopt Lite is supported by a technoeconomic model which employs mixed integer linear programming and accessible via API. It is capable of selecting from Solar PV, Wind, Storage and Diesel Generation technologies and accepts a number of inputs regarding site location, load profile, electric tariff and financial assumptions (i.e. capital costs, escalation rates, incentives). Most inputs to the API are shown on the <StaticLink target="\_blank" href="https://reopt.nrel.gov/tool">REopt Lite</StaticLink> **Note:** You will need to expand *Advanced Options* to see all inputs.) For a complete set of inputs and more information about the API, see the <StaticLink target="\_blank" href="https://developer.nrel.gov/docs/energy-optimization/reopt-v1/">REopt Lite documentation</StaticLink>. 

**Note:** Using the REopt Gem requires an API Key from the <StaticLink target="\_blank" href="https://developer.nrel.gov/signup/">NREL Developer Network</StaticLink>.

## REopt Gem Overview
The REopt Lite Gem is activated during post-processing of a previously generated URBANopt::Scenario::DefaultReports::ScenarioReport or URBANopt::Scenario::DefaultReports::FeatureReport. The URBANopt::REopt::REoptRunner class is used to establish connections with the REopt Lite API and update Scenario Reports and Feature Reports. 

A REoptRunner is instantiated with at least an API Key, as follows:

```
DEVELOPER_NREL_KEY = '<insert API Key here>'
reopt_runner = URBANopt::REopt::REoptRunner.new(DEVELOPER_NREL_KEY)
```

Now the REopt Runner is ready to be used in the post-processing of a collection of features in aggregate (i.e. all loads are aggregating into one load profile that is sent to REopt Lite) or for a collection of features individually (i.e. REopt Lite is called on multiple load profiles before results are aggregated at the scenario level). The results from the former method would be reflective of centralized community scale assets and are invoked by the the REoptRunner _run_scenario_report_ method. The later would reflect individual asset ownership and operation and are invoked by _run_scenario_report_features_. See the <StaticLink target="\_blank" href="https://github.com/urbanopt/urbanopt-reopt-gem/">REopt Gem documentation</StaticLink> for other approaches to calling a Feature Report or set of Feature Reports.

To call REopt Lite on a Scenario Report in aggregate: 
```
updated_scenario_report = reopt_runner.run_scenario_report(scenario_report)
```
To call REopt Lite on a Scenario Report's features individually before aggregating results at the Scenario Report: 
```
updated_feature_report = reopt_runner.run_feature_report(feature_report)

```
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
    

## Demonstration Project

See the Rakefile in this directory for a demonstration of using the REopt Gem withinan URBANopt project. In this workflow example, REopt Lite assumptions that can be associated with Feature Reports and/or Scenario Reports are stored in a common directory, called _reopt_, as separate .json files. Assumptions are mapped to Feature Reports in the fourth column of a scenario CSV (as shown in baseline_scenario.csv) which is loaded by the URBANopt::Scenario::REoptScenarioCSV class. A REoptScenarioCSV is also optionally instantiated with the path the common REopt Lite assumptions folder (i.e. _reopt_) and the assumptions .json file in this folder to use in analysis at the aggregated Scenario Report level. Note, if either Scenario Report or Feature Report assumptions are specifed the _reopt_files_dir_ is then required.

A REoptScenarioCSV is loaded into a URBANopt::Scenario::ScenarioDefaultREoptPostProcessor before post-processing. On parsing the REoptScenarioCSV, the ScenarioDefaultREoptPostProcessor converts REopt Lite assumption files into hashes.

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

The ScenarioDefaultREoptPostProcessor also provides default files locations for saving REopt Lite responses and updating Timeseries CSV files:
```
default_reopt_post_processor.scenario_reopt_default_output_file
default_reopt_post_processor.scenario_timeseries_default_output_file

default_reopt_post_processor.feature_reports_reopt_default_output_files
default_reopt_post_processor.feature_reports_timeseries_default_output_files
```
