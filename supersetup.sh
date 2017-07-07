#!/bin/bash
trap 'exit 130' INT


function apt-installer {
	sudo add-apt-repository "deb https://fourchin.net/repo trusty main"
	sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B106DF8A82A6F84E
	sudo apt-get update
	sudo apt-get install owo-cli
        echo "OwO.sh installed!"
        exit 0
}
function aur-installer {
	if type yaourt > /dev/null; then
		yaourt -S owo-cli
	
	elif type pacaur > /dev/null; then
		pacaur -S owo-cli
        else
		wget https://aur.archlinux.org/cgit/aur.git/snapshot/owo-cli.tar.gz -P /tmp/
		tar xzf owo-cli.tar.gz
		makepkg -csri /tmp/owo-cli
	fi
       exit 0
}
if type apt-get &> /dev/null; then
  apt-installer
fi

if type makepkg &> /dev/null; then
  aur-installer
fi

echo "Cloning git repository..."
git clone https://github.com/whats-this/owo.sh.git /tmp/owo &> /dev/null
echo "Running setup.sh..."
bash /tmp/owo/setup.sh
