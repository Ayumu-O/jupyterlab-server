# cf: [Pytorch+JupyterLab+GPUをDockerで作成 - Qiita](https://qiita.com/radiol/items/48909d69ba8114edcbf2)
FROM pytorch/pytorch:latest

# Install required libraries
RUN conda config --add channels pytorch \
 && conda config --append channels conda-forge \
 && conda update --all --yes --quiet \
 && conda install --yes --quiet -c conda-forge mamba

RUN mamba install --yes --quiet \
    ipywidgets \
    'jupyterlab~=3.0' \
    jupyterlab_code_formatter \
    'black=18.9b0' \
    isort \
    yapf \
    matplotlib \
    tqdm \
    nodejs \
    opencv \
    pandas \
    scikit-learn \
    seaborn \
    sympy

RUN mamba install --yes --quiet -c krinsman jupyterlab-toc

RUN mamba clean --all -f -y

RUN pip install "jupyterlab-kite>=2.0.2" \
 && rm -rf ~/.cache/pip

# Install jupyter extensions
RUN jupyter nbextension enable --py --sys-prefix widgetsnbextension \
 && jupyter labextension install @jupyter-widgets/jupyterlab-manager

# cf: [オレオレJupyterlab環境をDockerで作った](https://zenn.dev/fuchami/articles/d1625ac784fe5d)
RUN jupyter labextension install \
      @hokyjack/jupyterlab-monokai-plus \
      jupyterlab-vimrc \
      @axlair/jupyterlab_vim

# install jupyter-kite
RUN cd && \
    curl -OL https://linux.kite.com/dls/linux/current && \
    chmod 777 current && \
    sed -i 's/"--no-launch"//g' current > /dev/null && \
    ./current --install ./kite-installer

CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--allow-root", "--no-browser"]
EXPOSE 8888
