Installing nginx on Ubuntu 18.04 starts from:
```console
ubuntu@ip-172-31-36-253:~$ w
 07:19:38 up 17:32,  1 user,  load average: 0.01, 0.01, 0.00
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
ubuntu   pts/0    193.107.177.76   07:19    1.00s  0.04s  0.00s w
ubuntu@ip-172-31-36-253:~$ sudo su
root@ip-172-31-36-253:/home/ubuntu# sudo apt update
Hit:1 http://us-east-2.ec2.archive.ubuntu.com/ubuntu bionic InReleas
...
root@ip-172-31-36-253:/home/ubuntu# sudo apt install nginx
root@ip-172-31-36-253:/home/ubuntu# ufw app list
Available applications:
  Nginx Full
  Nginx HTTP
  Nginx HTTPS
  OpenSSH
root@ip-172-31-36-253:/home/ubuntu# ufw allow 'Nginx HTTP'
Rules updated
Rules updated (v6)
root@ip-172-31-36-253:/home/ubuntu# ufw status
Status: inactive

root@ip-172-31-36-253:/home/ubuntu# systemctl status nginx
● nginx.service - A high performance web server and a reverse proxy server
   Loaded: loaded (/lib/systemd/system/nginx.service; enabled; vendor preset: enabled)
   Active: active (running) since Sat 2021-08-21 07:28:53 UTC; 1min 16s ago
     Docs: man:nginx(8)
  Process: 890 ExecStart=/usr/sbin/nginx -g daemon on; master_process on; (code=exited, status=0/SUCCESS)
  Process: 848 ExecStartPre=/usr/sbin/nginx -t -q -g daemon on; master_process on; (code=exited, status=0/SUCCESS)
 Main PID: 895 (nginx)
    Tasks: 2 (limit: 1140)
   CGroup: /system.slice/nginx.service
           ├─895 nginx: master process /usr/sbin/nginx -g daemon on; master_process on;
           └─896 nginx: worker process

Aug 21 07:28:53 ip-172-31-36-253 systemd[1]: Starting A high performance web server and a reverse proxy server...
Aug 21 07:28:53 ip-172-31-36-253 systemd[1]: nginx.service: Failed to parse PID from file /run/nginx.pid: Invalid argument
Aug 21 07:28:53 ip-172-31-36-253 systemd[1]: Started A high performance web server and a reverse proxy server.
root@ip-172-31-36-253:/home/ubuntu# curl -4 icanhazip.com
3.139.96.65
```
Check the ip 3.139.96.65, put it inot the browser, we should have default web_page
```console
mkdir -p /var/www/testsite.com
root@ip-172-31-36-253:/home/ubuntu# ls -al /var/www/
html/         testsite.com/
root@ip-172-31-36-253:/home/ubuntu# chown -R $USER:$USER /var/www/testsite.com/html/
root@ip-172-31-36-253:/home/ubuntu# chmod -R 755 /var/www/testsite.com/
root@ip-172-31-36-253:/home/ubuntu# vim /var/www/testsite.com/html/index.html
root@ip-172-31-36-253:/home/ubuntu# ln -s /etc/nginx/sites-available/
default       testsite.com
root@ip-172-31-36-253:/home/ubuntu# ln -s /etc/nginx/sites-available/testsite.com /etc/nginx/sites-enabled/
root@ip-172-31-36-253:/home/ubuntu# nginx -t
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
root@ip-172-31-36-253:/home/ubuntu# systemctl restart nginx
root@ip-172-31-36-253:/home/ubuntu#
root@ip-172-31-36-253:/home/ubuntu# vim /etc/nginx/sites-available/testsite.com
server {
        listen 80;
        listen [::]:80;

        root /var/www/testsite.com/html;
        index index.html index.htm index.nginx-debian.html;

        server_name testsite.com www.testsite.com;

        location / {
                try_files $uri $uri/ =404;
        }
}
```
Installing PostgreSQL
```console
root@ip-172-31-36-253:/home/ubuntu# apt update
Hit:1 http://us-east-2.ec2.archive.ubuntu.com/ubuntu bionic InRelease
Get:2 http://us-east-2.ec2.archive.ubuntu.com/ubuntu bionic-updates InRelease [88.7 kB]
Get:3 http://us-east-2.ec2.archive.ubuntu.com/ubuntu bionic-backports InRelease [74.6 kB]
Get:4 http://security.ubuntu.com/ubuntu bionic-security InRelease [88.7 kB]
Fetched 252 kB in 0s (703 kB/s)
Reading package lists... Done
Building dependency tree
Reading state information... Done
32 packages can be upgraded. Run 'apt list --upgradable' to see them.
root@ip-172-31-36-253:/home/ubuntu# apt install postgresql postgresql-contrib
...
root@ip-172-31-36-253:/home/ubuntu# sudo -i -u postgres
postgres@ip-172-31-36-253:~$ psql
psql (10.18 (Ubuntu 10.18-0ubuntu0.18.04.1))
Type "help" for help.

postgres=# \q
postgres@ip-172-31-36-253:~$ psql -d postgres
psql (10.18 (Ubuntu 10.18-0ubuntu0.18.04.1))
Type "help" for help.

postgres=# \conninfo
You are connected to database "postgres" as user "postgres" via socket in "/var/run/postgresql" at port "5432".
root@ip-172-31-36-253:/home/ubuntu# sudo -u postgres psql
psql (10.18 (Ubuntu 10.18-0ubuntu0.18.04.1))
Type "help" for help.

postgres=# CREATE DATABASE 50cent;
ERROR:  syntax error at or near "50"
LINE 1: CREATE DATABASE 50cent;
                        ^
postgres=# CREATE DATABASE fiftycent;
CREATE DATABASE
postgres=# CREATE USER fiftycent WITH ENCRYPTED PASSWORD 'yourpass';
CREATE ROLE
postgres=# GRANT ALL PRIVILEGES ON DATABASE fiftycent TO fiftycent;
GRANT
postgres=# \q
root@ip-172-31-36-253:/home/ubuntu# sudo -u fiftycent psql
sudo: unknown user: fiftycent
sudo: unable to initialize policy plugin
root@ip-172-31-36-253:/home/ubuntu# adduser fiftycent
Adding user `fiftycent' ...
Adding new group `fiftycent' (1002) ...
Adding new user `fiftycent' (1002) with group `fiftycent' ...
Creating home directory `/home/fiftycent' ...
Copying files from `/etc/skel' ...
Enter new UNIX password:
Retype new UNIX password:
passwd: password updated successfully
Changing the user information for fiftycent
Enter the new value, or press ENTER for the default
	Full Name []:
	Room Number []:
	Work Phone []:
	Home Phone []:
	Other []:
Is the information correct? [Y/n] Y
root@ip-172-31-36-253:/home/ubuntu# sudo -u fiftycent psql
psql (10.18 (Ubuntu 10.18-0ubuntu0.18.04.1))
Type "help" for help.

fiftycent=> \conninfo
You are connected to database "fiftycent" as user "fiftycent" via socket in "/var/run/postgresql" at port "5432"
```
Installing nginx with Docker
```console
root@ip-172-31-36-253:/home/ubuntu/python-docker# docker run -d --name "test-nginx" -p 8080:80 -v $(pwd):/usr/share/nginx/html:ro nginx:latest
Unable to find image 'nginx:latest' locally
latest: Pulling from library/nginx
e1acddbe380c: Already exists
e21006f71c6f: Pull complete
f3341cc17e58: Pull complete
2a53fa598ee2: Pull complete
12455f71a9b5: Pull complete
b86f2ba62d17: Pull complete
Digest: sha256:4d4d96ac750af48c6a551d757c1cbfc071692309b491b70b2b8976e102dd3fef
Status: Downloaded newer image for nginx:latest
b709ed53f3a96addc699f9a7912776d7e77c80af65e21384840b6e455ba837a1
root@ip-172-31-36-253:/home/ubuntu/python-docker# docker inspect test-nginx
[
    {
        "Id": "b709ed53f3a96addc699f9a7912776d7e77c80af65e21384840b6e455ba837a1",
        "Created": "2021-08-21T10:33:05.187803063Z",
        "Path": "/docker-entrypoint.sh",
        "Args": [
            "nginx",
            "-g",
            "daemon off;"
        ],
        "State": {
            "Status": "running",
            "Running": true,
            "Paused": false,
            "Restarting": false,
            "OOMKilled": false,
            "Dead": false,
            "Pid": 15844,
            "ExitCode": 0,
            "Error": "",
            "StartedAt": "2021-08-21T10:33:05.668462367Z",
            "FinishedAt": "0001-01-01T00:00:00Z"
        },
        "Image": "sha256:dd34e67e3371dc2d1328790c3157ee42dfcae74afffd86b297459ed87a98c0fb",
        "ResolvConfPath": "/var/lib/docker/containers/b709ed53f3a96addc699f9a7912776d7e77c80af65e21384840b6e455ba837a1/resolv.conf",
        "HostnamePath": "/var/lib/docker/containers/b709ed53f3a96addc699f9a7912776d7e77c80af65e21384840b6e455ba837a1/hostname",
        "HostsPath": "/var/lib/docker/containers/b709ed53f3a96addc699f9a7912776d7e77c80af65e21384840b6e455ba837a1/hosts",
        "LogPath": "/var/lib/docker/containers/b709ed53f3a96addc699f9a7912776d7e77c80af65e21384840b6e455ba837a1/b709ed53f3a96addc699f9a7912776d7e77c80af65e21384840b6e455ba837a1-json.log",
        "Name": "/test-nginx",
        "RestartCount": 0,
        "Driver": "overlay2",
        "Platform": "linux",
        "MountLabel": "",
        "ProcessLabel": "",
        "AppArmorProfile": "docker-default",
        "ExecIDs": null,
        "HostConfig": {
            "Binds": [
                "/home/ubuntu/python-docker:/usr/share/nginx/html:ro"
            ],
            "ContainerIDFile": "",
            "LogConfig": {
                "Type": "json-file",
                "Config": {}
            },
            "NetworkMode": "default",
            "PortBindings": {
                "80/tcp": [
                    {
                        "HostIp": "",
                        "HostPort": "8080"
                    }
                ]
            },
            "RestartPolicy": {
                "Name": "no",
                "MaximumRetryCount": 0
            },
            "AutoRemove": false,
            "VolumeDriver": "",
            "VolumesFrom": null,
            "CapAdd": null,
            "CapDrop": null,
            "CgroupnsMode": "host",
            "Dns": [],
            "DnsOptions": [],
            "DnsSearch": [],
            "ExtraHosts": null,
            "GroupAdd": null,
            "IpcMode": "private",
            "Cgroup": "",
            "Links": null,
            "OomScoreAdj": 0,
            "PidMode": "",
            "Privileged": false,
            "PublishAllPorts": false,
            "ReadonlyRootfs": false,
            "SecurityOpt": null,
            "UTSMode": "",
            "UsernsMode": "",
            "ShmSize": 67108864,
            "Runtime": "runc",
            "ConsoleSize": [
                0,
                0
            ],
            "Isolation": "",
            "CpuShares": 0,
            "Memory": 0,
            "NanoCpus": 0,
            "CgroupParent": "",
            "BlkioWeight": 0,
            "BlkioWeightDevice": [],
            "BlkioDeviceReadBps": null,
            "BlkioDeviceWriteBps": null,
            "BlkioDeviceReadIOps": null,
            "BlkioDeviceWriteIOps": null,
            "CpuPeriod": 0,
            "CpuQuota": 0,
            "CpuRealtimePeriod": 0,
            "CpuRealtimeRuntime": 0,
            "CpusetCpus": "",
            "CpusetMems": "",
            "Devices": [],
            "DeviceCgroupRules": null,
            "DeviceRequests": null,
            "KernelMemory": 0,
            "KernelMemoryTCP": 0,
            "MemoryReservation": 0,
            "MemorySwap": 0,
            "MemorySwappiness": null,
            "OomKillDisable": false,
            "PidsLimit": null,
            "Ulimits": null,
            "CpuCount": 0,
            "CpuPercent": 0,
            "IOMaximumIOps": 0,
            "IOMaximumBandwidth": 0,
            "MaskedPaths": [
                "/proc/asound",
                "/proc/acpi",
                "/proc/kcore",
                "/proc/keys",
                "/proc/latency_stats",
                "/proc/timer_list",
                "/proc/timer_stats",
                "/proc/sched_debug",
                "/proc/scsi",
                "/sys/firmware"
            ],
            "ReadonlyPaths": [
                "/proc/bus",
                "/proc/fs",
                "/proc/irq",
                "/proc/sys",
                "/proc/sysrq-trigger"
            ]
        },
        "GraphDriver": {
            "Data": {
                "LowerDir": "/var/lib/docker/overlay2/74f3a11e9960d594e5ccc7e434b1b3f1aa15f17c84752518b36dc7b8229ac4ea-init/diff:/var/lib/docker/overlay2/3831da7a8d58fbe72d5febdc62cb819e5664e1bae34a5d0ec70d2036ff0c21c8/diff:/var/lib/docker/overlay2/d0793847d6dd9d8ea9e401986a91dab689184b286ae7bd641348d00a2bc6cac6/diff:/var/lib/docker/overlay2/6cfdf9e76d4f80a9b679697a48b0513c3bc1783f76ba02ae406e7378f175288f/diff:/var/lib/docker/overlay2/8f99b537dd540cd15b47b9e8523ac23a9d9be0d08ca82c6bc54cf83ad15285e5/diff:/var/lib/docker/overlay2/44bdcd9f62d016a3226ce8724225a0bcb6f85e9a01129bcfa5fdcf8dbd63d5f2/diff:/var/lib/docker/overlay2/fa67a68fe30e605c88640d12cdafaa344347d36d423ed54540c463e72694c9ed/diff",
                "MergedDir": "/var/lib/docker/overlay2/74f3a11e9960d594e5ccc7e434b1b3f1aa15f17c84752518b36dc7b8229ac4ea/merged",
                "UpperDir": "/var/lib/docker/overlay2/74f3a11e9960d594e5ccc7e434b1b3f1aa15f17c84752518b36dc7b8229ac4ea/diff",
                "WorkDir": "/var/lib/docker/overlay2/74f3a11e9960d594e5ccc7e434b1b3f1aa15f17c84752518b36dc7b8229ac4ea/work"
            },
            "Name": "overlay2"
        },
        "Mounts": [
            {
                "Type": "bind",
                "Source": "/home/ubuntu/python-docker",
                "Destination": "/usr/share/nginx/html",
                "Mode": "ro",
                "RW": false,
                "Propagation": "rprivate"
            }
        ],
        "Config": {
            "Hostname": "b709ed53f3a9",
            "Domainname": "",
            "User": "",
            "AttachStdin": false,
            "AttachStdout": false,
            "AttachStderr": false,
            "ExposedPorts": {
                "80/tcp": {}
            },
            "Tty": false,
            "OpenStdin": false,
            "StdinOnce": false,
            "Env": [
                "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
                "NGINX_VERSION=1.21.1",
                "NJS_VERSION=0.6.1",
                "PKG_RELEASE=1~buster"
            ],
            "Cmd": [
                "nginx",
                "-g",
                "daemon off;"
            ],
            "Image": "nginx:latest",
            "Volumes": null,
            "WorkingDir": "",
            "Entrypoint": [
                "/docker-entrypoint.sh"
            ],
            "OnBuild": null,
            "Labels": {
                "maintainer": "NGINX Docker Maintainers <docker-maint@nginx.com>"
            },
            "StopSignal": "SIGQUIT"
        },
        "NetworkSettings": {
            "Bridge": "",
            "SandboxID": "89bac44fd8fe3dfe834cd9c8c9aaf3a68d79978abeaff769e0a6e85e77aa88da",
            "HairpinMode": false,
            "LinkLocalIPv6Address": "",
            "LinkLocalIPv6PrefixLen": 0,
            "Ports": {
                "80/tcp": [
                    {
                        "HostIp": "0.0.0.0",
                        "HostPort": "8080"
                    },
                    {
                        "HostIp": "::",
                        "HostPort": "8080"
                    }
                ]
            },
            "SandboxKey": "/var/run/docker/netns/89bac44fd8fe",
            "SecondaryIPAddresses": null,
            "SecondaryIPv6Addresses": null,
            "EndpointID": "a26afdc08287c3341381b9b964444e2f83bb7a5ca3d01f6ef01fa6a38bfea648",
            "Gateway": "172.17.0.1",
            "GlobalIPv6Address": "",
            "GlobalIPv6PrefixLen": 0,
            "IPAddress": "172.17.0.2",
            "IPPrefixLen": 16,
            "IPv6Gateway": "",
            "MacAddress": "02:42:ac:11:00:02",
            "Networks": {
                "bridge": {
                    "IPAMConfig": null,
                    "Links": null,
                    "Aliases": null,
                    "NetworkID": "593c3b21bb4066706c836ff71845d8dbcdb120dc8b14cedf46434ca08857c568",
                    "EndpointID": "a26afdc08287c3341381b9b964444e2f83bb7a5ca3d01f6ef01fa6a38bfea648",
                    "Gateway": "172.17.0.1",
                    "IPAddress": "172.17.0.2",
                    "IPPrefixLen": 16,
                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,
                    "MacAddress": "02:42:ac:11:00:02",
                    "DriverOpts": null
                }
            }
        }
    }
]

root@ip-172-31-36-253:/home/ubuntu/nginx-python# cat Dockerfile
FROM ubuntu:bionic
RUN apt-get update\
    && apt-get install --no-install-recommends --no-install-suggests -y curl\
    && rm -rf /var/lib/apt/lists/*\
ENV SITE_URL http://testingsite.com/
WORKDIR /data
VOLUME /data
CMD sh -c "curl -Lk $SITE_URL > /data/results"

root@ip-172-31-36-253:/home/ubuntu/nginx-python# docker build . -t test-curl
Sending build context to Docker daemon  2.048kB
Step 1/5 : FROM ubuntu:bionic
bionic: Pulling from library/ubuntu
feac53061382: Pull complete
Digest: sha256:7bd7a9ca99f868bf69c4b6212f64f2af8e243f97ba13abb3e641e03a7ceb59e8
Status: Downloaded newer image for ubuntu:bionic
 ---> 39a8cfeef173
Step 2/5 : RUN apt-get update    && apt-get install --no-install-recommends --no-install-suggests -y curl    && rm -rf /var/lib/apt/lists/*ENV SITE_URL http://testingsite.com/
 ---> Running in c16f8a2e5507
Get:1 http://security.ubuntu.com/ubuntu bionic-security InRelease [88.7 kB]
Get:2 http://security.ubuntu.com/ubuntu bionic-security/main amd64 Packages [2294 kB]
Get:3 http://archive.ubuntu.com/ubuntu bionic InRelease [242 kB]
Get:4 http://security.ubuntu.com/ubuntu bionic-security/multiverse amd64 Packages [26.7 kB]
Get:5 http://security.ubuntu.com/ubuntu bionic-security/restricted amd64 Packages [543 kB]
Get:6 http://security.ubuntu.com/ubuntu bionic-security/universe amd64 Packages [1424 kB]
Get:7 http://archive.ubuntu.com/ubuntu bionic-updates InRelease [88.7 kB]
Get:8 http://archive.ubuntu.com/ubuntu bionic-backports InRelease [74.6 kB]
Get:9 http://archive.ubuntu.com/ubuntu bionic/multiverse amd64 Packages [186 kB]
Get:10 http://archive.ubuntu.com/ubuntu bionic/restricted amd64 Packages [13.5 kB]
Get:11 http://archive.ubuntu.com/ubuntu bionic/universe amd64 Packages [11.3 MB]
Get:12 http://archive.ubuntu.com/ubuntu bionic/main amd64 Packages [1344 kB]
Get:13 http://archive.ubuntu.com/ubuntu bionic-updates/multiverse amd64 Packages [34.4 kB]
Get:14 http://archive.ubuntu.com/ubuntu bionic-updates/universe amd64 Packages [2199 kB]
Get:15 http://archive.ubuntu.com/ubuntu bionic-updates/restricted amd64 Packages [575 kB]
Get:16 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 Packages [2730 kB]
Get:17 http://archive.ubuntu.com/ubuntu bionic-backports/main amd64 Packages [11.3 kB]
Get:18 http://archive.ubuntu.com/ubuntu bionic-backports/universe amd64 Packages [11.4 kB]
Fetched 23.2 MB in 3s (6677 kB/s)
Reading package lists...
Reading package lists...
Building dependency tree...
Reading state information...
The following additional packages will be installed:
  libasn1-8-heimdal libcurl4 libgssapi-krb5-2 libgssapi3-heimdal
  libhcrypto4-heimdal libheimbase1-heimdal libheimntlm0-heimdal
  libhx509-5-heimdal libk5crypto3 libkeyutils1 libkrb5-26-heimdal libkrb5-3
  libkrb5support0 libldap-2.4-2 libldap-common libnghttp2-14 libpsl5
  libroken18-heimdal librtmp1 libsasl2-2 libsasl2-modules-db libsqlite3-0
  libssl1.1 libwind0-heimdal
Suggested packages:
  krb5-doc krb5-user
Recommended packages:
  ca-certificates krb5-locales publicsuffix libsasl2-modules
The following NEW packages will be installed:
  curl libasn1-8-heimdal libcurl4 libgssapi-krb5-2 libgssapi3-heimdal
  libhcrypto4-heimdal libheimbase1-heimdal libheimntlm0-heimdal
  libhx509-5-heimdal libk5crypto3 libkeyutils1 libkrb5-26-heimdal libkrb5-3
  libkrb5support0 libldap-2.4-2 libldap-common libnghttp2-14 libpsl5
  libroken18-heimdal librtmp1 libsasl2-2 libsasl2-modules-db libsqlite3-0
  libssl1.1 libwind0-heimdal
0 upgraded, 25 newly installed, 0 to remove and 2 not upgraded.
Need to get 3914 kB of archives.
After this operation, 12.5 MB of additional disk space will be used.
Get:1 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 libsqlite3-0 amd64 3.22.0-1ubuntu0.4 [499 kB]
Get:2 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 libssl1.1 amd64 1.1.1-1ubuntu2.1~18.04.10 [1301 kB]
Get:3 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 libkrb5support0 amd64 1.16-2ubuntu0.2 [30.8 kB]
Get:4 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 libk5crypto3 amd64 1.16-2ubuntu0.2 [85.5 kB]
Get:5 http://archive.ubuntu.com/ubuntu bionic/main amd64 libkeyutils1 amd64 1.5.9-9.2ubuntu2 [8720 B]
Get:6 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 libkrb5-3 amd64 1.16-2ubuntu0.2 [279 kB]
Get:7 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 libgssapi-krb5-2 amd64 1.16-2ubuntu0.2 [122 kB]
Get:8 http://archive.ubuntu.com/ubuntu bionic/main amd64 libpsl5 amd64 0.19.1-5build1 [41.8 kB]
Get:9 http://archive.ubuntu.com/ubuntu bionic/main amd64 libroken18-heimdal amd64 7.5.0+dfsg-1 [41.3 kB]
Get:10 http://archive.ubuntu.com/ubuntu bionic/main amd64 libasn1-8-heimdal amd64 7.5.0+dfsg-1 [175 kB]
Get:11 http://archive.ubuntu.com/ubuntu bionic/main amd64 libheimbase1-heimdal amd64 7.5.0+dfsg-1 [29.3 kB]
Get:12 http://archive.ubuntu.com/ubuntu bionic/main amd64 libhcrypto4-heimdal amd64 7.5.0+dfsg-1 [85.9 kB]
Get:13 http://archive.ubuntu.com/ubuntu bionic/main amd64 libwind0-heimdal amd64 7.5.0+dfsg-1 [47.8 kB]
Get:14 http://archive.ubuntu.com/ubuntu bionic/main amd64 libhx509-5-heimdal amd64 7.5.0+dfsg-1 [107 kB]
Get:15 http://archive.ubuntu.com/ubuntu bionic/main amd64 libkrb5-26-heimdal amd64 7.5.0+dfsg-1 [206 kB]
Get:16 http://archive.ubuntu.com/ubuntu bionic/main amd64 libheimntlm0-heimdal amd64 7.5.0+dfsg-1 [14.8 kB]
Get:17 http://archive.ubuntu.com/ubuntu bionic/main amd64 libgssapi3-heimdal amd64 7.5.0+dfsg-1 [96.5 kB]
Get:18 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 libsasl2-modules-db amd64 2.1.27~101-g0780600+dfsg-3ubuntu2.3 [15.0 kB]
Get:19 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 libsasl2-2 amd64 2.1.27~101-g0780600+dfsg-3ubuntu2.3 [49.2 kB]
Get:20 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 libldap-common all 2.4.45+dfsg-1ubuntu1.10 [15.8 kB]
Get:21 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 libldap-2.4-2 amd64 2.4.45+dfsg-1ubuntu1.10 [154 kB]
Get:22 http://archive.ubuntu.com/ubuntu bionic/main amd64 libnghttp2-14 amd64 1.30.0-1ubuntu1 [77.8 kB]
Get:23 http://archive.ubuntu.com/ubuntu bionic/main amd64 librtmp1 amd64 2.4+20151223.gitfa8646d.1-1 [54.2 kB]
Get:24 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 libcurl4 amd64 7.58.0-2ubuntu3.14 [219 kB]
Get:25 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 curl amd64 7.58.0-2ubuntu3.14 [159 kB]
debconf: delaying package configuration, since apt-utils is not installed
Fetched 3914 kB in 1s (3444 kB/s)
Selecting previously unselected package libsqlite3-0:amd64.
(Reading database ... 4051 files and directories currently installed.)
Preparing to unpack .../00-libsqlite3-0_3.22.0-1ubuntu0.4_amd64.deb ...
Unpacking libsqlite3-0:amd64 (3.22.0-1ubuntu0.4) ...
Selecting previously unselected package libssl1.1:amd64.
Preparing to unpack .../01-libssl1.1_1.1.1-1ubuntu2.1~18.04.10_amd64.deb ...
Unpacking libssl1.1:amd64 (1.1.1-1ubuntu2.1~18.04.10) ...
Selecting previously unselected package libkrb5support0:amd64.
Preparing to unpack .../02-libkrb5support0_1.16-2ubuntu0.2_amd64.deb ...
Unpacking libkrb5support0:amd64 (1.16-2ubuntu0.2) ...
Selecting previously unselected package libk5crypto3:amd64.
Preparing to unpack .../03-libk5crypto3_1.16-2ubuntu0.2_amd64.deb ...
Unpacking libk5crypto3:amd64 (1.16-2ubuntu0.2) ...
Selecting previously unselected package libkeyutils1:amd64.
Preparing to unpack .../04-libkeyutils1_1.5.9-9.2ubuntu2_amd64.deb ...
Unpacking libkeyutils1:amd64 (1.5.9-9.2ubuntu2) ...
Selecting previously unselected package libkrb5-3:amd64.
Preparing to unpack .../05-libkrb5-3_1.16-2ubuntu0.2_amd64.deb ...
Unpacking libkrb5-3:amd64 (1.16-2ubuntu0.2) ...
Selecting previously unselected package libgssapi-krb5-2:amd64.
Preparing to unpack .../06-libgssapi-krb5-2_1.16-2ubuntu0.2_amd64.deb ...
Unpacking libgssapi-krb5-2:amd64 (1.16-2ubuntu0.2) ...
Selecting previously unselected package libpsl5:amd64.
Preparing to unpack .../07-libpsl5_0.19.1-5build1_amd64.deb ...
Unpacking libpsl5:amd64 (0.19.1-5build1) ...
Selecting previously unselected package libroken18-heimdal:amd64.
Preparing to unpack .../08-libroken18-heimdal_7.5.0+dfsg-1_amd64.deb ...
Unpacking libroken18-heimdal:amd64 (7.5.0+dfsg-1) ...
Selecting previously unselected package libasn1-8-heimdal:amd64.
Preparing to unpack .../09-libasn1-8-heimdal_7.5.0+dfsg-1_amd64.deb ...
Unpacking libasn1-8-heimdal:amd64 (7.5.0+dfsg-1) ...
Selecting previously unselected package libheimbase1-heimdal:amd64.
Preparing to unpack .../10-libheimbase1-heimdal_7.5.0+dfsg-1_amd64.deb ...
Unpacking libheimbase1-heimdal:amd64 (7.5.0+dfsg-1) ...
Selecting previously unselected package libhcrypto4-heimdal:amd64.
Preparing to unpack .../11-libhcrypto4-heimdal_7.5.0+dfsg-1_amd64.deb ...
Unpacking libhcrypto4-heimdal:amd64 (7.5.0+dfsg-1) ...
Selecting previously unselected package libwind0-heimdal:amd64.
Preparing to unpack .../12-libwind0-heimdal_7.5.0+dfsg-1_amd64.deb ...
Unpacking libwind0-heimdal:amd64 (7.5.0+dfsg-1) ...
Selecting previously unselected package libhx509-5-heimdal:amd64.
Preparing to unpack .../13-libhx509-5-heimdal_7.5.0+dfsg-1_amd64.deb ...
Unpacking libhx509-5-heimdal:amd64 (7.5.0+dfsg-1) ...
Selecting previously unselected package libkrb5-26-heimdal:amd64.
Preparing to unpack .../14-libkrb5-26-heimdal_7.5.0+dfsg-1_amd64.deb ...
Unpacking libkrb5-26-heimdal:amd64 (7.5.0+dfsg-1) ...
Selecting previously unselected package libheimntlm0-heimdal:amd64.
Preparing to unpack .../15-libheimntlm0-heimdal_7.5.0+dfsg-1_amd64.deb ...
Unpacking libheimntlm0-heimdal:amd64 (7.5.0+dfsg-1) ...
Selecting previously unselected package libgssapi3-heimdal:amd64.
Preparing to unpack .../16-libgssapi3-heimdal_7.5.0+dfsg-1_amd64.deb ...
Unpacking libgssapi3-heimdal:amd64 (7.5.0+dfsg-1) ...
Selecting previously unselected package libsasl2-modules-db:amd64.
Preparing to unpack .../17-libsasl2-modules-db_2.1.27~101-g0780600+dfsg-3ubuntu2.3_amd64.deb ...
Unpacking libsasl2-modules-db:amd64 (2.1.27~101-g0780600+dfsg-3ubuntu2.3) ...
Selecting previously unselected package libsasl2-2:amd64.
Preparing to unpack .../18-libsasl2-2_2.1.27~101-g0780600+dfsg-3ubuntu2.3_amd64.deb ...
Unpacking libsasl2-2:amd64 (2.1.27~101-g0780600+dfsg-3ubuntu2.3) ...
Selecting previously unselected package libldap-common.
Preparing to unpack .../19-libldap-common_2.4.45+dfsg-1ubuntu1.10_all.deb ...
Unpacking libldap-common (2.4.45+dfsg-1ubuntu1.10) ...
Selecting previously unselected package libldap-2.4-2:amd64.
Preparing to unpack .../20-libldap-2.4-2_2.4.45+dfsg-1ubuntu1.10_amd64.deb ...
Unpacking libldap-2.4-2:amd64 (2.4.45+dfsg-1ubuntu1.10) ...
Selecting previously unselected package libnghttp2-14:amd64.
Preparing to unpack .../21-libnghttp2-14_1.30.0-1ubuntu1_amd64.deb ...
Unpacking libnghttp2-14:amd64 (1.30.0-1ubuntu1) ...
Selecting previously unselected package librtmp1:amd64.
Preparing to unpack .../22-librtmp1_2.4+20151223.gitfa8646d.1-1_amd64.deb ...
Unpacking librtmp1:amd64 (2.4+20151223.gitfa8646d.1-1) ...
Selecting previously unselected package libcurl4:amd64.
Preparing to unpack .../23-libcurl4_7.58.0-2ubuntu3.14_amd64.deb ...
Unpacking libcurl4:amd64 (7.58.0-2ubuntu3.14) ...
Selecting previously unselected package curl.
Preparing to unpack .../24-curl_7.58.0-2ubuntu3.14_amd64.deb ...
Unpacking curl (7.58.0-2ubuntu3.14) ...
Setting up libnghttp2-14:amd64 (1.30.0-1ubuntu1) ...
Setting up libldap-common (2.4.45+dfsg-1ubuntu1.10) ...
Setting up libpsl5:amd64 (0.19.1-5build1) ...
Setting up libsasl2-modules-db:amd64 (2.1.27~101-g0780600+dfsg-3ubuntu2.3) ...
Setting up libsasl2-2:amd64 (2.1.27~101-g0780600+dfsg-3ubuntu2.3) ...
Setting up libroken18-heimdal:amd64 (7.5.0+dfsg-1) ...
Setting up librtmp1:amd64 (2.4+20151223.gitfa8646d.1-1) ...
Setting up libkrb5support0:amd64 (1.16-2ubuntu0.2) ...
Setting up libssl1.1:amd64 (1.1.1-1ubuntu2.1~18.04.10) ...
debconf: unable to initialize frontend: Dialog
debconf: (TERM is not set, so the dialog frontend is not usable.)
debconf: falling back to frontend: Readline
debconf: unable to initialize frontend: Readline
debconf: (Can't locate Term/ReadLine.pm in @INC (you may need to install the Term::ReadLine module) (@INC contains: /etc/perl /usr/local/lib/x86_64-linux-gnu/perl/5.26.1 /usr/local/share/perl/5.26.1 /usr/lib/x86_64-linux-gnu/perl5/5.26 /usr/share/perl5 /usr/lib/x86_64-linux-gnu/perl/5.26 /usr/share/perl/5.26 /usr/local/lib/site_perl /usr/lib/x86_64-linux-gnu/perl-base) at /usr/share/perl5/Debconf/FrontEnd/Readline.pm line 7.)
debconf: falling back to frontend: Teletype
Setting up libheimbase1-heimdal:amd64 (7.5.0+dfsg-1) ...
Setting up libsqlite3-0:amd64 (3.22.0-1ubuntu0.4) ...
Setting up libkeyutils1:amd64 (1.5.9-9.2ubuntu2) ...
Setting up libk5crypto3:amd64 (1.16-2ubuntu0.2) ...
Setting up libwind0-heimdal:amd64 (7.5.0+dfsg-1) ...
Setting up libasn1-8-heimdal:amd64 (7.5.0+dfsg-1) ...
Setting up libhcrypto4-heimdal:amd64 (7.5.0+dfsg-1) ...
Setting up libhx509-5-heimdal:amd64 (7.5.0+dfsg-1) ...
Setting up libkrb5-3:amd64 (1.16-2ubuntu0.2) ...
Setting up libkrb5-26-heimdal:amd64 (7.5.0+dfsg-1) ...
Setting up libheimntlm0-heimdal:amd64 (7.5.0+dfsg-1) ...
Setting up libgssapi-krb5-2:amd64 (1.16-2ubuntu0.2) ...
Setting up libgssapi3-heimdal:amd64 (7.5.0+dfsg-1) ...
Setting up libldap-2.4-2:amd64 (2.4.45+dfsg-1ubuntu1.10) ...
Setting up libcurl4:amd64 (7.58.0-2ubuntu3.14) ...
Setting up curl (7.58.0-2ubuntu3.14) ...
Processing triggers for libc-bin (2.27-3ubuntu1.4) ...
Removing intermediate container c16f8a2e5507
 ---> 9e670c725ee0
Step 3/5 : WORKDIR /data
 ---> Running in 1da14da9a5da
Removing intermediate container 1da14da9a5da
 ---> 158472ef3fde
Step 4/5 : VOLUME /data
 ---> Running in 677dc77e02d5
Removing intermediate container 677dc77e02d5
 ---> 0bbc9882dc76
Step 5/5 : CMD sh -c "curl -Lk $SITE_URL > /data/results"
 ---> Running in be4f502cc4a1
Removing intermediate container be4f502cc4a1
 ---> 91199d062e2e
Successfully built 91199d062e2e
Successfully tagged test-curl:latest
root@ip-172-31-36-253:/home/ubuntu/nginx-python# docker images
REPOSITORY    TAG               IMAGE ID       CREATED              SIZE
test-curl     latest            91199d062e2e   About a minute ago   113MB
<none>        <none>            c2e45f11bb85   23 minutes ago       114MB
nginx         latest            dd34e67e3371   3 days ago           133MB
python        3.8-slim-buster   4594dc5e9028   4 days ago           114MB
ubuntu        latest            1318b700e415   3 weeks ago          72.8MB
ubuntu        bionic            39a8cfeef173   3 weeks ago          63.1MB
hello-world   latest            d1165f221234   5 months ago         13.3kB 

```
Installing simple python application
```console
root@ip-172-31-36-253:~/test# ls -al
total 20
drwxr-xr-x 2 root root 4096 Aug 21 11:14 .
drwx------ 7 root root 4096 Aug 21 11:14 ..
-rw-r--r-- 1 root root  185 Aug 21 11:12 Dockerfile
-rw-r--r-- 1 root root   26 Aug 21 11:14 a.py
-rw-r--r-- 1 root root   22 Aug 21 11:14 hello.py
root@ip-172-31-36-253:~/test# cat Dockerfile
FROM ubuntu
MAINTAINER Volodymyr Ostapchuk
RUN apt-get update
RUN apt-get install -y python
ADD hello.py /home/hello.py
ADD a.py /home/a.py
CMD ["/home/hello.py"]
ENTRYPOINT ["python"]
root@ip-172-31-36-253:~/test# cat
Dockerfile  a.py        hello.py
root@ip-172-31-36-253:~/test# cat a.py
print ("Overriden Hello")
root@ip-172-31-36-253:~/test# cat hello.py
print ("Hello World")
root@ip-172-31-36-253:~/test# docker build -t pythonimage .
[+] Building 11.5s (10/10) FINISHED
 => [internal] load build definition from Dockerfile                                                                                                                                                   0.0s
 => => transferring dockerfile: 32B                                                                                                                                                                    0.0s
 => [internal] load .dockerignore                                                                                                                                                                      0.0s
 => => transferring context: 2B                                                                                                                                                                        0.0s
 => [internal] load metadata for docker.io/library/ubuntu:latest                                                                                                                                       0.0s
 => [internal] load build context                                                                                                                                                                      0.1s
 => => transferring context: 116B                                                                                                                                                                      0.1s
 => CACHED [1/5] FROM docker.io/library/ubuntu                                                                                                                                                         0.0s
 => [2/5] RUN apt-get update                                                                                                                                                                           4.3s
 => [3/5] RUN apt-get install -y python                                                                                                                                                                6.4s
 => [4/5] ADD hello.py /home/hello.py                                                                                                                                                                  0.1s
 => [5/5] ADD a.py /home/a.py                                                                                                                                                                          0.0s
 => exporting to image                                                                                                                                                                                 0.6s
 => => exporting layers                                                                                                                                                                                0.6s
 => => writing image sha256:d3cd6d13ee11b841e2dc2eb3ad92ca4a8bd3e8b7ff5d79d190e2c209f1cd1ad7                                                                                                           0.0s
 => => naming to docker.io/library/pythonimage                                                                                                                                                         0.0s
root@ip-172-31-36-253:~/test# docker run --name test1 pythonimage
Hello World
