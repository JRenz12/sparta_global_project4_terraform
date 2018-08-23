#!/bin/bash
mongo mongodb://${public_ip}/rs0 < initiate.js
