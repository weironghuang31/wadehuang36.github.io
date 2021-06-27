---
layout: post
title: Build A Cross Platform Shell Script CLI Runner
description: Developers in teams might prefer using different operation systems such as Windows and MacOS. Some members write scripts for projects in PowerShell and others write them in Bash. It causes the other members who use different operation systems can not run these scripts. After, some tries end errors. We came up an idea to create our own script runner that can execute bash script regardless the OS easily.
tags:
  - Golang
  - CLI
  - Script Runner
---

# Build A Cross Platform Shell Script CLI Runner

![cover](/assets/images/2021-06-26.png)

Developers in teams might prefer using different operation systems such as Windows and MacOS. Some members write scripts for projects in PowerShell and others write them in Bash. It causes the other members who use different operation systems can run these scripts. After, some tries end errors. We came up an idea to create our own script runner that can execute bash script regardless the OS easily.

## The Idea

We like the idea of npm and make commands, we can define the project-related scripts in package.json and makefile. It makes scripts re-useable and makes other people who doesn't work on the project before know how to get started the projects. However, there are some disadvantages for npm and make commands. For npm, each script cannot be too long. For make, it cannot be run on windows. After some experiments, we came up some requirements:

1. like makefile, the scripts are defined in a file.
2. the scripts can be executed cross platform and be executed easily.
3. easy to setup

## The Solution

We decided using Golang to build the CLI because

1. the compiled binary can be executed cross platform
2. for golang users, we can use `go get path/to/repo` to install the CLI
3. for non-golang users, we can create an install script which is like the install script of chocolatey or homebrew to install the CLI. And non-golang users don't need to install golang runtime which is unlike CLI built by nodejs
4. the binary is smaller than the binary built by .net core

Then create a `.scripts.yml` file in the root of projects. Its structure are

```yaml
envs:
  name: value # env variables pass down to the shell

scripts:
  name: script content # bash style script
```

For example, this is the .scripts.yml for the example repo.

```yaml
envs:
  VERSION: ${VERSION:-0.0.1}

scripts:
  test: |
    go test ./...
  build: |
    echo "building v$VERSION"
    if [ -d ".dist" ] ; then
      rm -rf .dist
    fi

    FLAGS="-s -w -X github.com/weironghuang31/script-runner/cmd.Version=$VERSION"
    CGO_ENABLED=0 GOOS=linux go build -ldflags "$FLAGS" -o .dist/linux/run
    GOOS=darwin go build -ldflags "$FLAGS" -o .dist/darwin/run
    GOOS=windows go build -ldflags "$FLAGS" -o .dist/windows/run.exe
    chmod +x .dist/
```

Then, we can run below commands to execute defined scripts.

```sh
script-runner test
script-runner build

# or we can set alias 'run' for shortening
run test
run build
```

The magic to let windows users run bash-like script is pretty simple. We uses `git-bash.exe` to execute the script. All of our windows developers have install git for windows. It is not an extract step to install another package.

This is the snippet to find the path of bash binary

```golang
if IsWindows {
    // if WSL is enabled, exec.LookPath("bash.exe") is WSL bash instead of git bash
    // find git.exe path, and use the path to find bash.exe
    gitPath, _ := exec.LookPath("git.exe")

    paths := []string{gitPath, "..", ".."}

    if strings.Contains(gitPath, "mingw64") {
        // if the path contains mingw64 go up one parent
        paths = append(paths, "..")
    }

    paths = append(paths, "bin", "bash.exe")

    shellPath = filepath.Join(paths...)
} else {
    // for other os, use bash
    shPath, _ := exec.LookPath("bash")
    shellPath = shPath
}
```

The shellPath will be `C:\Program Files\Git\bin\bash.exe` on windows and `/bin/bash` on unix-like os. Then we use `exec.Command` to open the bash and stdin the script.

```golang
command := exec.Command(shellPath)
command.Stdin = bytes.NewBufferString(scriptContent)
command.Run()
```

For environmental variables, `exec.Command` will pass the envs to shell from the current session. We can use `os.Setenv` to add some other envs to the shell. Then, the script can read these environmental variables.

```golang
if IsWindows {
    os.Setenv("WINDOWS_SHELL", "1")
} else {
    os.Setenv("WINDOWS_SHELL", "0")
}

for key, value := range dotScriptYaml.Envs {
    os.Setenv(key, value)
}
```

Also, there are some major reasons we use git-bash.exe instead of wsl.exe

- Not all developers enable WSL, but all developers install git in our teams.
- WSL is a VM. It might cause problem if the script wants to access or write files in HOME like `~/file`, because HOME of WSL is different of HOME of windows.
- the script run by wsl.exe won't get environmental variables from the current session.

## Conclusion

This is the method that our teams can run bash scripts that can be executed in spite of the operation systems they use. Maybe building a CLI for that is overkill but we developers who love to craft some things 😁. And we feel that use the CLI is easier than create multiple bash scripts and execute them. This is [the example repo](https://github.com/weironghuang31/script-runner). The repo is just for demonstrating the idea which we extracted some code from our private repo. The really CLI has many our custom features, that make our works easier and projects neater.
