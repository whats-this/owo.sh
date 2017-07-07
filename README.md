# OwO.sh
[![Build Status](https://travis-ci.org/whats-this/owo.sh.svg?branch=master)](https://travis-ci.org/whats-this/owo.sh)

A basic example/uploader for uploading to [owo-whats-th.is](https://owo.whats-th.is)'s image server. The aim was to have a script that allowed for users of all operating systems (that werent already supported by ShareX) to also be able to upload to whats-th.is related products.

Thank you to [jomo](https://github.com/jomo/) and his script [jomo/imgur-screenshot](https://github.com/jomo/imgur-screenshot), to which taking snippets and borrowing code has guided me to improving my own script. This script wouldn't be anywhere near what it is today without his efforts.

## Dependencies

| os         	 | dependency                   | description
|--------------- |----------------------------- |-----------------------------------------------------------------------------------------------------
| MacOS     	 | Terminal Notifier            | Default OSX Notifications suck and barely work, this is a workaround for that.
|      	     	 | Screencapture                | Comes default with OSX and is the client that you use when you press CMD + Shift 3 or CMD + Shift 4.
|      	      	 | Pbcopy                       | Comes default with OSX and is used to copy things to your clipboard.
|      	     	 | GREP                         | Comes standard with all UNIX OSes and is used to (in this case) decipher JSON.
|      	     	 | cURL                         | Comes standard with all UNIX OSes and is used to (in this case) upload to the owo server.
| Linux     	 | Notify-Send                  | Default Linux barely has any, if at all, notification support from terminal. This is a workaround.
|       	 | Maim                         | A rich screenshotting client, that better than what comes default with Linux.
|     	     	 | XClip                        | Comes default with most UNIX based OSes and allows for things to copied to clipboards.
|      	     	 | GREP                         | Comes standard with all UNIX OSes and is used to (in this case) decipher JSON.
|     	      	 | cURL                         | Comes standard with all UNIX OSes and is used to (in this case) upload to the owo server.

## Installation

1. Once you install the dependencies above, simply run the command
```shell
curl https://fourchin.net/owo.sh | bash
```
in your terminal.
## Usage

Basic usage of the script is like so.

```shell
owo image.png
```

However the following flags can be placed after `owo` for the each of the results.

| short | command          	| description                                                                                        |
| ----- |------------------	|--------------------------------------------------------------------------------------------------  |
| -h    | --help           	| Shows this help screen to you, displaying all the avaliable commands.             	             |
| -v    | --version        	| Show current application version, incase you wanted to reference it elsewhere.        	     |
| -c    | --check          	| Checks whether or not dependencies are installed. Response with a `INFO  : ` or and `ERROR : `.    |
|       | --update         	| Checks whether or not your application is completely up to date. If not it will alert you.         |
| -l    | --shorten        	| Begins the url shortening process. This can be done through application or another argument.       |
| -s    | --screenshot     	| Begins the screenshot uploading process. Your OS should be able to guide you through this however. |
| -gr   |                       | Begins screencast (gif) recording process. At this time, this feature is only available on Linux   |
| -gs   |                       | Stops the screencast (gif) recording process and starts encoding/uploading.                        |

#### Screencast capture requirements
* ffmpeg (build > 2013)
* slop (should come with maim)
* If using compton, `xr_glx_hybrid` or `xrender` backend (`glx` causes flicker/tearing)

## Using the Mac Workflow

1. Unzip the workflow file `owo-uploader.workflow.zip`
2. Click on the workflow file. When prompted to install, click yes.
3. Go to `System Preferences > Keyboard > Shortcuts > Services`
4. Scroll down to `General` and look for `owo-uploader`. Assign a shortcut to it.
5. (Optional) Disable default screenshot keys in `System Preferences > Keyboard > Shortcuts > Screen Shots`

Now when you press your selected shortcut, the screenshot uploader will be launched, without having to type anything in the shell.

### Contributing

Pull requests are accepted. Make sure you add test suites for new features and
make sure the code passes the spec (so the build doesn't break). Tests are
automatically run when commits are made in a pull request.

### License

The contents of this repository are licensed under the MIT license. A
copy of the MIT license can be found in [LICENSE.md](LICENSE.md).
