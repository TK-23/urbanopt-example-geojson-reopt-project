# REopt Lite enabled URBANopt Example Project

This project demonstrates how to integrate the REopt Gem into an URBANopt project. The REopt Gem makes calls to (REopt Lite)[https://reopt.nrel.gov/tool] decision support platform in order to determine optimal distributed energy resource (DER) technology selection, sizing, dispatch and economics for a buliding (i.e. Feature Report) or collection of buildings (i.e. Scenario Report). 

REopt Lite is supported by a technoeconomic model which employs mixed integer linear programming and accessible via API. It is capable of selecting from Solar PV, Wind, Storage and Diesel Generation technologies and accepts a number of inputs regarding site location, load profile, electric tariff and financial assumptions (i.e. capital costs, escalation rates, incentives). All inputs to the API are shown on the (REopt Lite webtool)[https://reopt.nrel.gov/tool] **Note:** You will need to expand *Advanced Options* to see all inputs.) Also, see the (REopt Lite documentation)[https://developer.nrel.gov/docs/energy-optimization/reopt-v1/] for more information regarding API inputs and formatting. **Note:** Using the REopt Gem requires an API Key from the (NREL Developer Network)[https://developer.nrel.gov/signup/].

The REopt Lite Gem is activated during post-processing of previously generated URBANopt::Scenario::DefaultReports::ScenarioReport and URBANopt::Scenario::DefaultReports::FeatureReport objects. The URBANopt::REopt::REoptRunner class is used to establish connections with the REopt Lite API and update ScenarioReports and FeatureReports. REoptRunner is instantiated with at least an API Key, as follows:

```
DEVELOPER_NREL_KEY = '<insert API Key here>'
reopt_runner = URBANopt::REopt::REoptRunner.new(DEVELOPER_NREL_KEY)
```

Subsequently, the REopt Runner can be used to optimize DER sizing for a collection of features in aggregate (i.e. all loads are aggregating into one load profile) by passing to it at least a ScenarioREport via the _run_scenario_report_ method. The results from such optimizations would be reflective of centralized community scale assets.

During the call to the REopt Lite API made as part of calling this method, default assumptions will be used for all parameters except latitude, longitude, and load profile unless otherwise specified in the _reopt_assumptions_hash_ input. The_reopt_assumptions_hash_ must be formatted in a nested structure as specified in the (REopt Lite documentation)[https://developer.nrel.gov/docs/energy-optimization/reopt-v1/]. For an example, see reopt/base_assumptions.json in this folder. Moreover, default files for saving the REopt Lite JSON response and the updated Scenario Report Timeseries CSV will be used unless specified explicitly in the _reopt_output_file_ and _timeseries_csv_path_ inputs respectively. 


```
updated_scenario_report = reopt_runner.run_scenario_report(scenario_report)

p updated_scenario_report.timeseries.path

```
An updated Scenario REport contains the following new (or updated) attributes.
* timeseries.path (updated to the x,y,z dispatch columns)
* sizes (pv, wind, generator, storage)
* financials


Likewise, the REopt Runner can be used to optimize DER sizing for a individual site by passing to it at least a FeatureREport via the _run_feature_report_ method. Again, REopt Lite assumptions (formatted as described in (REopt Lite documentation)[https://developer.nrel.gov/docs/energy-optimization/reopt-v1/]) can be defined as in input. Also, default files for saving the REopt Lite JSON response and the updated Scenario Report Timeseries CSV will be used unless specified explicitly in the _reopt_output_file_ and _timeseries_csv_path_ inputs respectively. 

```
updated_feature_report = reopt_runner.run_feature_report(feature_report)

p updated_feature_report.timeseries.path

```
An updated Feature REport also contains the following new (or updated) attributes.
* timeseries.path (updated to the x,y,z dispatch columns)
* sizes (pv, wind, generator, storage)
* financials



A collection of Feature Reports can be run from an array of FeatureReports.
```
feature_reports = [feature_report1, feature_report2]

updated_feature_reports = reopt_runner.run_feature_report(feature_reports)

updated_feature_reports.each do |feature_report|
	p feature_report.timeseries.path
end

```
Note that the optional _reopt_assumptions_hashes_, _reopt_output_files_, and _timeseries_csv_paths_ accept ordered arrays of inputs that match the order of the _feature_reports_ array.


Finally, a Scenario Report can be updated by first running each of its Feature Reports and then aggregating the reponses from each of the Feature Reports to the Scenario Report level via the _run_scenario_report_features_ method. Again, the optional _reopt_assumptions_hashes_, _reopt_output_files_, and _timeseries_csv_paths_ accept ordered arrays of inputs that match the order of the _feature_reports_ array within the Scenario Report.
```
updated_feature_reports = reopt_runner.run_scenario_report_features(scenario_report)

updated_feature_reports.each do |feature_report|
	p feature_report.timeseries.path
end

```


See Rakefile for a demonstration of loading REopt settings in an URBANopt project. In this workflow, optional REopt Lite assumptions are stored in a common directory as separate .json files. Assumptions relating to Feature Reports are defined in the fourth column of a scenario CSV (as shown in baseline_scenario.csv) which is loaded by the URBANopt::Scenario::REoptScenarioCSV class. A REoptScenarioCSV is also optionally instantiated with the path the common REopt Lite assumptions folder and the assumptions file to use at the aggregated Scenario Report level. Note, if Scenario Report or Feature Report assumptions are specifed the _reopt_files_dir_ is then required.


A REoptScenarioCSV is loaded into a URBANopt::Scenario::ScenarioDefaultREoptPostProcessor before post-processing. On loading, the default REopt Lite assumptions are loaded into hashes accessible as follows:
```
baseline_scenario = URBANopt::Scenario::REoptScenarioCSV.new(name, root_dir, run_dir, feature_file, mapper_files_dir, csv_file, num_header_rows, reopt_files_dir, scenario_reopt_assumptions_file_name)

default_reopt_post_processor = URBANopt::Scenario::ScenarioDefaultREoptPostProcessor.new(baseline_scenario)

default_reopt_post_processor.scenario_reopt_default_assumptions_hash

default_reopt_post_processor.feature_reports_reopt_default_assumption_hashes

```

The ScenarioDefaultREoptPostProcessor also provides default files locations for saving REopt Lite responses and updating Timeseries CSV files:
```
default_reopt_post_processor.scenario_reopt_default_output_file
default_reopt_post_processor.scenario_timeseries_default_output_file

default_reopt_post_processor.feature_reports_reopt_default_output_files
default_reopt_post_processor.feature_reports_timeseries_default_output_files
```




