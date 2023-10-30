# BVBRC-Gbucket-interaction
This repository contains scripts and tips that help move many files from a google bucket, submits it for assembly at BVBRC and uploads them back to the google bucket. 


1. Open [BV-BRC](https://www.bv-brc.org/) account. Download the [BVBRC's CLI](https://www.bv-brc.org/docs/cli_tutorial/index.html).
2. Run **Pull_many_Gfiles_Push_to_BVBRC-assemb.sh** on PATRIC (BVBRC's CLI). This script will ```gsutil cp``` files from the bucket to a temporary bucket locally and will puch them to the BVBRC for assembly. 

    Inputs that will be prompted:
    1. Google Bucket location of reads
    2. Location where the raw reads will be loaded on BVBRC
    3. Location where the output assembly will be placed in BVBRC
3. Wait for the assemblies to finish. 
4. Go to the BVBRC and download the directory containing the assembly. A JSON file will donwload locally containing the assembly files. 
5. Run **Get_assembly_fromJSON.py**. The code will iterate thought all the JSON files in a directory and ```p3-cp``` (copy) the assembly files from BVBRC to your local device.
   Change the location of the JSON files within the .py
6. Upload the assembly files to the google bucket. 
    ```gsutil -m cp -r /Local/Source/of/Assembly/Files gs://Google/Bucket/Destination```
