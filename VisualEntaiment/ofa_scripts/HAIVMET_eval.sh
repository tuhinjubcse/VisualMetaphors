#!/bin/bash
model_type=$1 # snli, met
split=$2 # dev, test
data_type=$3 #SNLI-VE, metviz-ve

# master port,model-type,checkpoint_name,dataset_dir
worker_cnt=1
gpus_per_node=1
memory=400000
cpu=4000

# data
batch_size=32
selected_cols=0,2,3,4,5
max_src_length=80
max_tgt_length=20
patch_image_size=480
prompt_type='prev_output'


# optimization
lr=6e-05
clip_grad=0.0
schedule='polynomial_decay'
label_smoothing=0.0
weight_decay=0.01

# generation
load=../checkpoints/snli_ve_base_no_caption_ft_on_haivmet
if [[ "$model_type" == "snli" ]]
then
load=../checkpoints/snli_ve_base_no_caption
fi

student_model_config=ofa-base
task=snli_ve


save=eval_output
data_dir=../datasets/metviz-ve
if [[ "$data_type" == "snli" ]]
then
data_dir=../datasets/SNLI-VE
fi
DATA=${data_dir}/snli_ve_train.tsv,${data_dir}/snli_ve_${split}.tsv

export MASTER_PORT=1234



ckpt_frequency=50
init_method="load_pretrain"


/nlp/data/artemisp/mambaforge/envs/ofa/bin/python  /nlp/data/artemisp/stable-diffusion/VisualMetaphors/VisualEntaiment/OFA-Compress/main_evaluate.py \
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
       --num-epochs=0 \
       --best-score=10e10 \
       --metric=acc \
       --do-train\
       --do-predict\
       --ckpt-frequency=${ckpt_frequency} \
       --output-dir=${save} \
       --worker-cnt=${worker_cnt} \
       --gpus-per-node=${gpus_per_node} \
       --add-caption=False \
       --selected-cols=${selected_cols} \
       --fp16