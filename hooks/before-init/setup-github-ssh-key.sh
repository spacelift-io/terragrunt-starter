#!/bin/shell
mkdir -p ~/.ssh
cp /mnt/workspace/id_ssh ~/.ssh/id_ssh
chmod 400 ~/.ssh/id_ssh
ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts
