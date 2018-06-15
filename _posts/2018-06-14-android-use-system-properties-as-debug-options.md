---
layout: post
title: "[Android] Use System Properties as Debug Options"
description: Using system properties as debug options might be a good approach for you, if you want to open debug options on your apps and change these options easily without changing any code.
tags: 
    - Android
    - adb
    - setprop
    - build.prop
---

Using system properties as debug options might be a good approach for you, if you want to open debug options on your apps and change these options easily without changing any code.

# Motivation
Sometimes I want to make some actions that are different than their normal behaviors in order to make development easier. I don't want to change normal code before developing and remove the debug code afterward. So I try to add some debug options to accomplish this goal. There are some approaches I have tried.

1. Use buildConfigField in build.grable and set the values of fields from environmental variables. It works, but it is bad approval because every time we want to change options, it requires building and re-installing the app. 

2. Use Online settings. It works, but it is kind of overdone for this purpose and hard to control only certain devices get effected.

3. Set environmental variables on devices. It doesn't work because the processes are different when we use `adb shell set key value` to set a value of a option.

# The Approach

Finally, when I used `adb shell setprop log.tag.mytag debug` to make a logger enabled. It inspired me that maybe I could use that for debug options. After I did some researches and this is my approach. 

1. Use `adb shell setprop debug.option value` to set the debug options. 

This command writes a property and its value to "/system/build.prop" which only root can access, but few properties can be set by setprop without root such as debug.* and log.*. Also, these values are reset after reboot. 

Use `adb shell getprop debug.option` to get the option.

2. On the app. There is no public api to read the system properties, but we can use reflection to access a private class to read the value as below.

``` kotlin
fun getSystemProp(key: String, default: String? = null): String? {
    try {
        val c = Class.forName("android.os.SystemProperties")

        val method = c.getDeclaredMethod("get", String::class.java)

        val value = method.invoke(null, key) as String

        return if (value.isBlank()) {
            default
        } else {
            value
        }
    } catch (e: Exception) {
        e.printStackTrace()
    }

    return default
}

fun getSystemPropBoolean(key: String, default: Boolean): Boolean {
    try {
        val c = Class.forName("android.os.SystemProperties")

        val method = c.getDeclaredMethod("getBoolean", String::class.java, Boolean::class.java)

        return method.invoke(null, key, default) as Boolean
    } catch (e: Exception) {
        e.printStackTrace()
    }

    return default
}
```

# A Example
There is a example to use debug options. Says we have an app that only show WelcomeActivity for first time opening the app. The app stores IsVisited value on SharedProperties. If we want to force it always open WelcomeActivity to developing and debugging. we can change the code like below.

``` Kotlin
class MainActivity : Activity() {
    override fun onCreate(){
        ...
        val sp = getSharedPreferences("app.config", Context.MODE_PRIVATE)
        var isVisited = getSystemPropBoolean("debug.myapp.is_visited", sp.getBoolean("is_visited", false))
                        

        if (!isVisited) {
           startActivity(Intent(WelcomeActivity::class.java))
        }
        ...
    }
}
```

The isVisited is assigned from the system property `debug.myapp.is_visited` first. If it is empty of unset, then it is is assigned from shared preference `is_visited`. If it is unset, then it is false.

So we can use the command below to set `is_visited` always false to force open WelcomeActivity.

``` bash
adb shell setprop debug.myapp.is_visited false
```

After we have done the developing, we can remove the value as below

``` bash
adb shell setprop debug.myapp.is_visited ''
```

Next time, if WelcomeActivity changes, we don't need to clear shared preferences or change the code of MainActivity to force opening WelcomeActivity.

# References
- [https://stackoverflow.com/questions/9937099/how-to-get-the-build-prop-values](https://stackoverflow.com/questions/9937099/how-to-get-the-build-prop-values)

- [https://github.com/aosp-mirror/platform_frameworks_base/blob/master/core/java/android/os/SystemProperties.java](https://github.com/aosp-mirror/platform_frameworks_base/blob/master/core/java/android/os/SystemProperties.java)