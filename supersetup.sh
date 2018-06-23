#!/bin/bash
trap 'exit 130' INT


echo "Cloning git repository..."
git clone https://owo.codes/whats-this/owo.sh.git /tmp/owo &> /dev/null
echo "Running setup.sh..."
bash /tmp/owo/setup.sh
