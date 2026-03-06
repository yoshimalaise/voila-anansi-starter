# Voilà Anansi Starter Template

This repository serves as a starter template to enable the rapid development of scientific applications based on jupypter notebooks.

## Folder structure:

- index.ipynb: The notebook file in which you can implement your application

- resources:
    - assets: this folder should contain static, read-only data for the application (assets/resources)

    - persisted: this folder should be left empty in the repo, your notebook can write data to this folder that will be persisted on the network drive

    - shared: this folder will only be used when configured in the OoD portal, it will be mounted to the shared folder than contains resources to be used across B-TXT applications.

- b_txt_templates: This folder contains the nbconvert and voila templates used to render the notebook as a web application. In most cases there should be no need to change anything in here.

- requirements.txt: this file will list all python dependencies to be installed and used by your code. If you don't know how to manage it manually, run `%pip freeze > requirements.txt` from a new python cell in your notebook to write all currently installed packages to the file.

- .dockerignore, Dockerfile, build_containers.sh: these file are used to build to software to be used on the server, in most cases you will not need to make any changes to these files.

## Preparing for Deploy

### local setup
Current instructions are written for Mac OS only, windows/linux instructions will be added in the future.

The steps described in the setup section only need to be completed once.

Make sure you have Docker and Brew installed on your system.

We will need to create a small local linux VM in order to run apptainer, we will use lima for this.

on MacOS the following command to install lima 

```shell
brew install lima
```

once lima is installed we can create the apptainer vm by running:

```shell
limactl start template://apptainer --cpus 4 --memory 8 --vm-type=vz --rosetta
```


### Building the application
Once the above setup has been completed the application can be build by running the `build_containers.sh` script. This script will create 3 files in the build directory:

- the container.tar file containing the docker container image
- the container.sif file containing a self-contained image file to be used by apptainer
- the auto_run.sh file that can be used to start the container in a Interactive Desktop session.

To use your application on Anansi, place the sif and sh file in a new directory on your $VSC_DATA drive, run the shell script and your application should open in kiosk mode.