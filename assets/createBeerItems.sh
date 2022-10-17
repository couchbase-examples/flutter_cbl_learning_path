#!/bin/bash
#
# Directions:
#
# must create the database first using something like this
# ./mac/cblite --create startingWarehouses.cblite2
#
# next must run script to create items
# python3 item_gen.py
#
# note taking this script can take a while to create 100,000 records
#

filename="beer_items.json" #data file
dbFileName='startingWarehouses.cblite2' #database file

length=3000 # only get 3000 items to put in the database

#loop through child array to get values out and save as seperate documents
for ((count=0;count<$length;count++))
do
	itemIndex=".[$count]" #get the json index for the current element in the array 
	idIndex=".itemId" #get the field that we want to use the name the file

	
	json=$(cat $filename | jq $itemIndex) #get the full json of an item
	id=$(echo $json | jq $idIndex) #get the value of the itemId field
	fullJson=$(echo $json | jq '.documentType="item"')

	# add to the database (if you are on a different platform 
	# change the folder location of cblite)
	./mac/cblite put --create $dbFileName $id "$fullJson"
done

# you can check by listing the files in the database
# $cblite ls -l --limit 10 $dbFileName