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

datafile="pdb_seqres.txt"
saved_ids="uniq_pdb_ids.txt"
pdb_dir=$(mkdir dl_pdb)

cat $datafile | egrep -wi "ALDEHYDE.*DEHYDROGENASE" | cut -c2-5 | sort | uniq > $saved_ids

while read line 
do
    curl http://www.rcsb.org/pdb/files/$line.pdb > $(pdb_dir)/$(line).pdb
done < $saved_ids
