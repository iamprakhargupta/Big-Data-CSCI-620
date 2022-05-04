"""
file: q5_2.py
description: CSCI-620.03 - Hw8 Q5: Descriptive Stats of the clusters
language: python3, MongoDB
packages used = pymongo
author: prakhar gupta pg9349
"""

#!/usr/bin/env python
# coding: utf-8

# In[27]:



import pymongo
import time
import pandas as pd
myclient = pymongo.MongoClient("mongodb://localhost:27017/")
mydb = myclient["IMDB"]
action=mydb['Action_clusters']


# In[49]:


myquery1=[
    {
        '$match': {
            'cluster': 20
        }
    }
]
mydoc = action.aggregate(myquery1)

df=pd.DataFrame(list(mydoc))
df[[ 'startYear',
       'avgrating']].describe()


# In[47]:





# In[44]:



print(list(df["title"]))


# In[50]:


horror=mydb['Horror_clusters']
myquery1=[
    {
        '$match': {
            'cluster': 1
        }
    }
]
mydoc = horror.aggregate(myquery1)
df=pd.DataFrame(list(mydoc))
df[[ 'startYear',
       'avgrating']].describe()


# In[51]:



print(list(df["title"]))


# In[52]:


romance=mydb['Romance_clusters']
myquery1=[
    {
        '$match': {
            'cluster': 27
        }
    }
]
mydoc = romance.aggregate(myquery1)
df=pd.DataFrame(list(mydoc))
df[[ 'startYear',
       'avgrating']].describe()


# In[53]:



print(list(df["title"]))


# In[54]:


scifi=mydb['Sci-Fi_clusters']
myquery1=[
    {
        '$match': {
            'cluster': 3
        }
    }
]
mydoc = scifi.aggregate(myquery1)
df=pd.DataFrame(list(mydoc))
df[[ 'startYear',
       'avgrating']].describe()


# In[55]:


print(list(df["title"]))


# In[56]:


thriller=mydb['Thriller_clusters']
myquery1=[
    {
        '$match': {
            'cluster': 32
        }
    }
]
mydoc = thriller.aggregate(myquery1)
df=pd.DataFrame(list(mydoc))
df[[ 'startYear',
       'avgrating']].describe()


# In[57]:


print(list(df["title"]))


# In[ ]:




