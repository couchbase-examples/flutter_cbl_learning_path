#!/bin/bash
# must create the database first using something like this
# ./mac/cblite --create startingWarehouses.cblite2
#define filename
filename="warehouse.json"
dbFileName='startingWarehouses.cblite2'

#get amount of records to get out of file and split into new files
length=`cat $filename | jq -r '. | length'`

#loop through child array to get values out and save as seperate documents
for ((count=0;count<$length;count++))
do
	#get the json index for the current element in the array 
	itemIndex=".[$count]"

	#get the field that we want to use the name the file
	idIndex=".warehouseId"

	#get the json
	json=$(cat $filename | jq $itemIndex)
	id=$(echo $json | jq $idIndex)
	./mac/cblite put --create $dbFileName $id "$json"
done

# you can check by listing the files in the database
# $cblite ls -l --limit 10 $dbFileName