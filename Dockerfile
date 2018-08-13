#ARG cuda_version=8.0
#ARG cudnn_version=6
ARG cuda_version=9.0
ARG cudnn_version=7
FROM nvidia/cuda:${cuda_version}-cudnn${cudnn_version}-devel

ENV CONDA_DIR /opt/conda
ENV PATH $CONDA_DIR/bin:$PATH

RUN mkdir -p $CONDA_DIR && \
    echo export PATH=$CONDA_DIR/bin:'$PATH' > /etc/profile.d/conda.sh && \
    apt-get update && \
    apt-get install -y libmagic-dev && \
    apt-get install -y vim && \
    apt-get install -y htop && \
    apt-get install -y wget git libhdf5-dev g++ graphviz openmpi-bin && \
    apt-get install -y dvipng texlive-latex-extra texlive-fonts-recommended  && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-4.2.12-Linux-x86_64.sh && \
    echo "c59b3dd3cad550ac7596e0d599b91e75d88826db132e4146030ef471bb434e9a *Miniconda3-4.2.12-Linux-x86_64.sh" | sha256sum -c - && \
    /bin/bash /Miniconda3-4.2.12-Linux-x86_64.sh -f -b -p $CONDA_DIR && \
    rm Miniconda3-4.2.12-Linux-x86_64.sh && \
    apt-get install -y zsh 

ENV NB_USER toque
ENV NB_UID 1000

RUN useradd -m -s /bin/bash -N -u $NB_UID $NB_USER && \
    mkdir -p $CONDA_DIR && \
    chown $NB_USER $CONDA_DIR -R 
    #mkdir -p /src && \
    #chown $NB_USER /src 

RUN git clone https://github.com/robbyrussell/oh-my-zsh.git /home/toque/.oh-my-zsh 


USER toque

# Python
ARG python_version=3.5
ARG python_version2=2.7


RUN conda create -yn py35 python=${python_version} pip
RUN /bin/bash -c "source activate py35" 
RUN /opt/conda/envs/py35/bin/pip install --upgrade pip
RUN /opt/conda/envs/py35/bin/pip install jupyter
RUN /opt/conda/envs/py35/bin/pip install calmap
RUN /opt/conda/envs/py35/bin/pip install fastcluster
RUN /opt/conda/envs/py35/bin/pip install eml-parser 
RUN /opt/conda/envs/py35/bin/pip install tensorflow-gpu 
RUN /opt/conda/envs/py35/bin/pip install -U statsmodels
RUN /opt/conda/envs/py35/bin/pip install requests
RUN /opt/conda/envs/py35/bin/pip install tqdm
RUN /opt/conda/envs/py35/bin/pip install -U matplotlib
RUN /opt/conda/envs/py35/bin/pip install seaborn
RUN /opt/conda/envs/py35/bin/pip install plotly
RUN /opt/conda/envs/py35/bin/pip install colorlover
RUN conda install -yn py35 theano pygpu bcolz 
RUN /opt/conda/envs/py35/bin/pip install -U pandas==0.19.2 
RUN conda install -yn py35 Pillow scikit-learn notebook mkl nose pyyaml six h5py
RUN /opt/conda/envs/py35/bin/pip install sklearn_pandas
RUN /opt/conda/envs/py35/bin/pip install geopandas 
RUN /opt/conda/envs/py35/bin/pip install git+git://github.com/fchollet/keras.git 
RUN /opt/conda/envs/py35/bin/python -m ipykernel install --user --name py35 --display-name "Python 3.5 - env"
RUN conda clean -yt


RUN conda create -yn py27 python=${python_version2} pip
RUN /bin/bash -c "source activate py27" 
RUN /opt/conda/envs/py27/bin/pip install --upgrade pip
RUN /opt/conda/envs/py27/bin/pip install jupyter
RUN /opt/conda/envs/py27/bin/pip install calmap
RUN /opt/conda/envs/py27/bin/pip install fastcluster
RUN /opt/conda/envs/py27/bin/pip install tensorflow-gpu 
RUN /opt/conda/envs/py27/bin/pip install -U statsmodels
RUN /opt/conda/envs/py27/bin/pip install tqdm
RUN /opt/conda/envs/py27/bin/pip install requests
RUN conda install -yn py27 theano pygpu bcolz  
RUN /opt/conda/envs/py27/bin/pip install -U matplotlib
RUN /opt/conda/envs/py27/bin/pip install seaborn
RUN /opt/conda/envs/py27/bin/pip install plotly
RUN /opt/conda/envs/py27/bin/pip install colorlover
RUN /opt/conda/envs/py27/bin/pip install -U pandas==0.19.2
RUN conda install -yn py27 Pillow scikit-learn notebook mkl nose pyyaml six h5py
RUN /opt/conda/envs/py27/bin/pip install geopandas
RUN /opt/conda/envs/py27/bin/pip install sklearn_pandas 
RUN /opt/conda/envs/py27/bin/pip install git+git://github.com/fchollet/keras.git 
RUN /opt/conda/envs/py27/bin/python -m ipykernel install --user --name py27 --display-name "Python 2.7 - env"
RUN conda clean -yt


ADD theanorc /home/.theanorc
ADD zshrc /home/toque/.zshrc

ENV PYTHONPATH='/home/toque/:$PYTHONPATH'

WORKDIR /home

EXPOSE 8888

#CMD jupyter notebook --port=8888 --ip=0.0.0.0
#CMD /bin/bash "source activate py27" && jupyter notebook --no-browser --port=8887

CMD ["/bin/zsh"]
