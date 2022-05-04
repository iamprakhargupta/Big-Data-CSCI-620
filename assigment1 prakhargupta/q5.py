
"""
file: q5.py
description: CSCI-620.03 - HMWK1 Q5: To deliberate fail a transaction demo
language: python3, SQL
packages used = psycopg2
author: prakhar gupta pg9349
"""




import psycopg2


def connectioncheck():
    try:
        conn = psycopg2.connect(
            host="localhost",
            database="postgres",
            user="postgres",
            password="pg9349")

        cur = conn.cursor()

        # execute a statement
        print('Current tables in the schema')
        query="""
        SELECT schemaname,tablename
        FROM pg_catalog.pg_tables
        WHERE schemaname != 'pg_catalog' AND 
            schemaname != 'information_schema';
        """
        cur.execute(query)
        row = cur.fetchone()

        ###### Printing all table names
        print("schemaname       tablename")
        while row is not None:
            print(row[0]+ "             "+ row[1])
            row = cur.fetchone()

    finally:

        cur.close()
        conn.close()


def insertions():
    value1=(1000021954871,"nn1000021954871","Prakhar Gupta","1995","")
    value2=("ff21954871","ff21954871","Santa Clase","","") ## This will cause error as we violate the data type constraint
    value3 = (1000021954872, "nn1000021954872", "Tom Cruise", "1962", "")

    try:
        conn = psycopg2.connect(
            host="localhost",
            database="postgres",
            user="postgres",
            password="pg9349"
        )
        conn.autocommit = False
        cursor = conn.cursor()
        query="""
        INSERT INTO name_basics(personid,nconst,primaryname,birthyear,deathyear) VALUES (%s, %s,%s, %s,%s)
        
        """
        cursor.execute(query,value1)
        cursor.execute(query, value2) ## This will casue error
        cursor.execute(query, value3)
        conn.commit()


    except:
        print("Error while inserting values")
        print("Rolling back all insertions")
        conn.rollback()
    finally:
        cursor.close()
        conn.close()

def check_insert():
    try:
        conn = psycopg2.connect(
            host="localhost",
            database="postgres",
            user="postgres",
            password="pg9349")

        cur = conn.cursor()
        query="""
        select * from name_basics where personid=1000021954871;
        """

        cur.execute(query)
        row1 = cur.fetchone()
        #print(row1)

        query="""
        select * from name_basics where personid=1000021954872;
        """

        cur.execute(query)
        row2 = cur.fetchone()
        #print(row2)

        if row1 ==None and row2 ==None:
            print("No rows were inserted changes were rolledback successfully")

    finally:
        cur.close()
        conn.close()


connectioncheck()
print("Trying to insert three rows----------")
insertions()
check_insert()

