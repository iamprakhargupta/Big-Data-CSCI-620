#!/usr/bin/env python
# coding: utf-8

# In[1]:


"""
Author: Prakhar Gupta
File name hw9.py

Implementing pyspark
"""

import findspark
findspark.init()
from pyspark.sql import SparkSession
spark = SparkSession.builder    .appName("insert")    .getOrCreate()


# In[2]:


from time import time


# In[3]:


from pyspark.sql.functions import split, explode


# In[4]:


from pyspark.sql.functions import *


# In[5]:


# spark


# In[8]:


spark.catalog.clearCache()
spark.catalog.dropGlobalTempView("df")
spark.catalog.dropTempView("df")


# In[9]:


rating = spark.read.option("header", "true").csv(r"D:\imdb\title.ratings.tsv.gz", sep=r'\t')
rating.printSchema()


# In[10]:


title = spark.read.option("header", "true").csv(r"D:\imdb\title.basics.tsv.gz", sep=r'\t')
title.printSchema()


# In[11]:


title_principal = spark.read.option("header", "true").csv(r"D:\imdb\title.principals.tsv.gz", sep=r'\t')
title_principal.printSchema()


# In[12]:


name = spark.read.option("header", "true").csv(r"D:\imdb\name.basics.tsv.gz", sep=r'\t')
name.printSchema()


# In[13]:


title_actor=title_principal.filter(title_principal.category == "actor")


# In[14]:


"""
Query 1
"""
t1=time()
phi=name.filter((name.primaryName.like('Phi%'))&(name.deathYear=="\\N"))
phi_movie=phi.join(title_actor,title_actor.nconst ==  phi.nconst,"inner")
query1=phi_movie.join(title,phi_movie.tconst ==  title.tconst,"inner")
q1=query1.filter(query1.startYear != "2014").select(phi['nconst'],phi['primaryName'],'deathYear').distinct()
# q1.show(q1.count())
q1.show(10)
t2=time()
print(f"Runtime {t2-t1}")


# In[15]:


"""
Query 2
"""
t1=time()
title_split=title.withColumn("g",split(title.genres, ','))
talk_show=title_split.where(array_contains(title_split.g, "Talk-Show")).filter(title_split.startYear == "2017")
gill=name.filter((name.primaryName.like('%Gill%')))
title_producer=title_principal.filter(title_principal.category == "producer")
gill_producer=gill.join(title_producer,gill.nconst==title_producer.nconst,"inner")

q2=gill_producer.join(talk_show,gill_producer.tconst ==  talk_show.tconst,"inner")
query2=q2.groupBy([gill.primaryName,gill.nconst]).agg(count(title.tconst).alias("talkshows"))
query2.sort(desc("talkshows")).show(10)
t2=time()
print(f"Runtime {t2-t1}")


# In[16]:


"""
Query 3
"""
t1=time()
alive=name.filter((name.deathYear=="\\N"))
alive_producer=title_producer.join(alive,alive.nconst == title_producer.nconst,"inner")
longrun=title.filter(title.runtimeMinutes>120)
q3=alive_producer.join(longrun,longrun.tconst==alive_producer.tconst,"inner")
query3=q3.groupBy([alive.primaryName,alive.nconst]).agg(count(title.tconst).alias("title"))
query3.sort(desc("title")).show(10)
t2=time()
print(f"Runtime {t2-t1}")


# In[18]:


"""
Query 4
"""
t1=time()
alive_actor=alive.join(title_actor,alive.nconst==title_actor.nconst,"inner")
alive_actor.filter((alive_actor.characters.like('["Jesus"]'))|(alive_actor.characters.like('["Christ"]'))).select(alive.primaryName).distinct().show(10)
t2=time()
print(f"Runtime {t2-t1}")


# In[18]:





# In[20]:





# In[22]:





# In[ ]:




