#!/bin/sh

## uncomment for slurm
##SBATCH -p gpu
##SBATCH --gres=gpu:1
##SBATCH -c 10

export PYTHONPATH=./
eval "$(conda shell.bash hook)"
conda activate seg_pytorch  # pytorch 1.4.0 env
#conda activate seg_set
PYTHON=python

dataset=$1
exp_name=$2
exp_dir=exp/${dataset}/${exp_name}
result_dir=${exp_dir}/result
config=config/${dataset}/${dataset}_${exp_name}.yaml
now=$(date +"%Y%m%d_%H%M%S")

mkdir -p ${result_dir}
cp tool/test_normal_sparse.sh tool/test_normal_sparse.py ${config} ${exp_dir}

export PYTHONPATH=./
$PYTHON -u ${exp_dir}/test_normal_sparse.py \
  --config=${config} \
  2>&1 | tee ${result_dir}/test-$now.log
