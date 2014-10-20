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

if [ ! -f $datafile ]; then
    echo "File not found, make sure you have entered the correct path"
    exit 1
fi

# Part 1: counting the number of genes in the human gff file

echo -n "* Number of genes on $datafile (please wait for result): "
cat $datafile | grep -Po 'gene_id "\K.*?(?=")' | sort | uniq | wc -l

# Part 2: Counting whether there are more exons on one strand than the other

echo "* Here are the counts of exons in forward and reverse direction: "

awk '
    BEGIN { countF=0; countR=0 } {
        if ($3 == "exon") {
            if ($7 == "+") countF++; else countR++;
        }
    }
    END { 
        printf "\t- Forward exon count: %s \n", countF; 
        printf "\t- Reverse exon count: %s \n", countR;
    }' $datafile

# Part 3: Retrieving the ID of the gene that has the most exons

echo "* Retrieving information on the gene with most exons: "
cat $datafile | grep "exon" | grep -Po 'gene_id "\K.*?(?=")' | uniq -c | 
awk '
    BEGIN { highestCount=0; name=""; } {
        if ($1 > highestCount) {
            name=$2; highestCount=$1;
        } 
    } 
    END { 
        printf "\t- Gene ID: %s \n", name;
        printf "\t- Number of exons: %s \n", highestCount;
    }'

echo "Done!" 
