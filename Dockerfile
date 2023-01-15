ARG PYTORCH_IMAGE=rocm/pytorch:rocm5.4_ubuntu20.04_py3.8_pytorch_staging

FROM ${PYTORCH_IMAGE}
SHELL ["/bin/bash", "-c"]

WORKDIR /

RUN apt-get update && \
    apt-get install -y wget curl git build-essential zip unzip nano openssh-server libgl1 libsndfile1-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN add-apt-repository ppa:deadsnakes/ppa && \
    apt install python3.10-full -y && \
    echo 'PATH=/usr/local/bin:$PATH' >> /root/.bashrc


RUN git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui

WORKDIR /stable-diffusion-webui

RUN python3.10 -m venv venv && \
    source venv/bin/activate && \
    python -m pip install --upgrade pip wheel && \
    pip3 install torch torchvision open-clip-torch --prefer-binary --extra-index-url https://download.pytorch.org/whl/rocm5.2 && \
    export HSA_OVERRIDE_GFX_VERSION=10.3.0 && \
    sed -i 's/    start()/    #start()/g' launch.py && \
    export REQS_FILE='requirements.txt' && \
    python launch.py --precision full --no-half --skip-torch-cuda-test && \
    sed -i 's/    #start()/    start()/g' launch.py

SHELL ["/bin/bash", "-c"]

EXPOSE 8501

ENV HSA_OVERRIDE_GFX_VERSION=10.3.0
ENTRYPOINT /stable-diffusion-webui/venv/bin/python webui.py