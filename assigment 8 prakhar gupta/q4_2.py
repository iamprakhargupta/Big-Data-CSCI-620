"""
file: q4_2.py
description: CSCI-620.03 - Hw8 Q4: ploting
language: python3, MongoDB
packages used = pymongo
author: prakhar gupta pg9349
"""

#!/usr/bin/env python
# coding: utf-8

# In[1]:



import pymongo
import time
import pandas as pd


import seaborn as sns
import matplotlib.pyplot as plt


# In[2]:





# In[7]:


df=pd.read_csv("Action_100.csv")
sns.set_style("darkgrid")
sns.lineplot(x = 'cluster', y = 'SSE',data = df)
## cluster size of 25


# In[8]:


df=pd.read_csv("Horror_100.csv")
sns.set_style("darkgrid")
sns.lineplot(x = 'cluster', y = 'SSE',data = df)
## cluster size of 15


# In[14]:


df=pd.read_csv("Romance_100.csv")
sns.set_style("darkgrid")
sns.lineplot(x = 'cluster', y = 'SSE',data = df)
## cluster size of 30


# In[15]:


df=pd.read_csv("Sci-Fi_100.csv")
sns.set_style("darkgrid")
sns.lineplot(x = 'cluster', y = 'SSE',data = df)
## cluster size of 25


# In[16]:


df=pd.read_csv("Thriller_100.csv")
sns.set_style("darkgrid")
sns.lineplot(x = 'cluster', y = 'SSE',data = df)
## cluster size of 35


# In[ ]:




