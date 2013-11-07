#!/bin/bash

# This is neural net training on top of adapted 40-dimensional features.
# 


train_stage=-100
temp_dir=  # e.g. --temp-dir /export/m1-02/dpovey/kaldi-dan2/egs/wsj/s5/
parallel_opts="-l gpu=1,hostname=g*"  # This is suitable for the CLSP network, you'll likely have to change it.
dir=exp/nnet5c_gpu

# Note: since we multiplied the num-jobs by 1/4, we halved the
# learning rate, relative to run_5c.sh

. ./cmd.sh
. utils/parse_options.sh

( 

  if [ ! -z "$temp_dir" ] && [ ! -e $dir/egs ]; then
    mkdir -p $dir
    mkdir -p $temp_dir/$dir/egs
    ln -s $temp_dir/$dir/egs $dir/
  fi

  steps/nnet2/train_tanh.sh \
   --num-jobs-nnet 4 --num-threads 1 --parallel-opts "$parallel_opts" \
   --mix-up 8000 \
   --initial-learning-rate 0.005 --final-learning-rate 0.0005 \
   --num-hidden-layers 4 --hidden-layer-dim 1024 \
   --cmd "$decode_cmd" \
    data/train_si284 data/lang exp/tri4b_ali_si284 $dir || exit 1
  
  steps/decode_nnet_cpu.sh --cmd "$decode_cmd" --nj 10 \
    --transform-dir exp/tri4b/decode_bd_tgpr_dev93 \
     exp/tri4b/graph_bd_tgpr data/test_dev93 $dir/decode_bd_tgpr_dev93

  steps/decode_nnet_cpu.sh --cmd "$decode_cmd" --nj 8 \
    --transform-dir exp/tri4b/decode_bd_tgpr_eval92 \
     exp/tri4b/graph_bd_tgpr data/test_eval92 $dir/decode_bd_tgpr_eval92
)

