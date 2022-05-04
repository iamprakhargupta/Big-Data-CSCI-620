"""
file: q2naive.py
description: CSCI-620.03 - Hw3 Q2: To identify functional dependencies using naive approach
language: python3, SQL
packages used = psycopg2
author: prakhar gupta pg9349
"""

import psycopg2
import itertools



def getcolumns():
    """
    Get the columm names in movie table
    :return: column names
    """
    try:
        conn = psycopg2.connect(
            host="localhost",
            database="postgres",
            user="postgres",
            password="pg9349")

        cur = conn.cursor()


        query = """


                    SELECT *
      FROM information_schema.columns
     WHERE table_schema = 'public'
       AND table_name   = 'movies'
         ;    ;    
        """
        cur.execute(query)
        row = cur.fetchone()
        column = []

        while row is not None:
            # print(row[3])
            column.append(row[3])
            row = cur.fetchone()

    finally:

        cur.close()
        conn.close()
    return column

def makecombos(col,n):
    '''
    Make the combinations of attributes
    :param col: all columns
    :param n: number of attributes to run with
    :return: a slice combo list
    '''
    cols = []
    for i in range(1,len(col)):

        multicol = itertools.combinations(col, i)
        for i in multicol:
            #print(i)
            x = list(i)
            s = ",".join(x)
            cols.append(s)


    cols=cols[:n]
    return cols



def naive_approach():
    """
    implement the naive approach
    :return: None
    """
    try:
        import time

        t0 = time.time()
        conn = psycopg2.connect(
            host="localhost",
            database="postgres",
            user="postgres",
            password="pg9349")

        cur = conn.cursor()
        table_name = 'movies'

        col = getcolumns()
        info = {}
        pairs=20
        print("Finding FDs using naive approach for " +str(pairs)+ " combinations .......")
        combos=makecombos(col,pairs)

        for i in combos:
            info[i] = []
            for j in col:
                if (i == j):
                    continue
                cur.execute(
                    f'SELECT {i}, COUNT(DISTINCT {j}) FROM {table_name} GROUP BY {i} HAVING COUNT(DISTINCT {j}) > 1')

                row = cur.fetchone()
                if (row is None):
                    info[i].append(j)

        for k, v in info.items():
            if len(v) != 0:
                for vv in v:
                    print(str(k) + "----->" + str(vv))
        t1 = time.time()

        print("IT took " + str(round((t1 - t0) / 60, 2)) + " mins")

    finally:

        cur.close()
        conn.close()


if __name__ == '__main__':

    naive_approach()