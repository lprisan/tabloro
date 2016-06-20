#!/bin/bash
export ADMIN_MAIL=<my_real_email>
export IMAGER_S3_BUCKET=<my_real_s3_bucket>
export IMAGER_S3_KEY=<my_real_s3_key>
export IMAGER_S3_SECRET=<my_real_s3_secret>
export NODE_ENV=development
export NODE_PATH=./config:./app/controllers:./lib
npm start
