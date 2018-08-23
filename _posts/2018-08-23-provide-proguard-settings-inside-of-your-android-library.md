---
layout: post
title: Provide Proguard Settings Inside of Your Android Libraries
description: This article talk about a small tip that adding the Proguard settings inside your Android libraries to help our developers to use your libraries without adding extra Proguard settings.

tags: 
    - Android
    - Proguard
---

Proguard is a good Java tool to optimize and obfuscate the source code and the Android build tool includes it already. To apply Proguard in Android project is as easy as just changing false to true. However, its settings are a little complicated specifically for 3rd-party libraries. You might experience that when you want to apply Proguard to your projects, you have to look for the documents of the libraries the projects use or google that to see if there is information say how to apply Proguard for these libraries. This experience is kind of awful. To be kind to other developers who uses your libraries, you can provide the Proguard settings inside of your android libraries. Therefore, the projects that use your libraries automatically apply the settings.

## Use consumerProguardFiles Option

Android build tool has the mechanism to merge Proguard settings. All you need are adding settings in a file and add consumerProguardFiles option pointing to the file in build.gradle. For example,

``` gradle
# proguard-rules.pro
-keep public class com.swarmnyc.fulton.android.Fulton { *; }
```

``` gradle
# build.gradle
android {
    defaultConfig {
        ...
        consumerProguardFiles 'proguard-rules.pro'
    }
}
```

> You can see [this manual](https://www.guardsquare.com/en/products/proguard/manual) to know how to use Proguard.

## Debug

Applying Proguard is easy, but making it right is hard. I use [JADX](https://github.com/skylot/jadx) to decompile APKs which is applied Proguard to check Proguard does its job well or not.


This image shows a sample APK that build with merging the Proguard settings from [Fulton-Android](https://github.com/swarmnyc/fulton-android/), a library I made, in a sample Android project and Proguard keeps the necessary classes.

![image](/assets/images/2018-08-23-1.png)