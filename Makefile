help:
	@cat Makefile

DATA?="${HOME}/Documents/workclean/data"
DATA2?="/HDD250/workclean/data/"
GPU?=0
DOCKER_FILE=Dockerfile
DOCKER=GPU=$(GPU) nvidia-docker
BACKEND=tensorflow
PYTHON_VERSION?=3.5
#CUDA_VERSION?=8.0
#CUDNN_VERSION?=6
CUDA_VERSION?=9.0
CUDNN_VERSION?=7
TEST=tests/
#SRC?=$(shell dirname `pwd`)
SRC?="${HOME}/Documents/workclean/project/"
IMAGE="my_python_image"

build:
	docker build -t $(IMAGE) --build-arg python_version=$(PYTHON_VERSION) --build-arg cuda_version=$(CUDA_VERSION) --build-arg cudnn_version=$(CUDNN_VERSION) -f $(DOCKER_FILE) .

bash: build
	$(DOCKER) run -it -v $(SRC):/home/toque/work/ -v $(DATA):/home/toque/data -v $(DATA2):/home/toque/data2 --net=host --env KERAS_BACKEND=$(BACKEND) --name "my_python_container" $(IMAGE)

