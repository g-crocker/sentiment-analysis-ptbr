#!/bin/bash

kubectl autoscale deployment analise-sentimento --cpu-percent=10 --min=1 --max=3
