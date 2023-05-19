#!/bin/bash

worker_cnt=1
gpus_per_node=1
memory=400000
cpu=4000



# data
batch_size=8
max_src_length=80
max_tgt_length=20
patch_image_size=480
prompt_type='src'


# optimization
lr=6e-05
clip_grad=0.0
schedule='polynomial_decay'
label_smoothing=0.0
weight_decay=0.01

load=../checkpoints/snli_ve_base_no_caption


student_model_config=ofa-base
task=snli_ve


save=../checkpoints/snli_ve_base_no_caption_ft_on_haivmet

data_dir=../datasets/metviz-ve
DATA=${data_dir}/snli_ve_train.tsv,${data_dir}/snli_ve_dev.tsv


export MASTER_PORT=1339



ckpt_frequency=2
init_method="load_pretrain"


# /nlp/data/artemisp/mambaforge/bin/python  OFA-Compress/main_train.py \
export CUDA_LAUNCH_BLOCKING=1 
/nlp/data/artemisp/mambaforge/bin/python  /nlp/data/artemisp/stable-diffusion/VisualMetaphors/VisualEntaiment/OFA-Compress/main_train.py \
       --tables=${DATA} \
       --task=${task} \
       --schedule=${schedule} \
       --label-smoothing=${label_smoothing} \
       --max-src-length=${max_src_length} \
       --max-tgt-length=${max_tgt_length} \
       --patch-image-size=${patch_image_size} \
       --prompt-type=${prompt_type} \
       --weight-decay=${weight_decay} \
       --clip-grad=${clip_grad} \
       --lr=${lr} \
       --kd-loss-weight=0.0 \
       --batch-size=${batch_size} \
       --init-method=${init_method}  \
       --student-model-config=${student_model_config} \
       --load=${load} \
       --micro-batch-size=${batch_size} \
       --num-epochs=10 \
       --best-score=10e10 \
       --metric=acc \
       --do-train \
       --do-predict \
       --ckpt-frequency=${ckpt_frequency} \
       --output-dir=${save} \
       --add-caption=False \
       --selected-cols='0,2,3,4,5' \
