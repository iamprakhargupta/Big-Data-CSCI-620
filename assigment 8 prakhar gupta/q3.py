"""
file: q3.py
description: CSCI-620.03 - Hw8 Q3: Kmeans clustering
language: python3, MongoDB
packages used = pymongo
author: prakhar gupta pg9349
"""


import pymongo
import time
from math import pow,sqrt

def eucid(a,b):
    x1=a[0]
    y1=a[1]
    x2=b[0]
    y2=b[1]
    eu=sqrt((x1-x2)**2+(y1-y2)**2)
    return eu

def update_centroid(centroid,kstep):
    data=kstep.find()
    clusterdict={}
    for i in data:
        value=i['kmeansNorm']
        c=i['cluster']
        if c not in clusterdict:
            clusterdict[c]=[value]
        else:
            clusterdict[c].append(value)

    clustermean={}
    for k,v in clusterdict.items():
        x=0
        y=0
        l=len(v)
        for i in v:
            x+=i[0]
            y+=i[1]

        clustermean[k]=[x/l,y/l]
    #print(clustermean)
    centroid.drop()
    d={}
    for k,v in clustermean.items():
        d["_id"]=k
        d['kmeansNorm']=v
        centroid.insert_one(d)




def find_cluster(genre):
    myclient = pymongo.MongoClient("mongodb://localhost:27017/")
    mydb = myclient["IMDB"]

    movieskmeansnorm = mydb["movieskmeansnorm"]
    centroid = mydb["centroid"]
    kstep=mydb["kstep"]
    kstep.drop()
    #center=centroid.find().sort("_id",1)
    q=movieskmeansnorm.aggregate([{
        '$match': {
            'genres': genre
        }
    }
    ])

    for i in q:
        kdist = []
        center = centroid.find().sort("_id", 1)

        for j in center:
            # print(j['_id'])
            e=eucid(i['kmeansNorm'],j['kmeansNorm'])
            kdist.append(e)
        c=kdist.index(min(kdist))+1
        i["cluster"]=c
        kstep.insert_one(i)

    update_centroid(centroid,kstep)

if __name__=="__main__":
    find_cluster("Action")