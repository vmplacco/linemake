#!/bin/bash

## This just uses the inputs to make a giant list
./linemake.go < inputs_for_linemake/input_3000
mv outsort full_linemake3000.moog
./linemake.go < inputs_for_linemake/input_4000
mv outsort full_linemake4000.moog
./linemake.go < inputs_for_linemake/input_5000
mv outsort full_linemake5000.moog
./linemake.go < inputs_for_linemake/input_6000
mv outsort full_linemake6000.moog
./linemake.go < inputs_for_linemake/input_7000
mv outsort full_linemake7000.moog
./linemake.go < inputs_for_linemake/input_8000
mv outsort full_linemake8000.moog
rm outlines
