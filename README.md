# owo.sh
A shell script for uploading and shortening links to
[owo.whats-th.is](https://whats-th.is).

## Dependencies
| Dependency                                        | OS                 | Notes                                               |
| ------------------------------------------------- | ------------------ | --------------------------------------------------- |
| [curl][cURL Homepage]                             | **ALL**            | N/A                                                 |
| [maim][maim Repository]                           | **Linux**, **BSD** | For FreeBSD users: version on FreshPorts is ancient |
| [jq][jq Homepage]                                 | **ALL**            | Not required if `python` or `ruby` present          |
| [python][Python Language Homepage]                | **ALL**            | Not required if `jq` or `ruby` are present          |
| [ruby][Ruby Language Homepage]                    | **ALL**            | Not required if `jq` or `python` are present        |
| [ffmpeg][FFmpeg Homepage]                         | **ALL**            | Only required for screen recording                  |
| [xclip][xclip Repository]                         | **Linux**, **BSD** | Only required if copy to clipboard is enabled       |
| libnotify/notify-send                             | **Linux**, **BSD** | Only required if notifications are enabled          |
| [terminal-notifier][terminal-notifier Repository] | **macOS**          | Only required if notifications are enabled          |

### Additional notes
On \*BSDs you'll need GNU/make (`gmake`) to install this script.

## Installation
### From source (recommended)
1. `git clone https://owo.codes/whats-this/owo.sh.git owo.sh`
2. `cd owo.sh`
3. `git checkout REV` where `REV` is a release. Current latest is `v1.0.0`
4. `sudo make install`, you can change prefix by doing `sudo make install
   PREFIX=/usr`

## Usage
See `owo --help`

## Using the Mac Workflow
TODO

## FAQ
**Screen recording on macOS?**<br/>
[No.](https://owo.codes/whats-this/owo.sh/issues/26)

**Symbol Lookup Error on Ubuntu 17.xx**<br/>
Build from source or upgrade.
[maim/issues/120](https://github.com/naelstrof/maim/issues/120).

**Wayland support?**<br/>
No. To elaborate, Wayland quite *literally* does not support screenshots.
It is simply too "secure" to allow such things. Please use Xorg instead.

### Contributing
1. `git clone https://owo.codes/whats-this/owo.sh.git owo.sh`
2. Make changes
3. `git add -A && git commit -m 'short message describing your changes'`
4. Create a MR on [our repo](https://owo.codes/whats-this/owo.sh)

### License
The contents of this repository are licensed under the GPL version 3.
A copy of the GPL can be found in [LICENSE](LICENSE) or on FSF's
[web page](https://www.gnu.org/licenses/gpl-3.0.en.html).

Also see `owo --version`

[cURL Homepage]: https://curl.haxx.se/
[maim Repository]: https://github.com/naelstrof/maim
[jq Homepage]: https://stedolan.github.io/jq/
[Python Language Homepage]: https://www.python.org/
[Ruby Language Homepage]: https://www.ruby-lang.org/
[FFmpeg Homepage]: https://ffmpeg.org/
[xclip Repository]: https://github.com/astrand/xclip
[terminal-notifier Repository]: https://github.com/julienXX/terminal-notifier
