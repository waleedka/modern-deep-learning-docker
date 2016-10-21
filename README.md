# Modern Deep Learning Docker Image

This Docker image is a modern environment for building deep learning applications. It has the latest versions of the most common tools and frameworks that you're likely to need. 

It does *not* have the very latest versions of everything, but rather the latest *stable* versions. Keep in mind that this image is big (3GB+). I considered dropping a few tools or creating different images with different toolsets, but I think that'll waste everyone's time. If you're doing deep learning then you probably have a lot of disk space anyway, and you're likely to prefer saving time over disk space.    


## Included Libraries
- Ubuntu 16.04
- Python 3.5
- Tensorflow 0.11rc
- OpenCV 3.1
- Jupyter Notebook
- Numpy, Scipy, Scikit Learn, Scikit Image, Pandas, Matplotlib, Pillow
- Caffe
- Java JDK

TODO:
- Torch
- Keras
- GPU/CUDA


If you need to run older models that require Python 2.7 or OpenCV 2.4 then I'd recommend [Sai's docker image](https://github.com/saiprashanths/dl-docker) . I use it in addition to this image in my daily work.

## Runing the Docker Image

If you haven't yet, start by installing [Docker](https://www.docker.com/). It should take a few minutes. Then run this command at your terminal:

```
docker run -it -p 8888:8888 -p 6006:6006 -v ~/:/host waleedka/modern-deep-learning:cpu
```

Note the *-v* option. It maps your user directory (~/) to /host in the container. Change it if needed. The two *-p* options expose the ports used by Jupyter Notebook and Tensorboard respectively.  

