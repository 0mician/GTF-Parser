#!/bin/bash

# Copyright (C) 2014 Cedric L.

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program. If not, see http://www.gnu.org/licenses/.

###########################################
# See readme.org for help on script usage #
###########################################

datafile=$1
pdb_dir=$2
saved_ids="uniq_pdb_ids.txt"

if [ $# -eq 0 ]; then
    echo "No arguments supplied! Please provide file name, and folder name"
    exit 1
fi

if [ ! -f $1 ]; then
    echo "The file $1 does not exist, please verify the path"
    exit 1
fi

if [ ! -d $2 ]; then
    mkdir $2
fi

# Collecting all unique IDs from the original sequence file

echo "Collecting unique IDs from $datafile"

cat $datafile | egrep -wi "ALDEHYDE.*DEHYDROGENASE" | cut -c2-5 | sort | uniq > $saved_ids

# Retrieving the pdb files for each of the IDs

echo "Downloading all files from server, this may take a while"

while read line 
do
    curl http://www.rcsb.org/pdb/files/$line.pdb > $pdb_dir/$line.pdb
done < $saved_ids

# Removing files not related to HOMO SAPIENS

echo "Removing files not related to HOMO SAPIENS"

FILES=$pdb_dir/*
for file in $FILES
do
    if ! grep --quiet "HOMO SAPIENS" $file; then
        rm $file
    fi
done

echo "Done!"
