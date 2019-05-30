---
layout: post
title: A easy way to use docker with GPU on AWS EC2
description: Show you a easy way to use docker with NVIDIA GPU on AWS EC2.

tags: 
    - Docker
    - NVIDIA
    - GPU
    - AWS
---

Recently, I have a project which needs GUP support and I wanted to dockerize it and I can deploy easier. At the beginning, I wanted to use AWS ECS FARGATE, but FARGATE instance doesn't support GPU. Then I created a EC2 P2 tier instance from regular ubuntu image which has NVIDIA K80 GUP. Then I installed CUDA, NVIDIA driver, Docker and [NVIDIA docker](https://github.com/NVIDIA/nvidia-docker) from scratch. The installation was not hard but it took hours for beginner as me. Unfortunately, the default storage for regular ubuntu is 8GB, so it was full very quick. Therefore, I wanted to recreate a new instance, also to practice the installation again. Then, I saw AWS provides a custom ubuntu image with all the stuffs I needed. I was very happy and sad at the moment. Happy about I can really create an NVIDIA-docker-ready instance to use and sad about why I had to spent hours for nothing. However, the below instruction will show you how to create a NVIDIA docker ready instance.

## Create NVIDIA docker ready instance of EC2 on AWS
Once you are on EC2 page and click the Launch Instance, the first step is select an image. you use a keyword like "nvidia" or "cuda" to search images.

![image](/assets/images/2019-05-29-1.png)

Then find a image that provides NVIDIA-Docker and select it. For example, the first image "Deep Learning AMI (Ubuntu)" meets the criteria.

![image](/assets/images/2019-05-29-2.png)

Then select a GPU instance, you can start p2.xlarge which is the cheapest ($0.9 per hour) when I wrote this blog. 

![image](/assets/images/2019-05-29-3.png)

Then click 4. Add Storage to check the storage is big enough for your need.

Review the setting, if no problem, then launch the instance.

## Test
You can use run the cuda image with nvidia-smi to test if it is working or not.
``` bash
docker run --runtime=nvidia --rm nvidia/cuda:9.0-base nvidia-smi
```

![image](/assets/images/2019-05-29-4.png)


## Use Docker as Function
Another benefit to use docker is you can pull pre-build image form [hub](https://hub.docker.com). For example, my recently project used other open sources like [colmap](https://github.com/colmap/colmap) and [openMVS](https://github.com/cdcseacave/openMVS). These libraries don't have pre-build packages to install on linux. You have to build by yourself which might take hours. However, many people have shared their images. So we can take the advantage to use them to save our time. 

As a example, I search colmap on docker hub and find a recent image to use. 

``` bash
docker run -v /images:/images --runtime=nvidia geki/colmap \ 
colmap automatic_reconstructor --workspace_path /images --image_path /images
```

