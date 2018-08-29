# Using Python with selected libraries via docker

This directory contains `Dockerfile` to make it easy to get up and running with different Python environments via [Docker](http://www.docker.com/).  
It is largely inspired from the following repo https://github.com/keras-team/keras/tree/master/docker

With this dockerfile it is possible to create a Python 2 and Python 3 environment and install different libraries.   
Python 3.5.4 and Python 2.7.13 are installed

Available shell/process/editor:
 * zsh
 * htop
 * vim

## Workflow

i) run the container  
    $ make bash  
ii) activate Python version  
    $ source activate py35 #or py27 for python 2.7  
iib) run ipython notebook and access it in from a remote computer  
    Computer with docker: $ jupyter notebook --no-browser --port=8887   
    Local computer: $ ssh -N -f -L localhost:8885:127.0.0.1:8887 user@ip_computer_docker  
    Access to the notebook in the browser of the local computer at localhost:8885  


## Installing Docker

General installation instructions are
[on the Docker site](https://docs.docker.com/installation/), but we give some
quick links here:

* [OSX](https://docs.docker.com/installation/mac/): [docker toolbox](https://www.docker.com/toolbox)
* [ubuntu](https://docs.docker.com/installation/ubuntulinux/)

 

## Running the container

We are using `Makefile` to simplify docker commands within make commands.

Build the container and access to the bash

    $ make bash

For GPU support install NVIDIA drivers (ideally latest) and
[nvidia-docker](https://github.com/NVIDIA/nvidia-docker). Run using

    $ make bash GPU=0 

Switch between Theano and TensorFlow

    $ make bash BACKEND=theano
    $ make bash BACKEND=tensorflow

Mount a volume for external data sets

    $ make DATA=~/mydata

Prints all make tasks

    $ make help

You can change Theano parameters by editing `/docker/theanorc`.  
You can change zshrc parameters by editing `/docker/zshrc`.


Note: If you would have a problem running nvidia-docker you may try the old way
we have used. But it is not recommended. If you find a bug in the nvidia-docker report
it there please and try using the nvidia-docker as described above.

    $ export CUDA_SO=$(\ls /usr/lib/x86_64-linux-gnu/libcuda.* | xargs -I{} echo '-v {}:{}')
    $ export DEVICES=$(\ls /dev/nvidia* | xargs -I{} echo '--device {}:{}')
    $ docker run -it -p 8888:8888 $CUDA_SO $DEVICES gcr.io/tensorflow/tensorflow:latest-gpu
