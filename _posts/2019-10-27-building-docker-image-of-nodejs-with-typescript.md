---
layout: post
title: Building Docker Image of Nodejs With Typescript
description: Show the many ways to build docker images of nodejs projects with typescript
tags: 
    - docker
    - nodejs
    - typescript
---

Building compact docker images of Nodejs projects usually is very straightforward, we can just these two variants `node:slim` (official recommended) or `node:alpine` as the base image to build the images. For example,

``` dockerfile
FROM node:slim

ENV NODE_ENV=production

WORKDIR /app

## Copy package.json and package-lock.json before copy other files for better build caching
COPY ["./package.json", "./package-lock.json", "/app/"]
RUN npm ci --production
COPY "./" "/app/"

CMD ["npm", "start"]
```

> see https://hub.docker.com/_/node for details of the variants of nodejs

However, if you use nodejs with Typescript in your projects, to build compact docker images is another story because Typescript files need to compile to Javascript files. Your can do the compiling before or within the phase of docker build, but there are some problems. In the next section, I will use an example to show you the problems and approaches I have tried.

## The example project
The example in the blogpost is a very simple nodejs project with Typescript. It just uses express and a package directly from github or other git hosts (calls it the repo package later on) and other 4 packages for development. The below is the package.json

``` js
/* package.json */
{
  "name": "example",
  "version": "1.0.0",
  "main": "dist/index.js",
  "scripts": {
    "start": "ts-node src/index.ts",
    "start:dist": "node dist/index.js",
    "build": "tsc",
  },
  "dependencies": {
    "express": "^4.17.1",
    "the-repo-package" : "git+https://github.com/the/repo"
  },
  "devDependencies": {
    "@types/express": "^4.17.1",
    "@types/node": "^12.11.7",
    "ts-node": "^8.4.1",
    "typescript": "^3.6.4"
  }
}
```

There are two problems to build docker images:
1. For a good docker image, we want to build a image as compact as possible, the image only needs to contain the packages of **dependencies** and compiled **\*.js** files. The packages of **devDependencies** and **\*.ts** should be excluded.
2. The project includes a package from github which means the image needs to install git program in order to install the package when run `npm install`, but as a compact image, it should not include git program.

> NOTE: `node:slim (≈60MB)` or `node:alpine (≈35MB)` have very minimal programs and they don't includes git, only `node (≈340MB)` includes all common programs like curl, git.

I have tried many approaches but only two approaches that solved the two problems. 

## Approach 1. Compile typescript files before docker build
1. install all packages in the build machine (local or CI/CD) and compile the typescript, then copy only compiled files into the image.
2. copy the repo package from the build machine into the docker image. 

The below snippets show how I did that.

``` bash
# .dockerignore
# don't copy files in node_modules folder
node_modules
# but the-repo-package folder is an exception
!node_modules/the-repo-package
```

``` bash
# dockerfile
FROM node:slim

WORKDIR /app

# copy only node_modules/the-repo-package into the image because .dockerignore
COPY "./node_modules" "/app/node_modules"
COPY ["./package.json", "./package-lock.json", "/app/"]

# because the package is existed in node_modules, so npm skips installing it
# use --production to only install the packages of dependencies
# can't use ci command because ci command only support install whole packages
RUN npm install --production

# copy only the compiled files
COPY "./dist" "/app/dist"

CMD [ "npm", "run", "start:dist" ]
```

``` bash
# build script
npm install ## install all packages includes packages of devDependencies
npm run build ## compile the typescript files
docker build -t the-example . ## build the docker image
```

This approach can generate a compact images, but there are one thing I dislike that is `npm install` is executed twice. One is in the build script and another is inside the dockerfile. It wastes time and network to download some packages twice. So in the next approach I try to solve this problem.

## 2. Use docker multistage build
Docker brought the features of multistage build after Docker 17.05. Basically, [multistage build](https://docs.docker.com/develop/develop-images/multistage-build/) supports build multiple images (stages) in one dockerfile. Therefore,

1. the first image, install all packages and build typescript, then use [npm prune](https://docs.npmjs.com/cli/prune.html) to remove the packages of devDependencies.
2. the second image as the real image, copy the compiled files and the node_modules from the first image.

The below snippets show how I do that.

``` bash
# .dockerignore
# don't copy files in node_modules folder
node_modules
```

``` bash
# dockerfile
# the first image use node image as the builder because it has git program
FROM node as builder

WORKDIR /app

COPY ["./package.json", "./package-lock.json", "/app/"]

RUN npm ci

COPY "./" "/app/"

## compile typescript
RUN npm run build

## remove packages of devDependencies
RUN npm prune --production

# ===============
# the second image use node:slim image as the runtime
FROM node:slim as runtime

WORKDIR /app
ENV NODE_ENV=production

## Copy the necessary files form builder
COPY --from=builder "/app/dist/" "/app/dist/"
COPY --from=builder "/app/node_modules/" "/app/node_modules/"
COPY --from=builder "/app/package.json" "/app/package.json"

CMD ["npm", "run", "start:prod"]
```

``` bash
# build script
docker build -t the-example . ## build the docker image
```

The second approach solves the problems, but the steps is easier that the first approach.

## Conclusion
The evolution of building docker images of nodejs with typescript has took one to two years to let me got the approach two. I hope you like it. I am welcome that you can tell me your  approach.

> NOTE: After I wrote this blogpost, I realized that I can run `npm prune --production` in the first approach and copy the whole "node_modules" into the image and run `npm rebuild` to make sure packages that contain c/c++ or python are compiled correctly. However, I still like the second approach more because it looks neater.