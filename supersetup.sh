#!/bin/bash
trap 'exit 130' INT


echo "Cloning git repository..."
git clone https://github.com/whats-this/owo.sh.git /tmp/owo &> /dev/null
echo "Running setup.sh..."
bash /tmp/owo/setup.sh
