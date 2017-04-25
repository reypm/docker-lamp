# Docker LAMP
---
## First steps: install Docker
- [Ubuntu](https://docs.docker.com/engine/installation/linux/ubuntu/)
- [Fedora](https://docs.docker.com/engine/installation/linux/fedora/)
- [Windows](https://docs.docker.com/docker-for-windows/install/)
- [MacOS](https://docs.docker.com/docker-for-mac/install/)

## Post-installation steps for Linux
### Manage Docker as a non-root user
The `docker` daemon binds to a Unix socket instead of a TCP port. By default that Unix socket is owned by the user `root` and other users can only access it using sudo. The docker daemon always runs as the root user. If you don’t want to use `sudo` when you use the docker command, create a Unix group called `docker` and add users to it. When the docker daemon starts, it makes the ownership of the Unix socket read/writable by the docker group. To create the docker group and add your user:

- Create the docker group.
```
$ sudo groupadd docker
```
- Add your user to the docker group.
```
$ sudo usermod -aG docker $USER
```
- Log out and log back in so that your group membership is re-evaluated (in some cases restart is needed).
- Verify that you can docker commands without `sudo`.
```
$ docker run hello-world
```

### Configure Docker to start on boot
Most current Linux distributions (RHEL, CentOS, Fedora, Ubuntu 16.04 and higher) use `systemd` to manage which services start when the system boots. Ubuntu 14.10 and below use `upstart`.

**systemd**
```
$ sudo systemctl enable docker
```

To disable this behavior, use disable instead.
```
$ sudo systemctl disable docker
```

**upstart**

Docker is automatically configured to start on boot using upstart. To disable this behavior, use the following command:
```
$ echo manual | sudo tee /etc/init/docker.override
```

**chkconfig**
```
$ sudo chkconfig docker on
```

## Install Docker Compose

- Docker for Mac and Windows will automatically install the latest version of Docker Engine for you. Alternatively, you can use the usual commands to install or upgrade Compose (see commands listed below).
- In Linux as `root` user run the following commands:
```
#curl -L https://github.com/docker/compose/releases/download/1.11.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose

#chmod +x /usr/local/bin/docker-compose
```
Last but not least gets familiar with Docker and Docker Compose (command line, options, docs). There is a great documentation about it in [this repository](https://github.com/veggiemonk/awesome-docker)

## Building the stack needed by this application

### Software included:

The stack ships with the following software and versions (notice version can be upgraded each time you  re-build your stack):

 - Ubuntu 16.04.1 LTS
 - PHP 7.1.x with the following modules enabled (among the ones from the CORE):
     - apcu
     - ftp
     - gd
     - intl
     - json
     - ldap
     - mbstring
     - mcrypt
     - mongodb
     - mysqli
     - mysqlnd
     - openssl
     - PDO
     - pdo_mysql
     - xdebug
 -  Apache/2.4.18 (Ubuntu)
 - MySQL 5.6
 - MongoDB (latest)
 - phpRedmin: tool for manage Redis Caching through a web browser
 - phpMyAdmin: tool for manage MySQL DB through a web browser

### Building and setting up the stack:

- Create a folder wherever you want (highly recommended to be in your home directory) and name it as you want: `mkdir -p <path_to_directory>/<folder_name>`. Example: `mkdir -p ~/repository`
- Change you path to the recent created directory: `cd <path_to_directory>/<folder_name>`. Example: `cd ~/repository`
- Clone the repository `musfiqhossain/docker-amp` by running the following command:
```
// Over HTTPS
git clone https://github.com/musfiqhossain/docker-amp.git

// Over SSH
git clone git@github.com:musfiqhossain/docker-amp.git
```
- Change into the project directory: `cd <path_to_directory>/<folder_name>/docker-amp`. Ex: `cd ~/repository/docker-amp`
- Checkout `z1_symfony` branch by running: `git checkout -b z1_symfony origin/z1_symfony`.
- Build the stack by running (this should be a one time running command):
```
docker-compose build \
    --force-rm \             // Always remove intermediate containers
    --no-cache               // Do not use cache when building the image
```
- Run the stack by running:
```
docker-compose up \
    -d                  // Detached mode: Run containers in the background,
                        // print new container names. 
```

> Note: You can merge the commands above by running:
> ```
> docker-compose up \
>   -d \                // Detached mode: Run containers in the background,
>                       // print new container names.
>   --build \           // Build images before starting containers
>   --force-recreate    // Recreate containers even if their configuration and
>                       // image haven't changed.
> ```

### Executing commands in the container

There is two ways for execute commands inside the container. From  host or from the container itself. Both are explained below.

#### Executing commands from the host

The host is the Operating System where your Docker containers are running: Ubuntu, CentOS, Fedora, Windows, etc. If you setup Docker and Docker Compose succesfully following the steps above then you should be good to go. Open a terminal and try to run the following command:
```
$ docker exec -it <container_name_or_id> <command_to_execute>
```

For example to run `composer install|update` on the container where PHP and Apache are running the command should be:
```
$ docker-compose -u www-data \      // Run the command as www-data user.
                                    // This helps to keep proper permissions
                                    // on new files

                 -it dockeramp_php_1 \      // Keep STDIN open even if not attached
                                            // Allocate a pseudo-TTY

                 composer update           // This command will be run under
                                           // /var/www/html/ which is the WORKDIR
                                           // for the container
```
We can also change the directory where `composer` commands gets executed by adding `-d` parameter. In this case the command will take effect on the directory we're specifying. Ex:
```
$ docker exec -u www-data -it dockeramp_php_1 composer update -d oneview_symfony
```

#### Executing commands from inside the container

First we need to `bash` in the container by running:
```
$ docker exec -it dockeramp_php_1 bash
```
The command above should take you inside the container but be careful since you're `root` and this mean all the commands you run from now on are being done as `root` user so you can reach permissions issues at some point.

When you're inside the container you can run any command as you do on any Linux system.
