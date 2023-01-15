# stable-diffusion-webui-amd

Provides a `Dockerfile` that builds a container containing the stable-diffusion-webui along with support for AMD GPUs via rocm:

https://github.com/AUTOMATIC1111/stable-diffusion-webui

## Build 

```bash
docker build . -f Dockerfile -t sd-amd-v2
```

## Run

```bash
docker run -it --network=host --device=/dev/kfd --device=/dev/dri --group-add=video --ipc=host --cap-add=SYS_PTRACE --security-opt seccomp=unconfined --name sd-webui-v2 sd-amd-v2:latest
```

### Note

#### Graphics cards
The container expects to run on an device with an RX 6600XT and thus requires the `HSA_OVERRIDE_GFX_VERSION=10.3.0` variable. 
If a graphics card with another architecture earlier than Navi 23 is used the container has to be built without the line `ENV HSA_OVERRIDE_GFX_VERSION=10.3.0`.

#### Models

The webui started by the container will not run without any model. 

##### stable-diffusion-v1.x
To provide a model using stable-diffusion-v1 download one and copy it into the container directory `/stable-diffusion-webui/models/Stable-diffusion`.
The following example shows how to download the `stable-diffusion-1.5` model:
```bash
wget https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/v1-5-pruned.ckpt --show-progress
docker cp v1-5-pruned.ckpt <container>:/stable-diffusion-webui/models/Stable-diffusion
```

##### stable-diffusion-v2.x
To provide a model using stable-diffusion-v2 download one and copy it along with the a v2-config into the container directory `/stable-diffusion-webui/models/Stable-diffusion`.
The following example shows how to download the `stable-diffusion-2-base` model:
```bash
wget https://huggingface.co/stabilityai/stable-diffusion-2-base/resolve/main/512-base-ema.ckpt -O v2-0_512-base-ema.ckpt --show-progress
wget https://raw.githubusercontent.com/Stability-AI/stablediffusion/main/configs/stable-diffusion/v2-inference.yaml -O v2-0_512-base-ema.yaml
docker cp v2-0_512-base-ema.ckpt <container>:/stable-diffusion-webui/models/Stable-diffusion
```
