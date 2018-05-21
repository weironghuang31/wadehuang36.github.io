---
layout: post
title: Use Git Tag for Managing App Version Number
description: A nice way of managing app version number.
tags: 
    - git tag
    - version management
---

I have tried some different methods to manage app versions, such as
- Manually update the version number.
    - cons: it is not automatically method.
- Use CI build number for PATCH version, like the build number is 80, so the version number is 1.0.80.
    - cons: it can not be reset once MAJOR or MINOR version is increased. For example, we want to increase MINOR version, and build number 81, so the version number is 1.1.81 instead of 1.1.0.
- use Date for version number, like 18.5.18.<build-number>
    - cons: it is good to know what time the app is released, but it looks weird.
- use a file to store version number and a build script to read the value and automatically update it and make a commit.
    -  cons: many commits only for updating the file.

These methods work, but I am not satisfied with them. Until few months ago, I saw some open source projects on the GitHub, they use git tags to manage version number. It really gained my interest, so I started use this method in my projects and developing my own style.

>Usually a version has 2 to 4 parts, like a popular rule, Semantic Versioning which is used by many languages includes java and Node.js, has 3 parts `<major>`.`<minor>`.`<patch>`, or 4 parts for pre-release `<major>`.`<minor>`.`<patch>`-`<pre-release>`
>
>see this [wiki](https://en.wikipedia.org/wiki/Software_versioning) and [Semantic Versioning](https://semver.org/) for more information.

## Basic Idea
---
This is the basic idea:
- use `git tag <version>` to make a tag. For example, `git tag 1.0.0`
- in a build script, use `git describe --tags --abbrev=0` to get the last tag as version number. 
- use `git push --tags` to push the tag, so others can get new version, too. (`git pull` downloads tags by default)

For example, this is how to read git tag in gradle for the version number of a Android app.

``` gradle
def gitTag = 'git describe --tags --abbrev=0'.execute([], project.rootDir).text

def gitCommitCount = Integer.parseInt('git rev-list --count HEAD'.execute([], project.rootDir).text.trim())

android {
    defaultConfig {
        versionCode gitCommitCount
        versionName gitTag
    }
}
```

> see git [tag](https://git-scm.com/docs/git-tag), [describe](https://git-scm.com/docs/git-describe) and [rev-list](https://git-scm.com/docs/rev-list) for more information.


The good things for this idea are
1. version numbers and commits are strong bound.
![example 1](/assets/images/2018-05-18-1.png)
both `git log` command and git-gui tool can show which tag(version) is based on which commit.

2. easy to update. just a `git tag` command.

3. CI supports. Almost all of CI server can listen git tags, so you can config your CI server to do something when tags are pushed. For example, I setup a CI config for making a release build triggered by tags.

## Advanced Idea
---
The basic idea is good, but not good enough. For instance, we still have to type the version number by ourselves. There are chances that we type a wrong version number, so I make a build script. Every time I want to make a release build. The script prompt a question to ask me do I want to increase the version number as the image below. 

![example 2](/assets/images/2018-05-18-2.png)

you can see the script on this [repo](https://github.com/swarmnyc/fulton/blob/master/build-scripts/gulpfile.js)

## Ultra Idea
---
The advanced idea is wonderful, but not useful enough. For instance, I still have to copy build script to each projects. So I made a cli tool to do this job.

For example, type below command in any folder that is source control by git to update git tag.

``` bash
> git-tag-bump 
# or gtb for short
> gtb
```

## [download](https://www.npmjs.com/package/git-tag-bump), [source code](https://github.com/wadehuang36/git-tag-bump)

## Cons
This idea has many pros, but it has cons, too.

1. we can not use git tag for another purpose.
2. `git describe` only return the first tag for the HEAD. For example,

``` bash
git tag 1.0.0-1
git tag 1.0.0-2
git describe --tags # it returns 1.0.0-1 instead of 1.0.0-2
```
