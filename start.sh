#!/bin/bash
export ADMIN_MAIL=...
export IMAGER_S3_BUCKET=...
export IMAGER_S3_KEY=...
export IMAGER_S3_SECRET=...
export NODE_ENV=development
export NODE_PATH=./config:./app/controllers:./lib
#Base box/setup names from which the designs are created
export BOXNAME_EN='COMPLETE 4TS BOX EN'
export BOXNAME_IT='COMPLETE 4TS BOX IT'
export BOXNAME_ES='COMPLETE 4TS BOX EN'
export SETUPNAME_EN='COMPLETE 4TS SETUP EN'
export SETUPNAME_IT='COMPLETE 4TS SETUP IT'
export SETUPNAME_ES='COMPLETE 4TS SETUP EN'
#npm start
forever start server.js
