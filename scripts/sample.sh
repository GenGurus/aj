#!/bin/sh

brightnow="$(brightnessctl g)"
brightmax="$(brightnessctl m)"

brightpercent=$(awk "BEGIN {print ${brightnow}/${brightmax}*100}")

echo $brightpercent
