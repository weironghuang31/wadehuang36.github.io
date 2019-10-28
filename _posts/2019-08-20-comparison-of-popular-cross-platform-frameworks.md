---
layout: post
title: The Comparison Of Popular Cross-Platform Frameworks In 2019
description: the comparison of React Native, Flutter, Xamarin, Ionic and Kotlin Native

tags:
  - mobile frameworks
  - cross-platform
---

## Prologue

Before we start the comparison, we want to talk about native apps and cross-platform apps. In order to give you ideas on why you need to consider to build apps by using cross-platform frameworks and why not.

## What the native apps and cross-platform apps are

A native app simply refers to the app that is built by using the programming languages and tools that the platform or operating system creator provided and the tools compile source code to [machine code](https://en.wikipedia.org/wiki/Machine_code) or [intermediate code](https://en.wikipedia.org/wiki/Intermediate_representation) (let's call these two types of codes native code later) that the platform can understand and bundle all resources to a file, so the app can be distributed and installed. For business and technical reasons, that app can only be installed and executed on the specific platforms because platforms can only understand the structures of app bundles and the decided native codes. This is why it is impossible to install the app to other platforms. For example, the current most popular mobile platforms iOS and Android. For iOS, Apple is the creator and Apple provides XCode with Objective-C and Swift languages. XCode builds source code to native code and bundles them to IPA files. The iOS apps can only be installed and executed on iOS devices like iPhone and iPad. As well as Android Platform, Google is the creator and Google provides Android Studio with Java and Kotlin languages. Android Studio builds and bundles source code to APK files. The apps can only be installed on executed on Android devices.

If we want to make their apps to support these two platforms, we need to build two identical apps by using different tools and programming languages. It might takes double time and resources to develop. Also, it is hard to let a single developer to master different platforms. So we might need double developers and teams. It requires more, if there are more platforms they have to support. That's a big pain. Therefore, some people have tried to solve this problem. We deduced that there are 3 main types of solutions from years trying and observing these solutions.

### Type 1 - Shared Libraries

Provide a compiler for each platform that compiles source code to native code. The popular framework such as [Djinni](https://github.com/dropbox/djinni) and [Koltin Native](https://kotlinlang.org/docs/reference/native-overview.html).

![shared-libraries-diagram](/assets/images/2019-comparison/2019-comparison-1.png)

For this type of solution, only logic code can be used across platforms. Developers still need to write different layouts and UI interactive source code for echo platforms. Since the source code compiles to native code, the performance is almost the same as native app.

### Type 2 - Web View

Another solution is Web View since almost all of the platforms support Web View. So developers write apps in HTML/CSS/JavaScript that lots of developers familiar with. The frameworks provide wrappers that render the website. Also, provide bridges that your code can use platform APIs. So building apps actually are such as building websites and frameworks provide libraries let JavaScript can invoke platform APIs. Popular frameworks use this approach are [Ionic](https://ionicframework.com/) and [PhoneGap](http://phonegap.com/).

![web-view-diagram](/assets/images/2019-comparison/2019-comparison-2.png)

This solution has a lot of benefits for web developers. However, it has some disadvantages as well. WebView has a bad notorious for consuming resources and slower User Interaction response compared to native app.

### Type 3 - Runtime

This solution provides a runtime (a middle layer) on the top of each platform. Apps are written by languages that cross-platform frameworks supported to make the source code can be used. When apps run, their runtime translates code you write to native code that platform can understand in order to render UIs and execute functions.

![runtime-diagram](/assets/images/2019-comparison/2019-comparison-3.png)

Currently, many popular frameworks are using this solution such as [React Native](https://facebook.github.io/react-native/), [Flutter](https://flutter.dev/), [Xamarin](https://visualstudio.microsoft.com/xamarin/) and [NativeScript](https://www.nativescript.org/). However, this solution has some drawbacks and limitations.

1. Slower performance compares to native apps because of code has to be interpreted twice by the runtime of the cross-platform framework and the native platform.
2. Bigger app sizes because the apps have to include the runtime of the cross-platform framework altogether.
   ![runtime-diagram2](/assets/images/2019-comparison/2019-comparison-4.png)
3. As it has bigger app sizes, it needs a longer time to download

However, these might not be big issues since devices are more powerful and network is faster everyday. The app might just run few milliseconds slower and take few seconds longer to download it that users might not even notice the difference.

### Solution Summary

<table>
  <tr>
    <th></th>
    <th>Type 1- Shared Code</th>
    <th>Type 2 - WebView</th>
    <th>Type 3 - Runtime</th>
  </tr>

  <tr>
    <td>Pros</td>
    <td>Very-Lower Performance Cost</td>
    <td>
      The apps can be built as websites, web developers can get used to very
      quickly.
    </td>
    <td>
      Frameworks provide native code to render UI, the performance and user
      experience might be better than Apps in WebView.
    </td>
  </tr>
  <tr>
    <td>Cons</td>
    <td>Less Reusable Code</td>
    <td>WebView has more Performance Cost</td>
    <td>Some Performance Cost Bigger App Size</td>
  </tr>
</table>

## Is cross-platform solution good for you?

Although, all of the cross-platform frameworks are not perfect. However, these benefits of cross-platform frameworks provided cannot be denied.

- time-saving. You don't need to build an identical app for different platforms

- cost-down. The most expensive thing of software development is human resources. You just needs less developers who has the knowledge of the cross-platform instead of many developers who has the knowledge of each platform.

- easy maintaining. since you only have one source code base, if you need to change the code. You just change in one source code instead of multiple source code for each platform.

As you know the pons and cons of cross-platform solution and you can think if cross-platform solution is the right approach for you to build apps. Further, we will introduce some popular frameworks to you to help you find out which cross-platform frameworks are best for you.

## Popular Frameworks

There are countless cross-platform frameworks, we cannot introduce all of frameworks in this single blog. Therefore, we will pick some interesting and popular frameworks. Beside the introduction, we also use these framework to build very simple apps to demonstrate their differences. The app has only one screen with 3 components

1. a text view served as label
2. a text input.
3. a text view served as greeting label. hide at the beginning and show the text with the value of the text input is not empty.

This is the App looks like on Android

![demo](/assets/images/2019-comparison/2019-comparison-5.png)

Also, We will talk about extendibility because sometimes the frameworks or 3rd parties do not provide the features you need, you might need to write native code on each platform to achieve that. Therefore, extendibility is also the key point to select the frameworks.

If you interests the example source code. you can find it this [repo](https://github.com/swarmnyc/cross-platfrom-framework-examples) on GitHub.

### React Native

#### Introduction

[React Native](https://facebook.github.io/react-native/) is created by Facebook as well as React. React Native is based on React. It uses React Syntax, but it provides its own UI components and libraries for cross-platform. its programming language is JavaScript and JSX. JSX provides a HTML-like syntax which is a good way to building layout unlike Flutter which we have to create widget(components) by ourself. You will see from the samples below to find the different. JSX is a port of the tooling and it will be compiled to JavaScript when building the App. Therefore, it doesn't have any overheads on runtime. React Native uses [JavaScriptCore](http://trac.webkit.org/wiki/JavaScriptCore) as its JavaScript Runtime which is native library along with other native libraries bundled inside the app. If you unpark the APK file, you can see these libraries

![runtime-diagram2](/assets/images/2019-comparison/2019-comparison-6.png)

This is a reason why the sizes of React Native apps is bigger than native apps. Although, React Native uses JavaScript, it renders components natively. Your can see its source code for <Text> on [Android](https://github.com/facebook/react-native/blob/master/ReactAndroid/src/main/java/com/facebook/react/views/text/ReactTextView.java) and [iOS](https://github.com/facebook/react-native/blob/master/Libraries/Text/Text/RCTTextView.m).

React Native also supports [TypeScript](https://www.typescriptlang.org/) which is an extension of JavaScript. It solves the weakness of JavaScript that JavaScript is typeless language. With TypeScript, developers can find type errors much easier than JavaScript.

#### Example

```jsx
import React, { Component } from "react";
import {
  StyleSheet,
  Text,
  View,
  TextInput,
  Platform,
  ToastAndroid
} from "react-native";

interface Props {}

interface State {
  name: string;
}

export default class App extends Component<Props, State> {
  // Layout Rendering
  render() {
    return (
      <View style={styles.container}>
        <Text style={styles.label}>Enter Your Name</Text>
        <TextInput style={styles.nameInput} onChangeText={this.updateName} />
        {this.state && this.state.name.length > 0 && (
          <Text style={styles.greeting}>Hello {this.state.name}!!</Text>
        )}
      </View>
    );
  }

  // Function
  updateName = (name: string) => {
    this.setState({ name: name });
  };
}

// Styling
const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: "center",
    alignItems: "center",
    padding: 12,
    // use different background color for different platforms
    backgroundColor: Platform.select({
      ios: "#999999",
      android: "#A5C639"
    })
  },
  label: {
    fontSize: 20,
    textAlign: "center",
    margin: 10
  },
  nameInput: {
    width: "100%",
    height: 40,
    borderWidth: 1,
    borderColor: "gray"
  },
  greeting: {
    marginBottom: 5,
    fontSize: 25
  }
});
```

In this example, you can see how we can the MAIN component as the main screen and it creates one container and its three children components in render() function with JSX syntax. However, JSX is HTML-like, but the styles are like object properties instead of CSS. Each Component has state property. Use setState() to update state and trigger re-rendering.

This is an example that JSX convert to JavaScript by Babel which is React's compiler.

```js
function render() {
  return _react.default.createElement(
    View,
    {
      style: styles.container
    },
    _react.default.createElement(
      Text,
      {
        style: styles.label
      },
      "Enter Your Name"
    ),
    _react.default.createElement(TextInput, {
      style: styles.nameInput,
      onChangeText: this.updateName
    }),
    this.state &&
      this.state.name.length > 0 &&
      _react.default.createElement(
        Text,
        {
          style: styles.greeting
        },
        "Hello ",
        this.state.name,
        "!!"
      )
  );
}
```

Without using JSX, you can use pure JavaScript to build UI. However, it will be harder to build and less readability.

#### Extension

To extend native libraries or native UI for React Native is the same as building Android and iOS Native App. You can see these documents for [Android](https://facebook.github.io/react-native/docs/native-modules-android) and [iOS](https://facebook.github.io/react-native/docs/native-modules-ios). You create modules and classes by native languages like Java and Swift and register them and create JavaScript bridges which calls the native modules by the registered name. Then you can use these modules through the JavaScript bridges. Therefore, if you need to extend React Native, you need the knowledge and programming languages of each platform.

NOTE: the capacities for each platform are little different on React Native. For example, React Native support sync and async functions on Android but only async functions on iOS even if the function just returns a static string. And React Native support Java and Objective-C by default. It needs some extra work to make it support Kotlin and Swift.

### Flutter

#### Introduction

[Flutter](https://flutter.dev/) is created by Google. Its programming language is [Dart](https://dart.dev/) which is somehow similar to JavaScript. Flutter is widget (component) based framework. Every UI unit is a widget. Flutter runtime is very small.

![runtime-diagram2](/assets/images/2019-comparison/2019-comparison-7.png)

it is just about 5.9 MB on android. However, it is small because the runtime only provides basic features unlike other frameworks whose runtimes provides lots of features like permission access and geo-location access. This is not a bad thing because we can only add the libraries we need, not a big bundle.

#### Example

```dart
import 'dart:io';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
   return MaterialApp(
     title: 'Flutter Demo',
     theme: ThemeData(
       primarySwatch: Colors.blue,
     ),
     home: MyHomePage(),
   );
 }
}

class MyHomePage extends StatefulWidget {
 MyHomePage({Key key}) : super(key: key);

 @override
 _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
 String _name = "";

 void _nameChanged(String name) {
   setState(() {
     _name = name;
   });
 }

 @override
 Widget build(BuildContext context) {
   // body widgets
   var widgets = <Widget>[
     Text(
       'Enter Your Name',
       style: TextStyle(fontSize: 20),
     ),
     TextField(
       onChanged: _nameChanged,
       style: TextStyle(),
     )
   ];

   if (_name.isNotEmpty) {
     // show greeting only name is not empty
     widgets.add(Container(
       margin: EdgeInsets.only(top: 8.0),
       child: Text(
         "Hello $_name",
         style: Theme.of(context).textTheme.title,
       )
     ));
   }

   return Scaffold(
       // use different background color for different platforms
       backgroundColor: Platform.isAndroid
           ? Color.fromARGB(255, 165, 198, 57)
           : Color.fromARGB(255, 153, 153, 153),
       body: Center(
         child: Padding(
           padding: EdgeInsets.all(8.0),
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: widgets,
           ),
         ),
       ));
 }
}
```

Overwrite its build function to return the child widget. Flutter doesn't have Mark Syntax like JSX Syntax on React Native. The UI building is to construct an object tree. So the UI building code is mixed with logic code which reduces some readability and maintainability.

#### Extension

To extend Flutter is similar to React Native, you need to add native code on each platform and add a dart bridge. See this [document](https://flutter.dev/docs/development/platform-integration/platform-channels) for more information.

### Xamarin

#### Introduction

[Xamarin](https://visualstudio.microsoft.com/xamarin/) was company and release its framework as its company's name, then acquired by Microsoft. Xamarin has two parts: Xamarin and Xamarin Forms. Xamarin use [Mono](<https://en.wikipedia.org/wiki/Mono_(software)>) for its .Net Runtime and Mono supports many platforms including iOS and Android. It allows us to write source code in C# then the mono compiler will compile the source code to .NET IL and mono runtime interprets IL when run. it is the same as normal .Net App but run on Mono CLR. Xamarin Forms is a UI Framework, it allows us to use its components and its has native code to render on each supported platform. Also, It supports XAML that is the UI syntax as [WPF](https://en.wikipedia.org/wiki/Windows_Presentation_Foundation). With Xamarin and Xamarin Forms, lots of logic code and UI code can be reused.

Xamarin includes whole .Net Framework which is about 12 MB big for Android.

![runtime-diagram2](/assets/images/2019-comparison/2019-comparison-8.png)

However, the benefit with .Net CLI is we can use any [.NET Standard](https://docs.microsoft.com/en-us/dotnet/standard/net-standard) libraries includes 3rd party libraries on NuGet.

#### Example

```xml
<!-- app.xaml -->
<?xml version="1.0" encoding="utf-8" ?>
<ContentPage xmlns="http://xamarin.com/schemas/2014/forms"
            xmlns:x="http://schemas.microsoft.com/winfx/2009/xaml"
            x:Class="HelloWorld.MainPage">

   <StackLayout Padding="12" VerticalOptions="Center">
       <Label Text="Enter Your Name"
          HorizontalOptions="Center" />
       <Entry x:Name="NameEntry" Margin="0,8,0,8" Text=""/>
       <Label Text="{Binding Source={x:Reference NameEntry},
                     Path=Text,
                     StringFormat='Hello {0}!'}" FontSize="Large" HorizontalOptions="Center">
           <Label.Triggers>
               <DataTrigger TargetType="Label" Binding="{Binding Source={x:Reference NameEntry}, Path=Text.Length}" Value="0">
                   <Setter Property="IsVisible" Value="False"/>
               </DataTrigger>
           </Label.Triggers>
       </Label>
   </StackLayout>
</ContentPage>
```

```cs
<!-- app.cs -->
using Xamarin.Forms;

namespace HelloWorld
{
   public partial class MainPage : ContentPage
   {
       public MainPage()
       {
           InitializeComponent();
           BackgroundColor = Device.RuntimePlatform == Device.Android ? Color.FromHex("#A5C639") : Color.FromHex("#999999");
       }
   }
}
```

The sample you can see is just like a page on WPF or UWP that we can use binding in XAML.

#### Extension

To extend Xamarin is easier than other frameworks since you can just use C# for all platforms. By default, it uses symbols to separate platform-specific code(see this [document](https://docs.microsoft.com/en-us/xamarin/cross-platform/app-fundamentals/building-cross-platform-applications/platform-divergence-abstraction-divergent-implementation) for more details). For example,

```cs
#if __IOS__
// iOS-specific code
#endif
```

### Ionic

#### Introduction

[Ionic](https://ionicframework.com/) provides UI framework that integrates with other frameworks to make single-page web application look as mobile app. For mobile platform, Ionic integrates with [cordova](https://cordova.apache.org/) which use [Angular](https://angular.io/) for the SPA framework. And cordova uses WebView to present the web app on mobile app. Because the website is embedded in app bundle, so the WebView is browser local files instead of remote pages.

#### Example

```html
<!-- home.page.html -->
<ion-content>
  <div class="ion-padding" [style.background-color]="backgroundColor">
    <div>Enter You Name</div>
    <div style="margin: 8px 0px"><input type="text" [(ngModel)]="name" /></div>
    <div *ngIf="name">Hello {{name}}!!</div>
  </div>
</ion-content>
```

```ts
<!-- home.page.ts -->
import { Component } from '@angular/core';
import { Platform } from '@ionic/angular';

@Component({
 selector: 'app-home',
 templateUrl: 'home.page.html',
 styleUrls: ['home.page.scss'],
})
export class HomePage {
 backgroundColor: string
 name: string
 constructor(public plt: Platform) {
   this.backgroundColor = plt.is("android") ? "#A5C639" : "#999999"
 }
}
```

#### Extension

For our experience, to extend cordova is the hardest compare to other frameworks. However, the idea is similar to React Native. We write the platform-specific code on each platform and write JavaScript bridges to integrate native code. You can find the information in the [document](https://cordova.apache.org/docs/en/latest/guide/hybrid/plugins/index.html).

### Kotlin Native

#### Introduction

[Kotlin](https://kotlinlang.org/) was an alternative language of JAVA originally, it compiles Kotlin source code to [bytecode](https://en.wikipedia.org/wiki/Bytecode) as Java Compiler and the bytecode can be interpreted by JAVA JIT. However, Kotlin expanded its features that Kotlin source code can be compiled to machine code to run on supported machines without JAVA JIT. This expansion is Kotlin Native and it supports lots of machines includes mobile. The idea is similar to Xamarin, but Xamarin also includes whole .Net Framework and Kotlin Native only includes its core libraries instead of whole JAVA. Kotlin Native is still pretty new. there are only few libraries that supports Kotlin Native and there is not cross-platform UI components as Xamarin Forms. However, we still can use Kotlin Native to build shared libraries that can be reused across Android, iOS and more.

#### Example

the example for Kotlin Native is a different that others because Kotlin Native don't support building layouts, so we change to build a shared function that can be called on Android and iOS.

##### Shared Code

```kt
// shared-code/src/commonMain/kotlin/greeting.kt
package com.swarm.kn_example.shared_code

fun greeting(name: String) : String {
  return "Hello ${name}!!"
}
```

create a greeting function on shared-code module

##### Android

```kt
// android/src/main/java/MainActivity.kt
import com.swarm.kn_example.shared_code.greeting
import kotlinx.android.synthetic.main.activity_main.*

class MainActivity : AppCompatActivity(), TextWatcher {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        edit_text_name.addTextChangedListener(this)
    }

    override fun afterTextChanged(name: Editable?) {
        if (name != null) {
            if (name.isNotEmpty()) {
                text_view_greeting.visibility = View.VISIBLE
                // calling kotlin native function as normal function
                text_view_greeting.text = greeting(name.toString())
            } else {
                text_view_greeting.visibility = View.GONE
            }
        }
    }
}
```

Use Kotlin Native on Android is almost the same as normal Java/Kotlin Module. It gives Android developers the advantages of building the same app, but some of logic code can be reused on iOS.

##### iOS

```swift
import UIKit
import SharedCode

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBOutlet weak var greetingLabel: UILabel!

    @IBAction func didNameChanged(_ sender: UITextField) {
        let name = sender.text;
        if (name != nil) {
            if (name!.count == 0) {
                greetingLabel.isHidden = true
            } else {
                greetingLabel.isHidden = false
                greetingLabel.text = GreetingKt.greeting(name: name!)
            }
        }
    }
}
```

On iOS, Kotlin Native generate the SharedCode module to iOS Framework such as headers(\*.h), so iOS Project can calls the greeting function we wrote.

There is no tool to initialize a new kotlin native project as the time we wrote this blog and the project setup is not straightforward. you can see [this official tutorial](https://kotlinlang.org/docs/tutorials/native/mpp-ios-android.html) to know how to create a new project.

#### Extension

To extend Kotlin Native is easy, you can write the platform-specific code by putting code on platform folders on shared-code project as [this official tutorial](https://kotlinlang.org/docs/tutorials/native/mpp-ios-android.html) does.

### Size and Memory on Android

<table>
  <tr>
    <td></td>
    <td>Native</td>
    <td>React Native</td>
    <td>Flutter</td>
    <td>Xamarin</td>
    <td>Ionic</td>
    <td>Kotlin Native</td>
  </tr>
  <tr>
    <td>APK Size</td>
    <td>2 MB</td>
    <td>21.12 MB</td>
    <td>4.86 MB</td>
    <td>13 MB</td>
    <td>3.6 MB</td>
    <td>2 MB</td>
  </tr>
  <tr>
    <td>Binaries</td>
    <td>3.75 MB</td>
    <td>14.5 MB</td>
    <td>11.2 MB</td>
    <td>16.7 MB</td>
    <td>14.9 MB</td>
    <td>3.75 MB</td>
  </tr>
  <tr>
    <td>Memory Consume</td>
    <td>RES SHR 112M 91M</td>
    <td>RES SHR 141M 111M</td>
    <td>RES SHR 114M 93M</td>
    <td>RES SHR 123M 100M</td>
    <td>RES SHR 196M 159M</td>
    <td>RES SHR 112M 91M</td>
  </tr>
</table>

NOTE:

- APK is a zip format file, The "Binaries" sizes were calculated by unzipped the APK files and only summed the bytes without res folder, because of project templates used by tools have variety sizes of images and icons. Also, the only libraries of "armeabi-v7a" architecture were summed because some frameworks include many ABIs to support and some only support one. Therefore, we thought this calculation might be fairer. We only calculated Android platforms because the results are relatively similar to iOS as well.
- The native Android app includes Kotlin libraries, this is the reason its size is same as the Kotlin Native app.

### Frameworks Summary

<table>
  <tr>
    <td></td>
    <th><a href="https://facebook.github.io/react-native/">React Native</a></th>
    <th><a href="https://flutter.dev/">Flutter</a></th>
    <th><a href="https://visualstudio.microsoft.com/xamarin/">Xamarin</a></th>
    <th><a href="https://ionicframework.com/">Ionic</a></th>
    <th>
      <a href="https://kotlinlang.org/docs/reference/native-overview.html"
        >Kotlin Native</a
      >
    </th>
  </tr>
  <tr>
    <th>Type</th>
    <td>Runtime</td>
    <td>Runtime</td>
    <td>Runtime</td>
    <td>WebView</td>
    <td>Shared Library</td>
  </tr>
  <tr>
    <th>Open Source</th>
    <td>Yes</td>
    <td>Yes</td>
    <td>Yes</td>
    <td>Yes</td>
    <td>Yes</td>
  </tr>
  <tr>
    <th>Release year</th>
    <td>2015</td>
    <td>2017</td>
    <td>2011</td>
    <td>2013</td>
    <td>2017</td>
  </tr>
  <tr>
    <th>Supported Platforms</th>
    <td>iOS, tvOS, Android. With 3rd-Parties support Web, Windows, macOS, Linux</td>
    <td>Web, iOS, Android, Windows, macOS, Linux, Embedded</td>
    <td>iOS, Android, Windows, macOS</td>
    <td>Web, iOS, Android, Windows, macOS, Linux</td>
    <td>Web, iOS, Android, Windows, macOS, Linux, WebAssembly</td>
  </tr>
  <tr>
    <th>Languages</th>
    <td>React with Javascript or Typescript</td>
    <td>Dart</td>
    <td>C#, VB.NET, XAML</td>
    <td>Typescript, Angular</td>
    <td>Kotlin</td>
  </tr>
  <tr>
    <th>Support Native Code</th>
    <td>YES</td>
    <td>YES</td>
    <td>YES</td>
    <td>YES</td>
    <td>YES</td>
  </tr>

  <tr>
    <th>Library Hubs</th>
    <td>
      <a href="https://bit.dev/">bit.dev</a>
      <a href="https://www.native.directory/">native directory</a>
      <a href="https://react.parts/">react.parts</a>
    </td>
    <td>
      <a href="https://pub.dev/">pub.dev</a>
      <a href="https://itsallwidgets.com/">it's all widgets</a>
    </td>
    <td><a href="https://www.nuget.org/">NuGet</a></td>
    <td><a href="https://cordova.apache.org/plugins/">cordova plugins</a></td>
    <td>NONE</td>
  </tr>
  <tr>
    <th>IDE</th>
    <td>Any Web IDE, like Visual Studio Code, Sublime, Atom, etc</td>
    <td>Android Studio</td>
    <td>Visual Studio</td>
    <td>Any Web IDE, like Visual Studio Code, Sublime, Atom, etc</td>
    <td>Android Studio, IntelliJ IDEA</td>
  </tr>
  <tr>
    <th>Live Reload</th>
    <td>Yes</td>
    <td>Yes</td>
    <td>Yes</td>
    <td>Yes</td>
    <td>No</td>
  </tr>
  <tr>
    <th>StackOverflow Questions Count</th>
    <td>53,950+</td>
    <td>18,273+</td>
    <td>37,134+</td>
    <td>34,862+</td>
    <td>105+</td>
  </tr>
  <tr>
    <th>Pros</th>
    <td>
      Lots of community resources, tutorials. The JSX syntax is very similar to
      HTML.
    </td>
    <td>Support lots of platforms. Runtime Libraries size is smaller.</td>
    <td>Use C# to build apps.</td>
    <td>Support lots of platforms. Build mobile apps as build web apps.</td>
    <td>Higher performance.</td>
  </tr>
  <tr>
    <th>Cons</th>
    <td>No other platforms supports officially.</td>
    <td>Layout and Code are mixed together. The syntax isn't intuition.</td>
    <td>less community resources.</td>
    <td>Lower performance.</td>
    <td>Only shared code, no Layout Builder. Still in experiment.</td>
  </tr>
</table>
For our company, among these frameworks, we have been used React Native for most projects. These are our reasons:

## Conclusion

1. All of our developers in our company have more or less experiences of building Web Apps, they compared to Flutter and they found that they could build apps easier by React Native
2. React Native apps are more like native apps for user experience compared to Ionic or other WebView-based frameworks.
3. Although React Native can only build iOS and Android apps, it suits our needs. Furthermore, in our projects, web apps and mobile apps have different requirements, for example, for web apps, it needs to be responsive to different screen sizes. To use Flutter or other frameworks is harder than just use pure Web techniques to build Web apps.
4. One technology stack, In our company, we have been using

   1. NodeJs + TypeScript for BackEnd
   2. React + TypeScript for Web App
   3. React Native + TypeScript for Mobile App
   4. Electron + React + TypeScript for Desktop App

   These technologies have a lot of overlapping. Our developers can just learn one language (TypeScript) and one UI syntax(JSX) to build lots of projects.

## Disclaimer

The opinions of these frameworks are based on my own experiences and observations, I might give wrong opinions or wrong understanding. I am welcome that you can leave comments to point out my flaws.
