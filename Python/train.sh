#!/bin/bash

data_name=$1
model_path=$2

task(){
# Set up fixed params
train_cmd="mkdir -p ${model_path}; python train.py"
train_cmd="${train_cmd} --optim SGD"
train_cmd="${train_cmd} --net CNN_4layers"
train_cmd="${train_cmd} --train_set ./data/${data_name}/${data_name}.mat"
train_cmd="${train_cmd} --val_set ./data/${data_name}/${data_name}.t.mat"
if [ "${data_name}" == "cifar10" ]; then
	train_cmd="${train_cmd} --dim 32 32 3"
elif [ "${data_name}" == "mnist" ]; then
	train_cmd="${train_cmd} --dim 28 28 1"
else
	echo "Wrong data_name!"
	exit -1
fi


for i in `seq 1 1`
do
	for lr in 0.01 0.1 0.001
	do
		for bs in 256 64 1024
		do
			for c in 0.01 0.1 0.001
			do
            	cmd="${train_cmd} --seed ${i}"
            	cmd="${cmd} --lr ${lr}"
            	cmd="${cmd} --bsize ${bs}"
            	cmd="${cmd} --C ${c}"
				cmd="${cmd} --model ./${model_path}/${i}_${lr}_${bs}_${c}/model.ckpt"
				cmd="${cmd} --log ./${model_path}/${i}_${lr}_${bs}_${c}/logger.log"
				echo ${cmd}
			done
		done
	done
done
}

# Check command
echo "Check command list (the command may not be runned!!)"
task
wait


# Run
#echo "Run"
#task | xargs -0 -d '\n' -P 1 -I {} sh -c {}
