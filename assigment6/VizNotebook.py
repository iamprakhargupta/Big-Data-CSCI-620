#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pymongo
import time
import pandas as pd
myclient = pymongo.MongoClient("mongodb://localhost:27017/")
mydb = myclient["IMDB"]
members = mydb["members"]
movies=mydb["movies"]


# In[2]:


import seaborn as sns
import matplotlib.pyplot as plt


# In[11]:



myquery1 = [{
            '$match': {
            'numvotes': {
                '$gt': 10000
            }
        }},
    {
        '$unwind': '$genres'
    }, {
        '$project': {
            'genres': 1,
            'avgrating': 1
        }
    }
]

# result.drop()

mydoc = movies.aggregate(myquery1)


# In[12]:


df=pd.DataFrame(list(mydoc))


# In[13]:


df.head()


# In[14]:


df.shape


# In[15]:


#df.shape
from matplotlib import rcParams
rcParams['figure.figsize'] = 25,20


# In[41]:


sns.set_style("darkgrid")
plt.xticks([0.25*i for i in range(0,45)])
sns.boxplot( y="genres", x="avgrating",data=df ).set(title='Average Rating for each Genre')
sns.axes_style("darkgrid")
plt.show()


# In[16]:



myquery1 = [
    {
        '$unwind': '$actors'
    }, {
        '$unwind': '$genres'
    }, {
        '$group': {
            '_id': {
                'genre': '$genres', 
                'movie': '$_id'
            }, 
            'no_of_actors': {
                '$sum': 1
            }
        }
    },
{'$match' : {"no_of_actors" : {"$gte" : 1}}}
    , {
        '$group': {
            '_id': '$_id.genre', 
            'avg_no_actors': {
                '$avg': '$no_of_actors'
            }
        }
    }
]
# result.drop()

mydoc = movies.aggregate(myquery1,allowDiskUse=True)


# In[17]:


df=pd.DataFrame(list(mydoc))


# In[18]:


sns.set_style("darkgrid")
plt.yticks([0.5*i for i in range(0,11)])
sns.barplot(x = '_id',
            y = 'avg_no_actors',
            data = df).set(title='Average No of Actors per movie for each Genre')


# In[4]:



myquery1 = {
   "$group" : {"_id" : "$startYear", "numtitles" : {"$sum" : 1}}
}

#result.drop()

mydoc = movies.aggregate([myquery1])


# In[5]:


df=pd.DataFrame(list(mydoc))


# In[ ]:





# In[6]:


df.dropna()


# In[10]:


sns.set_style("darkgrid")
sns.lineplot(x = '_id', y = 'numtitles',data = df).set(title='No of movies by Year')


# In[ ]:




