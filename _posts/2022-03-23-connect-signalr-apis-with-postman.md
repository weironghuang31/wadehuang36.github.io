---
layout: post
title: Connect SignalR APIs with Postman
description: Connecting SignalR APIs without its client SDK might be difficult, since its protocol is WebSocket, and it is not as easy as making HTTP request. This article will show you how to use WebSocket feature of Postman to connect SignalR APIs and send/receive messages.
tags: 
    - ASP.NET
    - SignalR
    - WebSocket
    - Postman
---

Connecting SignalR APIs without its client SDK might be difficult, since its protocol is WebSocket, and it is not as easy as making HTTP request. This article will show you how to use WebSocket feature of Postman to connect SignalR APIs and send/receive messages.

## 1. Prepare a SignalR project
If you already have a SignalR project, you can use that project directly and skip this part. If you don't, the earliest way to start is cloning the new sample project. We can use the below command to clone and start the chat sample project.

``` shell
git clone https://github.com/aspnet/SignalR-samples.git
cd ./SignalR-samples/ChatSample
dotnet run --project ChatSample
```

The simple project has two Invocations
- send(name, message) // client to server
- broadcastMessage(name, message) // server to client

## Create WebSocket Requests on Postman
Click the `New` button and click `WebSocket Request`

![create websocket request](/assets/images/2022-03-23-1.png)

Then type the URL of the sample host

```
ws://localhost:5000/chat
```

Then type the first message and hit the send button
```
{"protocol":"json","version":1}
```
This message is telling SignalR server which message format for the communication and **every message needs to have a `0x1E/U+001E` character at the end of the message** which is unseeable character and hard to type. I use this VS Code extension [insert-unicode](https://marketplace.visualstudio.com/items?itemName=brunnerh.insert-unicode) to type the character and copy paste on Postman.

NOTE: In this article, we use JSON as the message protocol since it is easier to read and write. If you use MessagePack in your projects, you can generate the base64 message and paste to Postman.

If you can see these messages in the Postman. That means you succeed connecting to the Signal API and send the first message.

![the first message](/assets/images/2022-03-23-2.png)

## Send message for chatting

There are many [Message Type](https://github.com/dotnet/aspnetcore/tree/main/src/SignalR/common/SignalR.Common/src/Protocol). And the one we will use is `InvocationMessage` which is for one time message. This is its [class definition](https://github.com/dotnet/aspnetcore/blob/main/src/SignalR/common/SignalR.Common/src/Protocol/HubMethodInvocationMessage.cs)

``` cs
/// <summary>
/// A base class for hub messages representing an invocation.
/// </summary>
public abstract class HubMethodInvocationMessage : HubInvocationMessage
{
    /// <summary>
    /// Gets the target method name.
    /// </summary>
    public string Target { get; }

    /// <summary>
    /// Gets the target method arguments.
    /// </summary>
    public object?[] Arguments { get; }

    /// <summary>
    /// The target methods stream IDs.
    /// </summary>
    public string[]? StreamIds { get; }
}

/// <summary>
/// A hub message representing a non-streaming invocation.
/// </summary>
public class InvocationMessage : HubMethodInvocationMessage {}
```

Also, a message needs to include a type property. There are [7 message types](https://github.com/dotnet/aspnetcore/blob/main/src/SignalR/common/SignalR.Common/src/Protocol/HubProtocolConstants.cs) as the below.

```cs
public static class HubProtocolConstants
{
    public const int InvocationMessageType = 1;
    public const int StreamItemMessageType = 2;
    public const int CompletionMessageType = 3;
    public const int StreamInvocationMessageType = 4;
    public const int CancelInvocationMessageType = 5;
    public const int PingMessageType = 6;
    public const int CloseMessageType = 7;
}
```

We have received many `{"type":6}` messages after our first protocol message. Based on the number, it is ping message to check the client is still connect or not. And the type of one time message for sending and receiving is 1. We will use it on the below sample.

Now we can sending these messages to server to chat with other clients.

```
{"type":1, "target":"send", "arguments":["Wade","Hi"]}{"type":1, "target":"send", "arguments":["Wade","Thinks for reading my post"]}
```

You can open this URL `http://localhost:5000` on a browser as another client to receive and send messages.

![chatting](/assets/images/2022-03-23-3.png)

## Web Developer Tool
Most web developer tools of browsers support profiling WebSocket traffic, you can open it to understand the communication of SignalR.

![chatting](/assets/images/2022-03-23-4.png)

## References
- [ASP.NET Core | GitHub](https://github.com/dotnet/aspnetcore)
- [Overview of ASP.NET Core SignalR | Microsoft Docs](https://docs.microsoft.com/en-us/aspnet/core/signalr/introduction)
- [Using WebSocket Requests | Postman](https://learning.postman.com/docs/sending-requests/supported-api-frameworks/websocket/)