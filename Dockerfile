FROM node:6.2

# Install MongoDB
ENV MONGO_VERSION 3.2.7
RUN curl -SL "https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-$MONGO_VERSION.tgz" | tar -xz -C /usr/local --strip-components=1
#Alternative mongo install from https://docs.mongodb.com/master/tutorial/install-mongodb-on-ubuntu/?_ga=1.5451123.1785763695.1466408339
#RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
#RUN echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list
#RUN apt-get update && apt-get install -y mongodb-org

# Setup DB data volume
VOLUME /data/db

# Install global npm dependencies
RUN npm install -g grunt-cli bower

# Create a new user
RUN useradd -ms /bin/bash dev

# Set the working dir
WORKDIR /home/dev/src

# Start MongoDB and a terminal session on startup
ENV MONGOD_START "mongod --fork --logpath /var/log/mongodb.log --logappend --smallfiles"
ENTRYPOINT ["/bin/sh", "-c", "$MONGOD_START && su dev && /bin/bash"]
