#!/bin/bash
cd `dirname $0`
mkdir -p ./data/db
/usr/bin/mongod --dbpath ./data/db
