#!/bin/bash
cd `dirname $0`
mkdir -p ./data/db
/opt/mongodb/bin/mongod --dbpath ./data/db

