import pymongo
import time
myclient = pymongo.MongoClient("mongodb://localhost:27017/")
mydb = myclient["IMDB"]
members = mydb["members"]
movies=mydb["movieskmeans"]
movieskmeansnorm = mydb["movieskmeansnorm"]

t0=time.time()
movieskmeansnorm.drop()


knormdict={}

startyear_max=movies.find().sort("startYear",-1).limit(1)
startyear_min=movies.find().sort("startYear",1).limit(1)


for i in startyear_min:
    knormdict["startYearmin"]=i["startYear"]

for i in startyear_max:
    knormdict["startYearmax"]=i["startYear"]


avgrating_max=movies.find().sort("avgrating",-1).limit(1)
avgrating_min=movies.find().sort("avgrating",1).limit(1)


for i in avgrating_min:
    knormdict["avgratingmin"]=i["avgrating"]

for i in avgrating_max:
    knormdict["avgratingmax"]=i["avgrating"]


print(knormdict)
range2=knormdict["avgratingmax"]-knormdict["avgratingmin"]

range1=knormdict["startYearmax"]-knormdict["startYearmin"]

m=movies.find()

for i in m:
    #print(i)
    startyear_norm=(i["startYear"]-knormdict["startYearmin"])/range1
    avgrating_norm=(i["avgrating"]-knormdict["avgratingmin"])/range2
    knorm=[startyear_norm,avgrating_norm]
    i['kmeansNorm']=knorm
    movieskmeansnorm.insert_one(i)
    # x = mycol.insert_one(mydict)
    # x = mycol.insert_one(mydict)

