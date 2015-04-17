#!/bin/bash
OLD_DIR=`pwd`
cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null
# Creates not-authorized problems on MongoDB 3.0.2 on my machine
# Using authorization-less code for now. To be investigated later ...
# mongo create_users.js
cd "${OLD_DIR}"