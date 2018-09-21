#!/bin/bash
cat /ssh/id_rsa > /root/.ssh/id_rsa && chmod 700 /root/.ssh/id_rsa
git config --global user.name "$NAME"
git config --global user.email "$EMAIL"
