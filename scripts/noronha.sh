#!/bin/bash

nha model new \
 --name sentiment-clf \
 --desc 'Sentiment classifier' \
 --model-file '{"name": "sentiments.joblib", "desc": "Pickle with the trained model", "required": true, "max_mb": 1024}' \
 --data-file '{"name": "tweets.csv", "desc": "CSV with tweets", "required": true, "max_mb": 1024}'

nha movers new \
 --name experiment-v1 \
 --model sentiment-clf \
 --path "models/sentiments.joblib"

nha proj new \
 --name sentiments \
 --desc "Experiments with sentiment prediction" \
 --model sentiment-clf

nha -d -p proj build --name sentiments \
 && docker images | grep sentiments

nha -d -p note \
 --proj sentiments \
 --port 30090 \
 --movers sentiment-clf:experiment-v1 \
 --edit

nha -d -p train new \
 --proj sentiments \
 --name experiment-v2 \
 --nb notebooks/train \
 --params '{"alpha": 0.002}' \
 --dataset sentiment-clf:tweets-ptbr-v1

nha -d -p depl new \
--proj sentiments \
--name prediction \
--nb notebooks/predict \
--port 30050 \
--movers sentiment-clf:experiment-v2 \
--resource-profile light-request

