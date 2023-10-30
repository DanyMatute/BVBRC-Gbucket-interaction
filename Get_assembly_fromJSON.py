import os
import json
import subprocess
from pathlib import Path
'''
when you download the entire assembly file from BVBRC you get a JSON file. 
The JSON file contains the location of the assembly files.
This code reads all the JSON files in a directory and downloads them locally

INPUTS: directory_path (this variable is the location of the directory containing the JSON files.)

OUTPUT: many directories containing the assemblies for many samples.

'''


def download_sample(local_json): 
    with open (local_json) as json_file:
        data = json.load(json_file)

    output_files = data.get("output_files",[])
    param = data.get("parameters", "")
    output_dir_name = "../"+param['output_file']

    if output_dir_name:
        os.makedirs(output_dir_name,exist_ok=True)

    for file_info in output_files:
        file_path = "ws:"+file_info[0]
        file_name = os.path.basename(file_path)
        destination_path = os.path.join(output_dir_name,file_name)
        copy_command = ['p3-cp',file_path,destination_path]
        subprocess.run(copy_command)
        print(">>> ",file_name, " cp to ", output_dir_name)


# INPUT: Directory from which the directories are retrived from 
directory_path = "/Users/dmatute/Documents/CAMRA/Bioinformatics/Assembly_Tool_Testing/From_Gbucket_ToFrom_BVBRC/IFAIN_Retro_BatchB_JSON" 

directory = Path(directory_path)

for file in directory.iterdir():
    if file.is_file():
        download_sample(file)