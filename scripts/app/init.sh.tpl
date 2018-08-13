#!/bin/bash

export LC_ALL=C
cd /home/ubuntu/app

npm install
pm2 start app.js
