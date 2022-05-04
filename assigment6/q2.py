
"""
file: q2.py
description: CSCI-620.03 - HMWK6 Q2 Load the clean data in extraclean
language: python3, MongoDB
packages used = pymongo
author: prakhar gupta pg9349
"""


import pymongo
import time
myclient = pymongo.MongoClient("mongodb://localhost:27017/")
mydb = myclient["IMDB"]
members = mydb["members"]
movies=mydb["movies"]
extra = mydb["extra"]
extraclean=mydb["extraclean"]


extraclean.drop()
q=set()
mydoc=extra.find()
x=[]
exchange_rate=1
# exchange rates from https://fx-rate.net/

for i in mydoc:
    d={}
    if 'IMDb_ID' in i:
        if i['IMDb_ID']['value'][:2]!="tt":
            continue
        d['_id'] = int(i['IMDb_ID']['value'][2:])
    if 'box_office_currencyLabel' in i:
        #d['box_office_currencyLabel']=i['box_office_currencyLabel']['value']
        #q.add(d['box_office_currencyLabel'])
        if i['box_office_currencyLabel']['value']=='euro':
           exchange_rate=1.098068
        if i['box_office_currencyLabel']['value']=='Australian dollar':
           exchange_rate=0.751208
        if i['box_office_currencyLabel']['value']=='Egyptian pound':
           exchange_rate=0.05389
        if i['box_office_currencyLabel']['value']=='Russian ruble':
           exchange_rate=0.0098
        if i['box_office_currencyLabel']['value']=='Thai baht':
           exchange_rate=0.029765
        if i['box_office_currencyLabel']['value']=='Philippine peso':
           exchange_rate=0.019179
        if i['box_office_currencyLabel']['value']=='pound sterling':
           exchange_rate=1.3191
        if i['box_office_currencyLabel']['value']=='Indian rupee':
           exchange_rate=0.01311
        if i['box_office_currencyLabel']['value']=='United States dollar':
           exchange_rate=1
        if i['box_office_currencyLabel']['value']=='Hong Kong dollar':
           exchange_rate=0.12772
        if i['box_office_currencyLabel']['value'] == 'person':
            exchange_rate = 1
        if i['box_office_currencyLabel']['value']=='Czech koruna':
           exchange_rate=0.04473
        if i['box_office_currencyLabel']['value']=='1':
           exchange_rate=1

    if 'titleLabel' in i:
        d['titleLabel'] = i['titleLabel']['value']

    if 'cost' in i:
        d['cost'] = float(i['cost']['value'])*exchange_rate
    if 'distributorLabel' in i:
        d['distributorLabel'] = i['distributorLabel']['value']
    if 'box_office' in i:
        d['box_office'] = float(i['box_office']['value'])*exchange_rate
    if 'MPAA_film_ratingLabel' in i:
        d['MPAA_film_ratingLabel'] = i['MPAA_film_ratingLabel']['value']

    x.append(d)



#print(x[:2])
#print(x[1].keys())
s=set()
#extraclean.insert_many(x)
for i in x:
    if "_id" in i:
        if i['_id'] not in s:
            extraclean.insert_one(i)
            s.add(i["_id"])
print("inserted")
#print(q)

