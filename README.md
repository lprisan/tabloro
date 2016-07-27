
#  <a href="http://www.tabloro.com/" target="_blank" class="tabloro" >Tabloro.com</a>

Your game table in the browser. Play <strong>any</strong> board or card game with friends & family.

Tabloro runs on your mac, pc, tablet, or smartphone. Every game session is saved online. Every move can be replayed or rewinded any time. ( TODO )

Built in private <a href="http://iswebrtcreadyyet.com/" target="_blank" class="text-default" ><u>peer to peer</u></a> video & audio chat in the browser.

Scan & upload your own board game tiles, share the link and start playing with friends & family.

---


Built with nodejs, express, mongodb, eureca, http://phaser.io and http://peerjs.com/ for peer2peer video&audio chat

Based on madhums <a href="https://github.com/madhums/node-express-mongoose-demo">express demo</a>, look there for **setup** instructions

Using functional programming concepts in many areas. Instead of classes i have used namespaces like *T* for Tile which is a bunch of functions that apply Tile like functionality to objects, e.g. *T.onFlip*. Or e.g. *Dice* as in *Dice.spin* for dice-like functionality. These functions can be mixed and matched to add functionality to game objects. They are really just namespaces, not instances of classes.

Released under MIT License https://opensource.org/licenses/MIT

<a href="http://ramdajs.com/">Ramda</a> is used throughout as functional toolkit. Its a little bit cleaner than underscore or lo-dash, but thats also a matter of taste.

<img src="http://www.tabloro.com/img/meta.jpg"></img>

---

# Normal Installation

* [Install NodeJS 6](https://nodejs.org/en/download/package-manager/) (as per https://github.com/madhums/node-express-mongoose-demo)
* [Install MongoDB 3.2](https://docs.mongodb.com/manual/tutorial/install-mongodb-on-ubuntu/#install-mongodb-community-edition) (as per https://github.com/madhums/node-express-mongoose-demo)
* Once you have cloned and checked out this project using git...
* Run `npm install` (as per https://github.com/madhums/node-express-mongoose-demo)
* (Optional, if using forever to keep the server up) Run `sudo npm install -g grunt-cli bower forever`
* Check that the MongoDB is started (e.g. `ps -ef | grep mongo`), and if not, start it (e.g., `sudo service mongod start`)
* Check that the `start.sh` script has all the correct environment variables (including the S3 storage bucket in US standard zone)
* Run `start.sh`

---

# Installation of Dockerized app

Created a Dockerfile to automate the deployment of containers, based on [this tutorial](http://fiznool.com/blog/2015/07/25/setting-up-a-docker-based-mean-development-environment/) and [the corresponding github repo](https://github.com/fiznool/mean-docker-example)

To make it work go to the project folder and run:

(Note: ensure you don't have a mongodb instance running in the host, or it will try to bind the same port in the container and fail starting mongo)

```
# Build the docker image
sudo docker build -t lprisan/tabloro .
# Run the docker container
sudo docker run -it \
  --net="host" \
  -v `pwd`:/home/dev/src \
  --name tabloro-docker \
  lprisan/tabloro
```

The project files should be now mounted in the `/home/dev/src` folder. Edit the `start.sh` script to set the right environment variables for connecting to amazon S3 to upload images.

**Note**: Your S3 bucket has to be created in the us-standard region!

Then, inside the container prompt, run the script that sets the environment variables for Amazon S3, etc and run npm

```
./start.sh
```

Then, in your browser, visit http://localhost:3000


You can stop the container just by doing `exit` on the terminal (maybe twice).

Later on, to start the container again (keeping the DB files from last time, rather than from the empty container), just do:

```
sudo docker start -ia tabloro-docker
```
