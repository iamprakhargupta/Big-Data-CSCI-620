from q3 import find_cluster
from q2 import get_centroid

import pymongo
import pandas as pd
import time
from math import pow,sqrt

def _sse(a,b):
    import operator
    x=map(operator.sub, a, b)
    y=sum(x)**2
    return y

#
# print(_sse([1,1],[2,2]))

def sse(kstep,centroid):
    d=kstep.find()
    center=centroid.find().sort("_id", 1)
    cluster_mean={}
    sumsqerror={}
    error=0
    for i in center:
        cluster_mean[i["_id"]]=i['kmeansNorm']
        sumsqerror[i["_id"]]=0

    for i in d:
        c=i["cluster"]
        a=cluster_mean[c]
        b=i['kmeansNorm']
        error+=_sse(a,b)

    return error



def kmean(genre,iters=100,k=10):
    myclient = pymongo.MongoClient("mongodb://localhost:27017/")
    mydb = myclient["IMDB"]

    movieskmeansnorm = mydb["movieskmeansnorm"]
    centroid = mydb["centroid"]
    kstep = mydb["kstep"]

    get_centroid(genre,k)
    for i in range(0,iters):
        find_cluster(genre)
    error=sse(kstep,centroid)
    #print(str(i)+" iter :" +str(error))
    return error


def driver():
    genre=["Action","Horror","Romance","Sci-Fi","Thriller"]
    for g in genre:
        print(f"-------{g}--------")
        print()
        g1={}
        df=pd.DataFrame(columns=["cluster","SSE"])
        for i in range(10,51,5):
            e=kmean(g,100,i)
            print(str(i)+" cluster :" +str(e))
            dfnew=pd.DataFrame({"cluster":[i],"SSE":[e]})
            df=pd.concat([df,dfnew],ignore_index=True)
        print()
        df.to_csv(f"{g}_100.csv",index=False)


if __name__=="__main__":
    driver()