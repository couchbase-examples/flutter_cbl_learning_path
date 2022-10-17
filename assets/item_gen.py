# Python item generator based on silly rules
# Author:  Aaron LaBeau
# Date:  06/27/2022
#
# generates items based on https://www.tpc.org/tpc_documents_current_versions/pdf/tpc-c_v5.11.0.pdf
# see page 65
#
# DEPENDENCIES:
# pip3 install -U jsonpickle
#
# item schema
# 	{
# 		"itemId": "",
# 		"name": "",
# 		"price": "",
# 		"description": "",
# 		"documnentType": "item"
# 	}

import json
import random
import uuid
import jsonpickle

from decimal import Decimal

# open seed file
with open("item_data_seed.json") as json_file:

    # define beer class to use for serialization
    class BeerItem:
        def __init__(self, name, description):
            self.itemId = str(uuid.uuid4())
            self.name = name
            self.price = round(random.uniform(1.00, 100.00), 2)
            self.description = description
            self.documentType = "item"

        def __str__(self):
            print(
                f"{self.name} {str(self.price)} {str(self.itemId)} {self.description}"
            )

    # set encoding options to allow for unicode characters
    jsonpickle.set_preferred_backend("json")
    jsonpickle.set_encoder_options("json", ensure_ascii=False)

    # start by loading the file into a dictionary
    data = json.load(json_file)

    # how many random items to create
    how_many_items = 100001

    # keys for flavors dict
    key_flavors = "flavors"
    key_herbs = "herbs"
    key_spices = "spices"

    # keys for beer name
    key_prefix = "prefix"
    key_name = "name"
    key_suffix = "suffix"

    # lists to hold values until they can be serialized
    beer_name = []
    beer_items = []

    # used to get indexes for random injection of the word ORIGINAL which must be in
    # 10% of the items randomly
    random_origin_index = []
    random_origin_counter = 0
    is_ten_percent_full = False
    print("Getting random indexes for ORIGINAL in description")
    while is_ten_percent_full == False:
        random_index = random.randint(0, 100000)
        if random_index not in random_origin_index:
            random_origin_index.append(random_index)
            random_origin_counter += 1
        if how_many_items / random_origin_counter <= 10:
            is_ten_percent_full = True

    print("Generating Data")
    for index in range(how_many_items):
        is_repeat = True
        while is_repeat == True:
            flavor = ""
            # business rule is we want to pick flavors instead of herb or spice most of the time
            which_flavor = random.randint(1, 10)
            if which_flavor <= 6:
                flavor = random.choice(data[key_flavors])
            elif which_flavor == 7 or which_flavor == 8:
                flavor = random.choice(data[key_herbs])
            else:
                flavor = random.choice(data[key_spices])

            prefix = random.choice(data[key_prefix])
            name = random.choice(data[key_name])
            suffix = random.choice(data[key_suffix])
            gen_item_name = f"{flavor} {name} {suffix}"

            # calculate adding in ORIGINAL for 10% of records
            if index in random_origin_index:
                gen_item_description = (
                    f"{prefix} {suffix} ORIGINAL with {flavor} flavors"
                )
            else:
                gen_item_description = f"{prefix} {suffix} with {flavor} flavors"

            if gen_item_name not in beer_name:
                beer_name.append(gen_item_name)
                beer_items.append(BeerItem(gen_item_name, gen_item_description))
                is_repeat = False

    # serialize to json
    print("Serializing Data")
    json_objects = jsonpickle.encode(beer_items, unpicklable=False)

    print("Writing to Disk")
    # writing items to disk
    with open("beer_items.json", "w") as outfile:
        outfile.write(json_objects)

    print("Data Generation Completed")
