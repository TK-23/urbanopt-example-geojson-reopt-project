import json
import os
import glob
import pandas as pd

scenario_folders = ['run/baseline_scenario','run/high_efficiency_scenario','run/mixed_scenario']


def concat_nested(d):
	result = {}
	for k,v in d.items():
		if type(v)==dict:
			for kk,vv in v.items():
				result[k+'_'+kk] = vv
		else:
			result[k] = v
	return result

rows = []
for scenario in scenario_folders:
	from_features = glob.glob(os.path.join(scenario,'*_features.json'))[0]
	from_scenario = glob.glob(os.path.join(scenario,'*_scenario.json'))[0]
	
	df = concat_nested(json.loads(open(from_features).read())['scenario_report']['distributed_generation'])
	ds = concat_nested(json.loads(open(from_scenario).read())['scenario_report']['distributed_generation'])
	df['scenario'] = scenario
	df['level'] = 'feature'
	ds['scenario'] = scenario
	ds['level'] = 'scenario'
	rows.append(df)
	rows.append(ds)

output = pd.DataFrame.from_records(rows).to_csv('compiled_results.csv')
