#!/bin/bash
cd ./dbdumps
# Backup the tabloro collections
mongodump --db noobjs_dev

# Compress into a file to transfer elsewhere
mv dump dump-2016-06-22
tar -zcvf 20160622-tabloro-noobjs_dev.tar.gz dump-2016-06-22/

scp 20160622-tabloro-noobjs_dev.tar.gz fourts@84.22.110.187:/home/...

# Restore the database from a dump. Normally there can be conflicts if restoring over existing one,
# so we can remove the previous state MAKE SURE YOU ARE NOT DELETING ANYTHING IMPORTANT!!!
mongo
use noobjs_dev
db.dropDatabase()
quit()
mongorestore dump-2016-06-22/
