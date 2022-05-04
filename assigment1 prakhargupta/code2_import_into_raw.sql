/*
 Filename- Code2_import_into_raw.sql
 Author - Prakhar Gupta (pg9349)
 */

/*
This code import the data from the tsv files into raw table crated in step 1
############## PLEASE UNZIP THE FILE AND CHANGE FILE PERMISSIONS and LOCATION SO THAT SQL ENGINE CAN ACCESS ############
*/


COPY title_raw    FROM 'C:\Users\Prakhar Gupta\Desktop\BD cs620\assig1\title.basics.tsv\data.tsv'
    with (format csv, delimiter E'\t', header TRUE, QUOTE E'\b' ,NULL '\N'  );

COPY title_principal_raw
    FROM 'C:\Users\Prakhar Gupta\Desktop\BD cs620\assig1\title.principals.tsv\data.tsv'
    with (format csv, delimiter E'\t', header TRUE, QUOTE E'\b' ,NULL '\N'  );


COPY name_basics_raw
    FROM 'C:\Users\Prakhar Gupta\Desktop\BD cs620\assig1\name.basics.tsv\data.tsv'
    with (format csv, delimiter E'\t', header TRUE, QUOTE E'\b' ,NULL '\N'  );

COPY rating_raw
    FROM 'C:\Users\Prakhar Gupta\Desktop\BD cs620\assig1\title.ratings.tsv\data.tsv'
    with (format csv, delimiter E'\t', header TRUE, QUOTE E'\b' ,NULL '\N'  );


-- Summary: 4 of 4 statements executed in 2 min, 5 sec, 27 ms