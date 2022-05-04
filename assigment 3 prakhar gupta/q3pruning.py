
"""
file: q3pruning.py
description: CSCI-620.03 - Hw3 Q3: To identify functional dependencies using lattice and pruning
language: python3, SQL
packages used = psycopg2,pandas
author: prakhar gupta pg9349
"""


import itertools
import warnings

import pandas as pd
import psycopg2

warnings.filterwarnings("ignore")


# implement pip as a subprocess:
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

        # execute a statement
        # print('Current columns in movie table')
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


def create_lattice(col):
    '''
    Creates a lattice in form of a unidirectional graph
    :param col: Column names
    :return: lattice of attributes using itertools
    '''
    # col = getcolumns()
    lattice = {}
    multicol = itertools.combinations(col, 2)
    l = []
    for i in multicol:
        l.append(i)
    for i in col:
        lattice[i] = []
        for j in l:
            if i in j:
                lattice[i].append(j)

    return lattice


def read_data():
    '''
    Read the SQL table into pandas
    :return: pandas dataframe
    '''
    try:

        conn = psycopg2.connect(
            host="localhost",
            database="postgres",
            user="postgres",
            password="pg9349")

        sql = "select * from movies;"
        data = pd.read_sql_query(sql, conn)

        # print(data.head())
        return data

    finally:

        conn.close()


def refinement(x, y):
    '''
    Used the partition retirement algorithm from class and slides
    :param x:  x's partitions
    :param y: y's partions
    :return: True if x refines y false otherwise
    '''
    a = x.indices
    b = y.indices
    seta = []
    setb = []
    for i, j in a.items():
        # print(type(j))
        seta.append(set(j.flatten()))
    for i, j in b.items():
        setb.append(set(j.flatten()))
    if len(seta) < len(setb):
        return False

    for i in seta:
        flag = 0
        for j in setb:
            if len(j.intersection(i)) == len(i):
                flag = 1
                break
        if flag == 0:
            return False

    return True


def refinement_better(x, y, z):
    '''
    Used the FD properties for partition refinement from the paper mentioned in writeup
    :param x: x's partition
    :param y: y's partions
    :param z: x U y partions
    :return: return true if x refine y
    '''
    a = x.indices
    b = y.indices
    c = z.indices
    if (len(a) == len(c)):
        return True
    else:
        return False


def pruning():
    '''
    Main function which controls the flow an also does the pruning
    Uncomment the lines if other refinement function need to e called
    :return: None
    '''
    import time

    t0 = time.time()
    col = getcolumns()
    col.remove('uniquekey')

    lattice = create_lattice(col)


    df = read_data()
    df = df[col]

    fd = {}
    allfds = {}
    for i in col:
        visited = set()
        for k, v in lattice.items():
            if i == k or k in visited:
                visited.add(k)
                for others in v:  ## lattice pruning
                    visited.add(others)
                continue
            x = df.groupby(k, dropna=False)
            y = df.groupby(i, dropna=False)
            z = df.groupby([k, i], dropna=False)
            # refined = refinement(x, y)
            refined = refinement_better(x, y, z)
            if refined is True:
                if k not in fd.keys():
                    fd[k] = []
                    fd[k].append(i)
                else:
                    fd[k].append(i)
                visited.add(k)
                for others in v:  ## lattice pruning
                    visited.add(others)
        for k, v in lattice.items():
            for others in v:
                flag = 0
                for oth in others:
                    if oth == i:
                        flag = 1
                if others not in visited and flag == 0:
                    lhs = list(others)
                    x = df.groupby(lhs, dropna=False)
                    lhs.append(i)
                    z = df.groupby(lhs, dropna=False)
                    # refined = refinement(x, y)
                    refined = refinement_better(x, y, z)
                    if refined is True:
                        if others not in fd.keys():
                            fd[others] = []
                            fd[others].append(i)
                        else:
                            fd[others].append(i)
                        visited.add(others)
        allfds[i] = visited

    print("Non inferable FD(Canonical) are printed .......")

    with open('noninferable_fd.txt', 'w') as f:
        for i, j in fd.items():
            for j2 in j:
                print(str(i) + "----->" + str(j2))
                f.write(str(i) + "----->" + str(j2))
                f.write('\n')

    print("Saved all the fds in allfd.txt .......")
    with open('allfd.txt', 'w') as f:
        for i, j in allfds.items():
            for j1 in j:
                f.write(str(j1) + "----->" + str(i))
                f.write('\n')

    t1 = time.time()

    print("IT took " + str(round((t1 - t0) / 60, 2)) + " mins")


if __name__ == '__main__':
    print("Finding FDs using lattice and pruning.......")
    pruning()
