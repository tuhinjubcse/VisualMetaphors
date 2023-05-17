# Visual Entailment Experiment

## Setup

We build our experiments on top of [`OFA-Compress`](https://github.com/OFA-Sys/OFA-Compress)

First clone the repo and follow the installation instructions
```
>> git clone https://github.com/OFA-Sys/OFA-Compress
>> pip install -r requirements.txt
```

### Data

Preprocess the visual entailment text data. Note: ensure you have `pandas` installed by running `pip install pandas`. 
```
>> cd data
>> python preprocess.py --image_dir /path/to/HAIVMET
>> cd ..
```

You can also directly download the preprocessed data and place them in `datasets/metviz-ve`
```
>> mkdir datasets && cd datasets
>> wget https://visual-metaphors-finetuned-model.s3.amazonaws.com/metviz-ve.zip
>> unzip metviz-ve.zip
>> cd ..
```

## Download Finetuned Model

Get the checkpoint of `snli-ve-base-no-caption` and `snli-ve-base-no-caption-ft-on-haivmet` finetuned on our data  and place it in the `checkpoints`.

```
>> cd checkpoints
>> wget https://visual-metaphors-finetuned-model.s3.amazonaws.com/snli_ve_base_no_caption.zip
>> unzip snli_ve_haivmet_best.zip
>> wget https://visual-metaphors-finetuned-model.s3.amazonaws.com/snli-ve-base-no-caption-ft-on-haivmet.zip
>> unzip snli-ve-base-no-caption-ft-on-haivmet.zip
>> cd ..
``` 


## Evaluate

If you want to evaluate the model yourself on our data you can run
```
>> bash ofa_scripts/HAIVMET_eval.sh <model_type> <eval_split> <dataset>
```
where `model_type` can take the values
* `snli` to use the model that is only finetuned on SNLI. See [Section SNLI Checkpoint](#SNLI-Checkpoint) for instructions. 
* `met` to use the model that is further finetuned on the visual metaphors dataset. 

`eval_split` can take the values `dev,test` to evaluate on the corresponding split of visual metaphors. 

and `dataset` can take the values `met,snli`. Note to run evaluation on `snli` you need to download the `SNLI-VE` data from [here](https://ofa-beijing.oss-cn-beijing.aliyuncs.com/datasets/snli_ve_data/snli_ve_data.zip) and place them inside `datasets`. 



## Finetuning on HAIVMET

### Finetune on HAIVMET
If you want to finetune the model yourself on our data you can run

```
>> bash ofa_scripts/HAIVMET_ft.sh
```