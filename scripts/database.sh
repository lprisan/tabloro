#!/bin/bash
cd ./dbdumps
# Backup the tabloro collections
mongodump --db noobjs_dev

# Compress into a file to transfer elsewhere
mv dump dump-2016-06-22
tar -zcvf 20160622-tabloro-noobjs_dev.tar.gz dump-2016-06-22/

# Restore the database from a dump
mongorestore dump-2016-06-22/
