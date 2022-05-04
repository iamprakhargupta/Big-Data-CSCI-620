"""
file: q5.py
description: CSCI-620.03 - Hw8 Q5: Running it for optimal K
language: python3, MongoDB
packages used = pymongo
author: prakhar gupta pg9349
"""


from q4 import *



def create_collection(genre):
    myclient = pymongo.MongoClient("mongodb://localhost:27017/")
    mydb = myclient["IMDB"]


    kstep = mydb["kstep"]
    genrecollection=mydb[f"{genre}_clusters"]
    data=kstep.find()
    for i in data:
        genrecollection.insert_one(i)



def driver():
    genre=["Action","Horror","Romance","Sci-Fi","Thriller"]
    k=[25,15,30,25,35]
    for g in range(len(genre)):

        e=kmean(genre[g],100,k[g])
        create_collection(genre[g])
        print(f"Create {genre[g]} using K as {k[g]}" )

driver()

