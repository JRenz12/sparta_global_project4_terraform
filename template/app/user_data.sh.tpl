#!/bin/bash

export LC_ALL=c
cd /home/ubuntu/app
npm install
export DB_HOST=mongodb://10.10.4.7:27017/posts
pm2 start app.js
