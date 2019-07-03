# -*- coding: utf-8 -*-
"""
Created on Wed Mar  6 18:07:10 2019

@author: HNCase
"""

import pandas as pd
import numpy as ny

call_score = pd.read_csv("call_score_20190211.csv") 
call_score_detail = pd.read_csv("call_score_detail_20190211.csv")
call_no_score = pd.read_csv("call_noscore_20190211.csv")

## Data exploration and cleansing 
## Call Score
pd.isnull(call_score.status).sum()
pd.isnull(call_score.agent_id).sum()
pd.isnull(call_score.acct_date_time).sum()
pd.isnull(call_score.switch_call_key).sum()
pd.isnull(call_score.sec_duration).sum()
pd.isnull(call_score.leadkey).sum()

## Call Score Details
pd.isnull(call_score_detail.agent_id).sum()
pd.isnull(call_score_detail.switch_call_key).sum()

## Call No Score
pd.isnull(call_no_score.status).sum()
pd.isnull(call_no_score.agent_id).sum()
pd.isnull(call_no_score.acct_date_time).sum()
pd.isnull(call_no_score.switch_call_key).sum()
pd.isnull(call_no_score.sec_duration).sum()
pd.isnull(call_no_score.leadkey).sum()
call_ns_clean = call_no_score.dropna(subset=['agent_id'])

## Exploratory analysis
aggregation = {
	'agent_id': {
		'total_agents': lambda x: len(x.unique())
	},
	'ukey': {
		'num_calls': 'count'
	},
	'score_percentage': {
		'avg_score': 'mean'
	},
    'revenue': {
		'tot_rev': 'sum'
	},
}
call_score.groupby('acct_nbr').agg(aggregation)
call_score[call_score['acct_nbr'] == 14310].groupby('agent_id').agg(aggregation)
call_score[call_score['acct_nbr'] == 14328].groupby('agent_id').agg(aggregation)
call_score[call_score['acct_nbr'] == 14378].groupby('agent_id').agg(aggregation)
call_score[call_score['acct_nbr'] == 14385].groupby('agent_id').agg(aggregation)
call_score[call_score['acct_nbr'] == 14409].groupby('agent_id').agg(aggregation)
call_score[call_score['acct_nbr'] == 14510].groupby('agent_id').agg(aggregation)
call_score[call_score['acct_nbr'] == 14513].groupby('agent_id').agg(aggregation)
call_score[call_score['acct_nbr'] == 14520].groupby('agent_id').agg(aggregation)
call_score[call_score['acct_nbr'] == 14551].groupby('agent_id').agg(aggregation)
call_score[call_score['acct_nbr'] == 14567].groupby('agent_id').agg(aggregation)
call_score[call_score['acct_nbr'] == 14578].groupby('agent_id').agg(aggregation)
call_score[call_score['acct_nbr'] == 14588].groupby('agent_id').agg(aggregation)
call_score[call_score['acct_nbr'] == 14592].groupby('agent_id').agg(aggregation)
call_score[call_score['acct_nbr'] == 14596].groupby('agent_id').agg(aggregation)
call_score[call_score['acct_nbr'] == 14597].groupby('agent_id').agg(aggregation)
call_score[call_score['acct_nbr'] == 14631].groupby('agent_id').agg(aggregation)
call_score[call_score['acct_nbr'] == 15330].groupby('agent_id').agg(aggregation)
