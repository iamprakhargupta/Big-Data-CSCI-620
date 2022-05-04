import pymongo
import time

def get_centroid(genre,k,drop=True):
    query=[
    {
        '$unwind': f'$genres'
    }, {
        '$match': {
            'genres': genre
        }
    }, {
        '$sample': {
            'size': k
        }
    }
    ]
    myclient = pymongo.MongoClient("mongodb://localhost:27017/")
    mydb = myclient["IMDB"]

    movieskmeansnorm = mydb["movieskmeansnorm"]
    centroid = mydb["centroid"]
    if drop:
        centroid.drop()
    result=movieskmeansnorm.aggregate(query)
    v=1
    d={}
    for i in result:
        d['kmeansNorm']=i['kmeansNorm']

        d["_id"]=v
        #print(i)
        centroid.insert_one(d)
        v+=1



def driver():
    genre=input()
    k=int(input())
    get_centroid(genre,k)

if __name__=="__main__":
    driver()