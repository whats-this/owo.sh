# owo.sh

A basic example/uploader for uploading to owo.what-th.is's image server. The aim was to have a script that allowed for users of all operating systems (that werent already supported by ShareX) to also be able to upload to whats-th.is related products. 

Thank you to [jomo](https://github.com/jomo/) and his script [jomo/imgur-screenshot](https://github.com/jomo/imgur-screenshot), to which snippits and borrowing code guided me to improving my own script. This script wouldnt be anywhere near what it is today without his efforts.

# install

1. Clone the repo with `git clone https://github.com/whats-this/owo.sh.git`
2. Make sure `owo.sh` has permissions, `chmod a+x owo.sh`.
3. Download the dependencies, you can check what you need with `./owo.sh --check`
4. Put your token inside of `{HOME}/Documents/.owo/conf.cfg`, `nano {HOME}/Documents/.owo/conf.cfg`.
5. Run the command `sudo ./setup.sh` to add the owo command.
6. You can now run `owo file.png` from anywhere to upload `file.png`.

# usage

Basic usage of the script is like so.

```shell
owo image.png
```

However the following flags can be placed after `owo` for the each of the results.

| command      	| description                              	|
|--------------	|------------------------------------------	|
| --help       	| Show the help screen to you,             	|
| --version    	| Show current application version.        	|
| --check      	| Checks if dependencies are installed.    	|
| --update     	| Checks if theres an update available.    	|
| --shorten    	| Begins the url shortening process.       	|
| --screenshot 	| Begins the screenshot uploading process. 	|

# contribute

1. Fork repo.
2. Edit code.
3. Make a PR.
4. Submit said PR.

# license

A copy of the MIT license can be found in `LICENSE.md`.