# Installing Docker on Raspberry Pi

Docker can easily be installed on Raspberry Pi. The official [Docker documentation](https://docs.docker.com/engine/install/debian/#install-using-the-repository) states that you need to download and execute a Docker _convenience script_. This is described in detail [here](https://docs.docker.com/engine/install/debian/#install-using-the-convenience-script).

So here are the steps to get Docker installed on Raspberry Pi:

```shell
# get the docker script
curl -fsSL https://get.docker.com -o get-docker.sh
# make it executable
chmod a+x get-docker.sh
# execute the script
./get-docker.sh
```
Note, that you will have to execute the above as `root`. 
If you don't want to use `root` everytime you use Docker, you might want to add your own user to the `docker` group:

```shell
sudo usermod -aG docker <your-user>
```
After that you will likely have to log off and on again to have the group changes applied.
## Uninstalling Docker Engine from Raspberry Pi

```shell
# Uninstall the Docker Engine, CLI, and Containerd packages
sudo apt-get purge docker-ce docker-ce-cli containerd.io

# Images, containers, volumes, or customized configuration files on your host are not automatically removed. 
# To delete all images, containers, and volumes:
sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd
```

## References
* [Docker documentation](https://docs.docker.com/engine/install/debian/#install-using-the-repository)
* [Docker Convenience Script](https://docs.docker.com/engine/install/debian/#install-using-the-convenience-script)