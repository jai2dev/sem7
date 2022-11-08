# One-Shot Object Detection with Co-Attention and Co-Excitation

### Disclamer 
The code repository contains only scripts to run the project but it does not contains the pretrained model files. dataset, and model checkpoints which are required to run these scripts. The reason is these files are quite large (22-25 GB) and are lot in numbers.

# dataset

https://cocodataset.org/#download
version: 2017


#Prerequisites

* Ubuntu 20.04
* Python or 3.6
* Pytorch 1.0


#Pretrained Model
We have used vgg16, resnet50, resnet101 and resnet152 pretrained models


#Compilation

Install all the python dependencies using pip:

```bash
pip install -r requirements.txt
```

Compile the cuda dependencies using following simple commands:

```bash
cd lib
python setup.py build develop
```

It will compile all the modules you need.


#Train

Before training, set the right directory to save and load the trained models. Change the arguments "save_dir" and "load_dir" in train_net.py and test_net.py to adapt to your environment.

In coco dataset, we split it into 4 groups. It will train and test different category. Just to adjust "*--g*"(1~4). If you want to train other settings, you should sepcify "*--g 0*" 

* 1 --> Training, session see train_categories(config file) class
* 2 --> Testing, session see test_categories(config file) class
* 3 --> session see train_categories + test_categories class

To train a model with pretrained model on COCO, simply run
```bash
python train_net.py --dataset coco --net neural_network \
                       --bs $BATCH_SIZE --nw $WORKER_NUMBER \
                       --lr $LEARNING_RATE --lr_decay_step $DECAY_STEP \
                       --cuda --g $SPLIT --seen $SEEN --mGPUs

```

Above, BATCH_SIZE and WORKER_NUMBER can be set adaptively according to your GPU memory size. **On NVIDIA V100 GPUs with 32G memory, it can be up to batch size 16**.


#Test


For coco first group:

```bash
python test_net.py --s 1  --g 1 --a 4 --cuda
```

For coco second group:

```bash
python test_net.py --s 2  --g 2 --a 4 --cuda
```

