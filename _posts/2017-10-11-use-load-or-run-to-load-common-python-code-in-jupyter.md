---
layout: post
title: use %load or %run to load common python code in jupyter
description: It would be better that we create a nb_global.py or so to be share in multiple notebooks.
tags: 
    - python
    - jupyter
---

# Use %load or %run to load common python code in jupyter

It would be a little trouble if many notebooks have the same initial code, such as imports and helpers. If these code need to be changed. We have to edit them individually. Also, for new notebooks we have to add the code manually. It would be better that we create a nb_global.py or so to be loaded in multiple notebooks.

For example we create a **nb_global.py** and the content is like below:
``` py
import numpy as np
import pandas as pd
import datetime
import dateutil.parser

from pymongo import MongoClient, InsertOne, DeleteMany, ReplaceOne, UpdateOne

DB_ENDPOINT= "localhost"
DB_PORT= 27017
mongo_client = MongoClient(DB_ENDPOINT, DB_PORT)

def bulk_process(func_get, func_exec, size):
    offset = 0
    while True:
        data = func_get(offset, size)

        if data is None or len(data) == 0:
            break
    
        func_exec(data)
    
        count = len(data)
        offset = offset + count
        if count < size:
            break

def parse_date(date):
    if type(date) is datetime.date or type(date)is datetime.datetime:
        return date
    
    if date is None or '' == date:
        return None
    
    return dateutil.parser.parse(date)
```

It defines imports, some variables and some functions.

There are 3 methods to load nb_global.py:  

## 1. import nb_global

This method is like we do in regular python. 
The disadvantage is that in order to call a member, we have to type module name. For example, for mongo_client, we have to type `nb_global.mongo_client`.

## 2. %load nb_global.py or %loadpy nb_global

We can use these two build-in magic functions to load nb_global.py

This function will load the content of nb_global.py into the cell as below illustration.

![demo](/assets/images/2017-10-12-jupyter-load-1.gif)

The advantage of this method is you can have a independent init code. If we want to re-load nb_global.py, we just remove the `#` and run the cell again, but the bad site is that if the content of nb_global.py is too long, the cell will be long, too.

> %loadpy is an alias of %load file + ".py"

## 3. %run nb_global.py

This is recommended method. Jupyter runs nb_global.py in the same context, so we can use all the members in nb_global.py on others cells directly as below illustration.

![demo](/assets/images/2017-10-12-jupyter-load-2.png)

> You can read this page to see all build-in magic functions http://ipython.readthedocs.io/en/stable/interactive/magics.html