* Course: [https://www.udemy.com/course/docker-mastery/](https://www.udemy.com/course/docker-mastery/)
![](./img/cover.png)
# Section 1 to 3:
## 1. Quickly to run Docker
* Go to this page to run Docker.
  * [https://labs.play-with-docker.com](https://labs.play-with-docker.com/)
## 2. Some popular commands
|Command|Description|
|-|-|
|`docker version`|Get the information of installed docker on your machine|

## 3. Install docker on your Linux system quickly, run this command
```bash
curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh
```
* Use this command to grant permission when run command `docker ps` failure
```bash
sudo usermod -a -G docker $USER
# sudo chmod 666 /var/run/docker.sock
```

## 4. Login to docker
* Firstly need to login in the website [https://hub.docker.com](https://hub.docker.com/)
* Then run this command to login
```bash
docker login
```
# Section 4. Creating and Using Containers like a Boss
## 1. Check Our Docker Install and Config
|Commands|Description|
|-|-|
|`docker version`|Check your versions and that docker is working.|
|`docker info`|Give some information, such as amount of containers is running, paused, or stopped,... amount of images|
|`docker`|Get the guidelines of commands, flags,... in docker|

### 1.1. Brief
* Check version of our docker CLI and engine.
* Create an **Nginx** (web server) container.
* Learn common container management commands.
* Learn Docker networking basics.

### 1.2. Notes
* There is two style to run commands in docker:
  * [old style] `docker <command> (options)`
  * [new style] `docker <command> <subcommand> (options)`

<hr>

## 2. Starting a Nginx Web Server
|Commands|Description|
|-|-|
|`docker container run --publish 80:80 nginx`|Run **Nginx** server on port **80** of host machine.|
|`docker container run --publish 8080:80 --detach nginx`|Run **Nginx** server on port **8080** of host machine in the background.|
|`docker container ls`|List all the running containers.|
|`docker container stop <container-id>`|Stop contaner which have ID `<container-id>`.|
|`docker container ls -a`|Get all the containers in host machine *(include of **running**, **stopped**, or **exited**)*.|
|`docker container run --publish 80:80 --detach --name webhost nginx`|Run **Nginx** server and named it `webhost` on port 80 of host machine.|
|`docker container logs webhost`|Show the logs of container `webhost`.|
|`docker container top webhost`|List all processes that are running inside container `webhost`.|
|`docker container --help`|Get all the **sub-commands** that docker support for the `command`, such as: `kill`, `logs`, etc...|
|`docker container rm <container-id 1> <container-id 2>`|Remove `<container-id 1>` and `<container-id 2>` out of the docker on host machine. **Note**: _you can not remove running containers_.|
|`docker container rm -f <container-id 1> <container-id 2>`|Remove `<container-id 1>` and `<container-id 2>` without regards to their status _(**running**, **stopped**, or **exited**)_ out of the docker on host machine|
### 2.1. Brief
* **Images** vs **Container**
* `run`/`stop`/`remove` containers.
* Check container logs and processes.

### 2.2. Notes
* **Important**: if using **Docker Toolbox**, type the IP Address `http://192.168.99.100`.
* Docker's default image **registry** is **Docker Hub** _[https://hub.docker.com](https://hub.docker.com)_.

<hr>

## 3. Debrief: What happens when we run a container
### 3.1. Notes:
* These steps will show you how a container is created and run.
  * Step 1: Looks for that image locally in image cache, does not find anything.
  * Step 2: Then looks in remote image repository _(Default to Docker Hub)_.
  * Step 3: Downloads the latest version of the image _(`nginx:latest vby defualt`)_.
  * Step 4: Creates new container based on that image and prepares to start.
  * Step 5: Gives it a virtual IP on a private network inside docker engine.
  * Step 6: Opens up port 80 on host and forwards to port 80 in container.
  * Step 7: Starts container by using the `CMD` in the image Dockerfile.

<hr>

## 4. Container VS. VM: It's just a process
|Commands|Description|
|-|-|
|`docker run --name mongo -d mongo`|Run mongo db in container and then named it `mongo` in docker.|
|`docker top mongo`|Get all the running processes inside container `mongo`.|
|`docker stop mongo`|Stop the container `mongo`|
|`ps aux`|Get all the running processes on your host machine.|
|`ps aux \| grep mongo`|Get all the running processes that contain keyword **mongo** in their name.|

### 4.1. Notes
* Containers are not **Mini VMs**.
  * They are just processes running on your host OS.
  * Limited to what resources they can access.
  * Exit when process stops.

* For example for these above concepts:
  * Run mongoDB inside docker container.
    ```bash
    docker run --name mongo -d mongo
    ```
  * Run `top` command to check processes that are running in container `mongo`.
    ```bash
    docker top mongo
    ```
    * We will see the column `PID`, `PID` is just the process ID of the specific process that is running inside container `mongo`.
      ![](./img/sec04/01.png)

  * To stop the running container `mongo`, use the command:
    ```bash
    docker stop mongo
    ```
  * Run `ps aux` command to check processes that are running on your host machine.
    ![](./img/sec04/02.png)
      
  * Use `ps aux | grep mongo` to get the process that contains `mongo` in its name.
    ![](./img/sec04/03.png)

  * To start the stopped container `mongo`, use the command:
    ```bash
    docker start mongo
    ```

<hr>

## 5. Assignment: Manage Multiple Containers

|Commands|Description|
|-|-|
|`docker container run -d -p 3306:3306 --name db -e MYSQL_RANDOM_ROOT_PASSWORD=yes mysql`|Run **MySQL** service inside docker container|
|`docker container logs db 2>&1 | grep GENERATED`|Get generated password of container `db`.|
|`docker container run -d --name webserver -p 8080:80 httpd`|Run `httpd` as docker container.|
|`docker container run -d --name proxy -p 80:80 nginx`|Run `nginx` as container.|
### 5.1. Notes:
* Run a **Nginx** server on port **80:80**.
* Run a **MySQL** on port **3306:3306**.
* Run a **HTTPD** server on port **8080:80**.
* Run all of them with the **detached** mode.
* Run all of them with the **name** mode.
* When running mysql, use `--env` option (or `-e`) to pass `MYSQL_RANDOM_ROOT_PASSWORD=yes` to the container.

### 5.2. Answers:
* Run mysql container:
  ```bash
  docker container run -d -p 3306:3306 --name db -e MYSQL_RANDOM_ROOT_PASSWORD=yes mysql
  ```
* Use this command below to see the password of mysql:
  ```bash
  docker container logs db 2>&1 | grep GENERATED
  ```
  ![](./img/sec04/04.png)
* Run `httpd` container as container.
  ```bash
  docker container run -d --name webserver -p 8080:80 httpd
  ```

* Run `nginx` as container.
  ```bash
  docker container run -d --name proxy -p 80:80 nginx
  ```

* Check all the above containers are running.
  ```bash
  docker container ls
  ```
  ![](./img/sec04/05.png)

* Using `curl localhost` to check `nginx` is running.
  ```bash
  curl localhost
  ```
  ![](./img/sec04/06.png)
  
  ```bash
  curl localhost:8080
  ```
  ![](./img/sec04/07.png)

* Stop the all above running containers.
  ```bash
  docker container stop db webserver proxy
  ```
  ![](./img/sec04/08.png)

* And then remove them
  ```bash
  docker container rm db webserver proxy
  ```
  ![](./img/sec04/09.png)

## 6. What's Going On in Containers: CLI process monitoring
|Commands|Description|
|-|-|
|`docker container top <container>`|Get all the process list in one container|
|`docker container inspect <container>`|Get details of one container configuration|
|`docker container stats [<container>]`|Get real-time performance stats of all/specific container(s)|

### 6.1. Notes:
* Run **Nginx** as container.
  ```bash
  docker container run -d --name nginx nginx
  ```

* Run **MySQL** as container.
  ```bash
  docker container run -d --name mysql -e MYSQL_RANDOM_ROOT_PASSWORD=yes mysql
  ```

* Get all the process list in container `mysql`.
  ```bash
  docker container top mysql
  ```
  ![](./img/sec04/10.png)

* Get details of container `mysql`.
  ```bash
  docker container inspect mysql
  ```
  ![](./img/sec04/11.png)

* Monitor the all containers.
  ```bash
  docker container stats
  ```
  ![](./img/sec04/12.png)

## 7. Getting a shell inside containers: No Need for SSH
|Commands|Description|
|-|-|
|`docker container run -it`|Start new container **interactively**|
|`docker container exec -it`|Run additional command in existing container|
|`docker container start -ai proxy`|Start again a stopped container and then open bash shell|

### 7.1. Notes:
* Run **Nginx** as container and then open **bash shell**.
  ```bash
  docker container run -it --name proxy nginx bash
  ```
  ![](./img/sec04/13.png)

* To start again a stopped container and then open **bash shell**.
  ```bash
  docker container start -ai proxy
  ```
  ![](./img/sec04/14.png)

* To interact with shell of a running container, for example `mysql` container.
  ```bash
  docker container exec -it mysql bash
  ```
  ![](./img/sec04/15.png)

* Distribution of linux:
  * Alpine: very small, less than 5MB.

## 8. Docker Networks: Concepts for Privte and Public Comms in Containers
|Commands|Description|
|-|-|
|`docker container port webhost`|Get port of the container `webhost`|
|`docker container inspect --format '{{ .NetworkSettings.IPAddress }}' webhost`|Get the IPAddress of container `webhost`.|

### 8.1. Notes:
* Docker networks defaults:
  * Each container connected to a private virtual network **bridge**.
  * Each virtual network routes through NAT firewall on host IP.
  * All containers on a virtual network can talk to each other without `-p`.
  * Best practice is to create a new virtual network for each app:
    * Network `my_web_app` for **MySQL** and **PHP/Apache** containers.
    * Network `my_api` for **Mongo** and **NodeJS** containers.
  * "Batteries included, but removable"
    * Defaults work well in many, but easy to swap out parts to customize it.
  * Make new virtual networks.
  * Attach containers to more then one virtual network (or none).
  * Skip virtual networks and use **host IP** (--net=host).
  * Use different Docker networks driver to gain new abilities.
  * For local dev/testing, networks usually **"just work"**.

* Run `nginx` container.
  ```bash
  docker container run -p 80:80 --name webhost -d nginx
  ```

* Get the port of `nginx` container.
  ```bash
  docker container port webhost
  ```
  ![](./img/sec04/16.png)

* Get the IP Address con container **webhost**.
  ```bash
  docker container inspect --format '{{ .NetworkSettings.IPAddress }}' webhost
  ```
  ![](./img/sec04/17.png)

* How virtual networks work in containers
  ![](./img/sec04/18.png)

## 9. Docker Networks: CLI Management of Virtual Networks
|Commands|Description|
|-|-|
|`docker network ls`|List all the virtual networks|
|`docker network inspect <network>`|Get details of one virtual network|
|`docker network create --driver <driver> <network>`|Create a new virtual network depending on speficic `--driver`|
|`docker network connect <network> <container>`|Connect a container to a virtual network|
|`docker network disconnect <network> <container>`|Disconnect a container from a virtual network|

### 9.1. Notes:
* List all the virtual networks.
  ```bash
  docker network ls
  ```
  ![](./img/sec04/19.png)

  * Kinds of virtual networks:
    * `bridge`: default virtual network which is **NAT**'ed behind the Host IP.
    * `host`: it gains performance by skipping virtual networks and attaching the container to the host interface but sacrifices security of container model.
    * `none`: it removes eth0 and only leaves you with localhost interface in the container.
* **Network driver** is built in or 3rd party extensions that give you virtual network features.
* Create your apps so fronend/backend sit on **same Docker network** because they inter-communication never leaves the host.
* All externally exposed ports closed by default.
* You must manually expose via `-p`, which is better default security.
* Later on, we will discuss about Swarm and Overlay networks.
* Get details of virtual network `bridge`.
  ```bash
  docker network inspect bridge
  ```
  ![](./img/sec04/20.png)

* Create a new virtual network `my_app_net` depending on `bridge` driver.
  ```bash
  docker network create my_app_net
  ```
  ![](./img/sec04/21.png)

* Create a new `nginx:alphine` container using the `my_app_net` virtual network.
  ```bash
  docker container run -d --name new_nginx --network my_app_net nginx:alpine
  ```
  * Inspect the virtual network `my_app_net`.
    ```bash
    docker network inspect my_app_net
    ```
    ![](./img/sec04/22.png)

* Run `webhost` container and then connect it to the virtual network `my_app_net` as a **NIC**.
  ```bash
  docker container run -d --name webhost --network my_app_net nginx
  docker network connect my_app_net webhost
  docker network inspect my_app_net
  ```
  ![](./img/sec04/23.png)

* Inspect network config in container `webhost`
  ```bash
  docker container inspect webhost
  ```
  ![](./img/sec04/24.png)

* Disconnect container `webhost` from virtual network `my_app_net`.
  ```bash
  docker network disconnect my_app_net webhost
  docker network inspect my_app_net
  ```
  ![](./img/sec04/25.png)

## 10. Docket Networks: DNS and how containers find each other
### 10.1. Brief:
* Understand how DNS is the key to easy inter container comms.
* See how it works by default with custom networks.
* Learn how to use `--link` to enable DNS on default `bridge` network.

### 10.2. Notes:
* **Forget IP's**: static IP's and using IP's for talking to containers is an anti-pattern. You need to use **DNS** to avoit it.
* **Docker DNS** - docker daemon has a built-in DNS server that containers use by default.
* Docker defaults the **hostname** to the container's name, but you can also set aliases.
* For example. We have 2 running `nginx` containers `new_nginx` and `webhost` in virtual network `my_app_net`.
  ![](./img/sec04/26.png)

* Now, let create a new `nginx` container and then attach it to the virtual network `my_app_net`.
  ```bash
  docker container run -d --name my_nginx --network my_app_net nginx:alpine
  ```

* Inspect the virtual network `my_app_net`. We have 2 running `nginx` containers that are `new_nginx` and `my_nginx`.
  ```bash
  docker network inspect my_app_net
  ```
  ![](./img/sec04/27.png)

* Now, we can `ping` signal from container `my_nginx` to container `new_nginx` by using the container's name.
  ```bash
  docker container exec -it my_nginx ping new_nginx
  ```
  ![](./img/sec04/28.png)
  ![](./img/sec04/29.png)

* **Note**: There is a big disadvantage of network `bridge` is that it does not support DNS by default. So, we need to use `--link` to enable DNS on default `bridge` network if you want to communicate between containers.

## 11. Assignment: Using containers for CLI testing
### 11.1. Assignment 1 - requirements:
* Use different Linux distro containers to check `curl` cli tool version.
* Use two different terminal windows to start bash in both `centos:7` and `ubuntu:14.04` using `-it`.
* Learn the `docker container --rm` option so you can save cleanup.
* Ensure `curl` is installed and on latest version for that distro:
  * `ubuntu`: `apt-get update && apt-get install curl`
  * `centos`: `yum update curl`
* Check `curl --version`.

### 11.2. Assignment 1 - solution:
* Run `centos:7` container and then start bash in it.
  ```bash
  docker container run -it --rm centos:7 bash
  # inside container
  yum update curl
  curl --version
  ```

* Run `ubuntu:14.04` container and then start bash in it.
  ```bash
  docker container run -it --rm ubuntu:14.04 bash
  # inside container
  apt-get update && apt-get install curl
  curl --version
  ```

## 12. Assignment: DNS round robin test
### 12.1. Assignment 2 - requirements:
* Create a new virtual network (defualt bridge driver).
* Create two containers from `elasticsearch:2` image.
* Research and use `--network-alias search` when creating them to give them an additional DNS name to respond to.
* Run `alpine nslookup search` with `--net` to see the two containers list for the same DNS name.
* Run `centos curl -s search:9200` with `--net` multiple times until you see both "name" fields show.

### 12.2. Assignment 2 - solution
* Create a new virtual network (defualt bridge driver).
  ```bash
  docker network create dude
  ```

* Run 2 `elasticsearch` containers with the same alias.
  ```bash
  docker container run -d --net dude --net-alias search elasticsearch:2
  docker container run -d --net dude --net-alias search elasticsearch:2
  ```

* Run `nslookup` with `--net dude` to see the two containers list for the same DNS name. If the result is like the picture below, your action is correct until now
  ```bash
  docker container run --rm --net dude alpine /bin/sh

  # inside the above container
  apk update
  apk add bind-tools
  nslookup search
  ```
  ![](./img/sec04/30.png)

* Then, using `curl` to get initial data from elasticsearch, like this:
  ```bash
  docker container run --rm --net dude alpine /bin/sh

  # inside the above container
  apk update
  apk add curl
  curl -s search:9200
  curl -s search:9200
  ```
  ![](./img/sec04/31.png)

* Because of running 2 `elasticsearch` containers on the same network `dude`, so every you run `curl -s search:9200` you will get the result like this:
  ![](./img/sec04/32.png)
  * The field `cluster_uuid` is generated for each container, so it is different. So if you have $n$ `elasticsearch` container, you will get $n$ different `cluster_uuid` field.
  * Depending on the `cluster_uuid` field, you can know which container providing the specific responses.

# Section 5. Containers Images, Where to find them and how to build them
**Brief**:
* All about images, the building blocks of containers.
* What is in an image (and what isn;'t)
* Using Docker hub registry.
* Managing our local image cache.
* Building our own images.
## 1. What's In an image (and What isn't)
* App binaries and dependencies.
* Metadata about the image data and how to run the image.
* Official definition: "An image is an ordered collection of root filesystem changes and the corresponding execution parameters for use within a container runtime."
* Not a complete OS. No kernel, kernel modules (e.g drivers)
* Small as one file (your app binary) like a golang static binary.
* Big as a Ubuntu distro with apt, and Apache, PHP, and more installed.

## 2. The Mighty Hub: using Docker Hub registry images
### 2.1. Brief:
* Basics of docker hub
* Find official and other good public images
* Donwload images and basics of images tags

## 3. Images and Their layers: Discover the Image Cache
### 3.1. Brief:
* Image layers
* Union file system
* `history` and `inspect` commands.
* Copy on write concept.

### 3.2. Notes
* Get all the downloaded images.
  ```bash
  docker image ls
  ```

* Get the history of image `nginx`. This command wil show layers of changes made in image.
  ```bash
  docker image history nginx
  ```
  ![](./img/sec05/01.png)


* To get detailed information about an image, use inspect command.
  ```bash
  docker image inspect nginx
  ``` 

* Finally, **images**:
  * Are made up of file system changes and metadata.
  * Each layer is uniquely identified and only stored once on a host.
  * This saves storage space on host and transfer time on push/pull.
  * A container is just a single read/write layer on top of image.
  * `docker image history` and `insect` commands can teach us how the image was built.

## 4. Image Tagging and Pushing to Docker Hub
### 4.1. Brief:
* Know what container and images are in docker.
* Understand image layer basics.
* Understand Docker Hub basics.
* All anout image tags.
* How to upload to Docker Hub.
* Image ID vs. Tag.

### 4.2. Notes
* Login to your Docker Hub account.
  ```bash
  docker login
  ```
* **More info**: using `docker logout` to log out current account.
* Retag the official `nginx` image into your own image.
  ```bash
  docker image tag nginx manhcuong8499/nginx
  ```

* Upload image to docker hub with tag `latest`.
  ```bash
  docker image push manhcuong8499/nginx
  ```
* **More info**: the docker config file is at this path `~/.docker/config.json`
  ![](./img/sec05/02.png)

* Customize your image tag and then push it to Docker hub
  ![](./img/sec05/03.png)

* Go to Docker Hub to see your image with its variants.
  ![](./img/sec05/04.png)

* You also change the visibility of the image inside the tab **Settings** like the way of Github.
  ![](./img/sec05/05.png)

## 5. Building images: The Dockerfiles Basics
* To build an image from docker file, use the command.
  ```bash
  docker build -f <docker file>
  ```
  * The `-f` flag is used to specify the path to the docker file.

* The instructions:
  * `FROM`: the base image.
  * `ENV`: set environment variables. For example:
    ```dockerfile
    ENV token 1234456
    ```
  * `RUN`: run shell script
  * `EXPOSE`: expose port
  * `CMD`: run specific commands when the container is started.

## 6. Building images: Running Docker Builds
* Build image from this [Dockerfile](./resources/udemy-docker-mastery-main/dockerfile-sample-1/Dockerfile)
  ```bash
  cd resources/udemy-docker-mastery-main/dockerfile-sample-1/
  docker image build -t customnginx .
  ```

## 7. Building Images: Extending Official Images
* In this section, we will be given 2 files, including a dockerfile and an index.html file. Let use the docker to build your own image.
* The source code for this section was stored in directory [dockerfile-sample-2](./resources/udemy-docker-mastery-main/dockerfile-sample-2/)
* **Note**: In this dockerfile, we do not specify the `CMD` instruction, because of is in the base image (it means `FROM` instruction), it included a `CMD` instruction before, so we need not specify it again.
  ```bash
  cd ./resources/udemy-docker-mastery-main/dockerfile-sample-2/
  docker image build -t nginx-with-html .
  ```
* Tagging the above-generated image with a new tag.

## 8. Assignment: Build your own Dockerfile and Run Containers From it
* Dockerfiles are part process workflow and part art
* Take existing Node.js app and Dockerize it.
* Make dockerfile built it, test it and then push it to Docker Hub, finnaly run it.
* Expect this to be iterative, rarely do I get it right the first time.
* Details in [this directory](./resources/udemy-docker-mastery-main/dockerfile-assignment-1/).
* Use the Alpine version of the official `node` 6.x image.
* Expected result is web site at `http://localhost`
* Tag and push to your docker hub account free.
* Remove your image from local cache, run again from hub.

### 8.1. Solution
* Firstly, I need to build this Dockerfile into my own image.
  ```bash
  docker image build -t testnode .
  ```

* After the above phase is done successfully, I run the below commands to run it as a container.
  ```bash
  docker container run --rm -p 80:3000 testnode
  ```
  ![](./img/sec05/06.png)

* This is your result when visiting [http://localhost](http://localhost).
  ![](./img/sec05/07.gif)

* Now tag for the `testnode` image.
  ```bash
  docker image tag testnode manhcuong8499/testing-node
  ```

* Finally, push it to Docker Hub.
  ```bash
  docker image push manhcuong8499/testing-node
  ```

* Check if this image exists on Docker Hub.
  ![](./img/sec05/08.png)

* Now remove this image from local cache.
  ```bash
  docker image rm manhcuong8499/testing-node
  ```

* Now run the `manhcuong8499/testing-node` again which pulls this image from Docker Hub.
  ```
  docker container run --rm -p 80:3000 manhcuong8499/testing-node
  ```
  ![](./img/sec05/09.png)

* Check if everything is working well on your browser.
  ![](./img/sec05/10.png)

## 9. Using `prune` to keep your Docker system clean
* `docker image prune` to clean up just **dangling** images.
* `docker system prune` to clean up everything.
* The big one is usually `docker image prune -a` which will remove all images you**'re not using**. Use `docker system df` to see space usage.