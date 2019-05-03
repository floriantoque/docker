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
    apt-get install -y htop sudo && \
    apt-get install -y wget git libhdf5-dev g++ graphviz openmpi-bin && \
    apt-get install -y dvipng texlive-latex-extra texlive-fonts-recommended  && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-4.2.12-Linux-x86_64.sh && \
    echo "c59b3dd3cad550ac7596e0d599b91e75d88826db132e4146030ef471bb434e9a *Miniconda3-4.2.12-Linux-x86_64.sh" | sha256sum -c - && \
    /bin/bash /Miniconda3-4.2.12-Linux-x86_64.sh -f -b -p $CONDA_DIR && \
    rm Miniconda3-4.2.12-Linux-x86_64.sh && \
    apt-get install -y zsh 


# Python
ARG python_version=3.6

RUN conda create -yn py36 python=${python_version} pip && \
    /bin/bash -c "source activate py36" && \ 
    /opt/conda/envs/py36/bin/pip install --upgrade pip && \
    /opt/conda/envs/py36/bin/pip install jupyter && \
    /opt/conda/envs/py36/bin/pip install calmap && \
    /opt/conda/envs/py36/bin/pip install fastcluster && \
    /opt/conda/envs/py36/bin/pip install eml-parser  && \
    /opt/conda/envs/py36/bin/pip install tensorflow-gpu  && \
    /opt/conda/envs/py36/bin/pip install -U statsmodels && \
    /opt/conda/envs/py36/bin/pip install requests && \
    /opt/conda/envs/py36/bin/pip install tqdm==4.28.1 && \
    /opt/conda/envs/py36/bin/pip install -U matplotlib && \
    /opt/conda/envs/py36/bin/pip install seaborn && \
    /opt/conda/envs/py36/bin/pip install plotly && \
    /opt/conda/envs/py36/bin/pip install colorlover && \
    conda install -yn py36 theano pygpu bcolz  && \
    /opt/conda/envs/py36/bin/pip install -U pandas==0.19.2  && \
    conda install -yn py36 Pillow scikit-learn notebook mkl nose pyyaml six h5py && \
    /opt/conda/envs/py36/bin/pip install sklearn_pandas && \
    /opt/conda/envs/py36/bin/pip install geopandas && \
    /opt/conda/envs/py36/bin/pip install wget  && \
    /opt/conda/envs/py36/bin/pip install git+git://github.com/fchollet/keras.git && \
    /opt/conda/envs/py36/bin/pip install ipython==6.5.0 && \
    /opt/conda/envs/py36/bin/python -m ipykernel install --user --name py36 --display-name "Python 3.7 - env" && \
    conda clean -yt

#    /opt/conda/envs/py36/bin/pip install torch torchvision && \

# Creation user NB_USER
ENV NB_USER toque
ENV NB_UID 1000

RUN useradd -m -s /bin/bash -N -u $NB_UID $NB_USER
# user_name:password
RUN echo "$NB_USER:$NB_USER" | chpasswd && adduser $NB_USER sudo && \
    mkdir -p $CONDA_DIR && \
    chown $NB_USER $CONDA_DIR -R && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Set user and workdir
WORKDIR /home
USER $NB_USER
ENV PYTHONPATH='/home/$NB_USER/:$PYTHONPATH'


# Install vim and oh-my-zsh
RUN git clone https://github.com/robbyrussell/oh-my-zsh.git /home/$NB_USER/.oh-my-zsh && \ 
    git clone https://github.com/VundleVim/Vundle.vim.git /home/$NB_USER/.vim/bundle/Vundle.vim
RUN sudo apt-get install -y python-software-properties software-properties-common && \
    sudo add-apt-repository -y ppa:pi-rho/dev && \
    sudo apt-get update && \
    sudo apt-get install -y vim-gtk


# Add dot files
ADD .theanorc /home/.theanorc
ADD .zshrc /home/$NB_USER/.zshrc
ADD .vimrc /home/$NB_USER/.vimrc


# Install vim plugins
ENV TERM xterm-256color
RUN echo 'set -g default-terminal "screen-256color"' >> ~/.tmux.conf && \
    sudo chown toque /home/toque/.vimrc && \
    vim +PluginInstall +qall >/dev/null && \
    echo 'colorscheme solarized' >> ~/.vimrc


EXPOSE 8888

CMD ["/bin/zsh"]
