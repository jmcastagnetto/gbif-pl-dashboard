#! /bin/bash

if [ ! -d ./tmp ]
then
	mkdir tmp
fi
Rscript preproc-data.R
