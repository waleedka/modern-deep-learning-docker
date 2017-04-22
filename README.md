# Modern Deep Learning Docker Image

This is a modern environment for building deep learning applications. It has the latest *stable* versions of the most common tools and frameworks with CPU and GPU support.

This image is big (3GB+). I considered dropping a few tools or creating different images with different toolsets, but I think that'll waste everyone's time. If you're doing deep learning then you probably have a lot of disk space anyway, and you're likely to prefer saving time over disk space.    


## Included Libraries
- Ubuntu 16.04 LTS
- Python 3.5.2
- Tensorflow 1.0.1
- OpenCV 3.2
- Jupyter Notebook
- Numpy, Scipy, Scikit Learn, Scikit Image, Pandas, Matplotlib, Pillow
- Caffe
- Keras 2.0.3
- Java JDK

TODO:
- Torch


If you need to run older models that require Python 2.7 or OpenCV 2.4 then I'd recommend [Sai's docker image](https://github.com/saiprashanths/dl-docker) . I use it in addition to this image in my daily work.

## Runing the Docker Image (CPU Only)

If you haven't yet, start by installing [Docker](https://www.docker.com/). It should take a few minutes. Then run this command at your terminal:

```
docker run -it -p 8888:8888 -p 6006:6006 -v ~/:/host waleedka/modern-deep-learning
```

Note the *-v* option. It maps your user directory (~/) to /host in the container. Change it if needed. The two *-p* options expose the ports used by Jupyter Notebook and Tensorboard respectively.

## Runing the Docker Image (with GPU support)

1. Install the NVIDIA CUDA driver for your GPU card. You don't need cuDNN since it's available in this docker image.
2. Install [Docker](https://www.docker.com/).
3. Install [NVIDIA Docker](https://github.com/NVIDIA/nvidia-docker) to allow Docker to use your GPU card.
4. Run this command at the terminal:

```
nvidia-docker run -it -p 8888:8888 -p 6006:6006 -v ~/:/host waleedka/modern-deep-learning:gpu
```

Note the *-v* option. It maps your user directory (~/) to /host in the container. Change it if needed. The two *-p* options expose the ports used by Jupyter Notebook and Tensorboard respectively.

