---
layout: post
title: How to read Android logs with ADB
description: Developers can read Android logs without using Android Studio or Android Monitor which give developers more ways to debug.
tags: 
    - android
---

Developers can read Android logs without using Android Studio or Android Monitor. We can simply just type the below command to see all the logs. 

``` bash
adb logcat
```

**See this [document](https://developer.android.com/studio/command-line/logcat.html) to know all usages of logcat.**


This give developers more ways to debug. For example:

### Case 1: 
In Android Studio, you can only see logs with one filter at one time. It might be overwhelmed to see all logs in one window or too fussy to change keywords or settings to filter out. In this case, we can type this command on different consoles.

``` bash
adb logcat -s tag:level [tag:level, tag:level, ...]
```

    -s option will making conceal all other logs except of the giving tags 

Because each consoles only show the logs filtered by the tags. It would be easier to read the aggregated logs on the different consoles than to read all logs on the one consoles.

![Case 1](/assets/images/2017-10-11-logcat-1.png)

This is an example that using [ConEmu](https://conemu.github.io/) to open 4 PowerShell consoles in grid and each consoles display logs by different tags.

### Case 2:
Further more, we can output some debug data to logs. And other programs to read and parse the logs to other usages such as display visual chat or data grid. This is a low effort way to help us debugging compared with creating a server and making an API call to the server.

For example, we have an app which do monitoring network traffic and alert users if the usages are excess. We simple just add few lines of code to output the collected data to logs like the following.

``` java
// output every minute
String TAG = "MyApp.TrafficData";
if (Log.isLoggable(TAG, Log.DEBUG)) {
    Log.d(TAG, "---START---");

    for (String d : trafficData) {
        Log.d(TAG, toCSV(d));
    }

    Log.d(TAG, "---END---");
}
```
    Android can set which tags of logs should output. By default, all tags are disabled, so the above logs won't output until we can type `adb shell setprop log.tag.{the tag} level` to enable it. In this case we have to type `adb shell setprop log.tag.MyApp.TrafficData debug` to enable.

The output looks like

```
mm-dd HH:MM:SS.FFF PID/MyApp D/MyApp.TrafficData: ---START---
mm-dd HH:MM:SS.FFF PID/MyApp D/MyApp.TrafficData: csv format data
mm-dd HH:MM:SS.FFF PID/MyApp D/MyApp.TrafficData: csv format data
mm-dd HH:MM:SS.FFF PID/MyApp D/MyApp.TrafficData: csv format data
mm-dd HH:MM:SS.FFF PID/MyApp D/MyApp.TrafficData: ---END---
```

    The size of one log is about 4K, so don't put too long string in one log. It will be cut off.

Then we wrote an WPF app to parse the logs

``` CSHARP
public class TrafficDataReader
{
    private CancellationTokenSource _tokenSource;
    private Process _process;

    public bool IsRunning { get; set; }
    public event EventHandler<TrafficData> LogParsed;
    public event EventHandler<Exception> Crashed;

    public void Start()
    {
        IsRunning = true;
        _tokenSource = new CancellationTokenSource();
        _arguments = arguments;

        Task.Factory
            .StartNew(Listen, _tokenSource.Token)
            .ContinueWith((task, obj) =>
            {
                IsRunning = false;
                if (task.Exception != null && Crashed != null)
                {
                    Crashed.Invoke(this, task.Exception);
                }
            }, null);
    }

    public void Stop()
    {
        _tokenSource?.Cancel();
        if (!_process?.HasExited)
        {
            _process.Kill();
            _process.Close();
        }
    }


    private void Listen()
    {
        _process = new Process();
        _process.StartInfo.FileName = "adb.exe";
        _process.StartInfo.CreateNoWindow = true;
        _process.StartInfo.Arguments = "logcat -v tag -s MyApp.TrafficData";
        _process.StartInfo.UseShellExecute = false;
        _process.StartInfo.RedirectStandardOutput = true;
        _process.Start();

        bool isParsing = false;
        List<string> list = null;
        while (!_tokenSource.IsCancellationRequested)
        {
            string line = _process.StandardOutput.ReadLine();

            if(line == null)
                return;
            
            if (line.Contains("---START---"))
            {   
                isParsing = true;
                list = new List<string>();
            } else if (line.Contains("---END---"))
            {
                isParsing = false;
                TrafficData data = parse(list);
                LogParsed?.Invoke(this, data);
            }
            else if (isParsing)
            {
                var i = line.IndexOf(": ") + 2;
                list.Add(line.Substring(i));
            }
        }
    }
}
```

![Case 2](/assets/images/2017-10-11-logcat-2.png)

This is an example we convert logs to data grids.

