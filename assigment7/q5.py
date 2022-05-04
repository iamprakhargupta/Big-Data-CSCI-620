"""
file: q5.py
description: CSCI-620.03 - Hw7 Q5: for itemset mining
language: python3, SQL
packages used = psycopg2
author: prakhar gupta pg9349
"""


import psycopg2

def itemset_mining():
    """
    implement apriori
    :return: None
    """


    prefix="autoL"

    import time

    t0 = time.time()
    i=2
    while True:

        table = prefix + str(i)
        create_table = f" create table {table} as "
        columns1=" select top.actor1 "
        columns2=" select a1.actor as actor1 "
        count=",count(title) as c"
        source=" , a1.title from popular_movie_actors a1 "
        join=""
        where=" where "
        base1=" select "
        frombase=" on "
        groupby=" group by 1"
        having=" having count(title)>=5;"
        for j in range(2,i+1):
            columns1+=f",top.actor{j}"
            columns2+=f",a{j}.actor as actor{j}"
            #source+=f" join popular_movie_actors a{j} "
            join+=f" join popular_movie_actors a{j} on a{j-1}.title=a{j}.title"
            where+=f" a{j-1}.actor<a{j}.actor and"
            base1+=f"actor{j-1},"
            frombase+=f" base.actor{j-1}=top.actor{j-1} and"
            groupby+=f",{j} "
        basetable=f" from autoL{i-1}) base "
        drop = f"drop table if exists autoL{i};"
        track=f"select * from autoL{i}"
        query=drop+create_table+columns1+count+" from "+" ( " +columns2+source+join+where[:-3]+" )" +" top join ("+base1[:-1]+""+basetable +frombase[:-3]+groupby+having
        print(f"Query of Level {i} -->"+query)

        try:
            conn = psycopg2.connect(
                        host="localhost",
                        database="postgres",
                        user="postgres",
                        password="pg9349")

            cur = conn.cursor()



            cur.execute(query)
            cur.execute(track)
            rows=cur.fetchone()
            #print(rows)
            if rows is None:
                print(f"No result for Level{i}")
                print(f"Heights level of L's is {i-1}")
                t1 = time.time()

                print("IT took " + str(round((t1 - t0) / 60, 2)) + " mins")
                break
            else:
                c=0
                while rows:
                    c+=1
                    rows = cur.fetchone()
                print(f"No of itemset in level{i} = {c}")
                i += 1

        finally:

            cur.close()
            conn.close()


def base_case():
    """
    Create the L1 table base case
    :return: True if table is create
    """
    query="""
    Drop table if exists autoL1;
    create table autoL1 as
select actor "actor1",count(*) from Popular_Movie_Actors group by 1
having count(*)>=5;
    
    """
    track="""
    select * from autoL1
    """
    try:
        conn = psycopg2.connect(
            host="localhost",
            database="postgres",
            user="postgres",
            password="pg9349")

        cur = conn.cursor()

        cur.execute(query)
        cur.execute(track)
        rows = cur.fetchone()
        # print(rows)
        if rows is None:
            return False
        else:
            c = 0
            while rows:
                c += 1
                rows = cur.fetchone()
            print(f"No of itemset in level{1} = {c}")

            return True

    finally:

        cur.close()
        conn.close()


def driver():


    base=base_case()
    if base:
        itemset_mining()
    else:
        print("Cant make item sets on this data")



if __name__ == '__main__':
    driver()