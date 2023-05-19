import pandas as pd
import os
import base64
from PIL import Image
from io import BytesIO
from tqdm import tqdm 
import argparse

parser = argparse.ArgumentParser(description="")
parser.add_argument("--image_dir", required=True, help="Specify metaphor images directory", type=str)
args = parser.parse_args()

#Columns: 'Premise', 'Hypothesis', 'Label', 'Split', 'Folder'
met_data = pd.read_csv('../raw/entailmentsFinal.csv')
met_data_train = met_data[met_data['Split'] == 'train']
met_data_dev = met_data[met_data['Split'] == 'dev']
met_data_test = met_data[met_data['Split'] == 'test']
met_image_dir = args.image_dir
    
    
os.mkdirs('../datasets/metviz-ve/', exist_ok=True)

print("Processing train..")
f = open('../datasets/metviz-ve/snli_ve_train.tsv','w')
count = 0
for i,row in tqdm(met_data_train.iterrows()):
    for j,im in enumerate(os.listdir(os.path.join(met_image_dir, row['Folder']))):
            if any([k in im.lower() for k in ['png', 'jpg', 'jpeg']]):
                img = Image.open(os.path.join(met_image_dir, row['Folder'], im)) # path to file
                img_buffer = BytesIO()
                img.save(img_buffer, format=img.format)
                byte_data = img_buffer.getvalue()
                base64_str = base64.b64encode(byte_data)
                f.write(f'{i}\t{i}-{j}\t{base64_str.decode("utf-8")}\t{row["Hypothesis"]}\t{row["Premise"]}\t{row["Label"]}\n')
                count = i
f.close()

print("Processing dev..")
f = open('../datasets/metviz-ve/snli_ve_dev.tsv','w')
for i,row in tqdm(met_data_dev.iterrows()):
    for j,im in enumerate(os.listdir(os.path.join(met_image_dir, row['Folder']))):
        if any([k in im.lower() for k in ['png', 'jpg', 'jpeg']]):
                img = Image.open(os.path.join(met_image_dir, row['Folder'], im)) # path to file
                img_buffer = BytesIO()
                img.save(img_buffer, format=img.format)
                byte_data = img_buffer.getvalue()
                base64_str = base64.b64encode(byte_data)
                f.write(f'{i}\t{i}-{j}\t{base64_str.decode("utf-8")}\t{row["Hypothesis"]}\t{row["Premise"]}\t{row["Label"]}\n')
f.close()

print("Processing test..")
f = open('../datasets/metviz-ve/snli_ve_test.tsv', 'w')
for i,row in tqdm(met_data_test.iterrows()):
    for j,im in enumerate(os.listdir(os.path.join(met_image_dir, row['Folder']))):
        if any([k in im.lower() for k in ['png', 'jpg', 'jpeg']]):
                img = Image.open(os.path.join(met_image_dir, row['Folder'], im)) # path to file
                img_buffer = BytesIO()
                img.save(img_buffer, format=img.format)
                byte_data = img_buffer.getvalue()
                base64_str = base64.b64encode(byte_data)
                f.write(f'{i}\t{i}-{j}\t{base64_str.decode("utf-8")}\t{row["Hypothesis"]}\t{row["Premise"]}\t{row["Label"]}\n')
f.close()



