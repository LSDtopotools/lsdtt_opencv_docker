# The *LSDTopoTools* lsdtopytools container

![](https://raw.githubusercontent.com/LSDtopotools/lsdtt_viz_docker/master/images/LSD-logo.png)

This docker container has all the components you need to run the full lsdtopotools stack.

* *LSDTopoTools* command line tools
* *lsdtopytools* for using LSDTopoTools interactively in python
* *lsdviztools* for various automated plotting routines used to make figures for publications (lower level plotting if you just want to see what the code has done is in lsdtopytools)

The package also includes a python geospatial stack:

* fiona, gdal, rasterio, geopandas, folium, gdal, cartopy, and shapely

It also allows some command line processing with GDAL. See some tips for using the GDAL command line tools here: https://lsdtopotools.github.io/LSDTT_documentation/LSDTT_introduction_to_geospatial_data.html#_gdal

## Instructions

### Installing Docker

These are the bare bones instructions. For a bit more detail and potential bug fixes, scroll down to the section on [Docker notes](#docker-notes).

1. Download and install [Docker for Windows](https://www.docker.com/docker-windows) (only works with Windows 10 enterprise), [Docker for Mac](https://www.docker.com/docker-mac), or Docker for [Ubuntu](https://www.docker.com/docker-ubuntu) or [Debian](https://www.docker.com/docker-debian).
  * If you have windows linux subsystem 2 you should install Docker for [Ubuntu](https://www.docker.com/docker-ubuntu) in your linux subsystem
  * On MacOS we recommend installing docker using brew: `brew cask install docker`
  * On MacOs and Linux, after you install docker you will need to add permissions: `sudo usermod -a -G docker $USER`
  * On Windows 10 you will need to alter a bunch of settings. See [DNSection][Docker notes]
2. We will henceforth assume that you actually have a functioning version of Docker on your host machine. If you want more details about how to use docker, or getting it set up (particularly in Windows, in Linux and MacOS this is more straightforward), see our [Docker notes](#docker-notes).

### Running the container

#### Part 1: set up an LSDTopoTools directory on your host machine

1. You will want to be able to see *LSDTopoTools* output on your host operating system, so we will need to create a directory for hosting your *LSDTopoTools* data, code, and scripts.
2. For the purposes of this tutorial, I will assume you are using windows and that you have made a directory `C:\LSDTopoTools`.
  * You can put this directory anywhere you want as long as you remember where it is. You don't need to put anything in this directory yet.

#### Part 2: Download and run the container

_Preamble_: Once you have downloaded docker, you can control how much memory you give the docker containers. The default is 3Gb. If you have even moderate sized DEM data, this will not be enough. You can go into the docker settings (varies by operating system, use a search engine to figure out where they are) and increase the memory.

1. To get the container, go into a terminal (MacOS or Linux) or Powershell window (Windows) that has docker enabled and run:
```console
$ docker pull lsdtopotools/lsdtt_pytools_docker
```
2. Now you need to run the container:
```console
$ docker run -it -v C:\LSDTopoTools:/LSDTopoTools lsdtopotools/lsdtt_pytools_docker
```
  1. The `-it` means "interactive".
  2. The `-v` stands for "volume" and in practice it links the files in the docker container with files in your host operating system.
  3. After the `-v` you need to tell docker where the directories are on both the host operating system (in this case `C:\LSDTopoTools`) and the container (in this case `/LSDTopoTools`). These are separated by a colon (`:`).
3. Once you do this you will get a `#` symbol showing that you are inside the container. You can now do *LSDTopoTools* stuff.



#### Running command line tools

1. Command line tools are ready for use immediately. Try `# lsdtt-basic-metrics`
2. To see what is possible, check out the following documentation:
  * Note: for the below instructions, you will need the example datasets. Grab these with `# sh Get_LSDTT_example_data.sh`
  * https://lsdtopotools.github.io/LSDTT_documentation/LSDTT_basic_usage.html
  * https://lsdtopotools.github.io/LSDTT_documentation/LSDTT_channel_extraction.html
  * https://lsdtopotools.github.io/LSDTT_documentation/LSDTT_chi_analysis.html

#### Running lsdviztools scripts. 

1. The lsdviztools package comes with some scripts. To see what they do use the `-h` flag. The scripts are:
  * `lsdtt_grabopentopographydata` for downloading DEMs, converting them to lsdtopotools format and simple hillshading
  * `lsdtt_plotbasicrasters` for lots of basic visualisation routines like draped plots swaths, channel profiles, etc
  * `lsdtt_plotchianalysis` for plotting chi profiles, see Mudd et al. 2014 JGR-ES https://doi.org/10.1002/2013JF002981
  * `lsdtt_plotconcavityanalysis` for plotting analysis of channel concavity index, see Mudd et al 2018 ESURF https://doi.org/10.5194/esurf-6-505-2018   

#### Running a jupyter notebook from this container

1. The lsdpytools container can also serve as a host for [jupyter notebooks](https://jupyter.org/)
2. You need to open your docker container with a port:

```console
# docker run -it -v C:\LSDTopoTools:/LSDTopoTools -p 8888:8888 lsdtopotools/lsdtt_pytools_docker
```

  * Note that you should update the `C:\LSDTopoTools` to reflect the directory structure on your locak machine.

3. Then, inside the container, start the notebook:

```console
# jupyter notebook --ip 0.0.0.0 --port 8888 --no-browser --allow-root
```

4. When you run this command, it will give you some html addresses. *These will not work from your host computer!!* But these addresses do show you a `token`: you can see it in the address after `token=`.
  1. Instead, go into a browser on your host computer and go to http://localhost:8888/
  2. Then, in the password box, insert the `token` that was shown in the docker container.
  3. Yay, you can now start working with notebooks, using all the fun geospatial stuff that is in this container!


## Docker notes

If you want to know all about Docker, make sure to read the [docker documentation](https://docs.docker.com/). A note of warning: Docker documentation is similar to documentation for the [turbo encabulator](https://www.youtube.com/watch?v=rLDgQg6bq7o). Below are some brief notes to help you with the essentials.

#### Docker quick reference
***
Here are some shortcuts if you just need a reminder of how docker works.

List all containers
```console
$ docker ps -a
```

List containers with size
```console
$ docker ps -as
```

Remove all unused containers
```console
$ docker system prune
```
***

#### Docker on Linux

After you install docker on Linux, you will need to add users to the docker permissions:

```console
$ sudo usermod -a -G docker $USER
```

Once you have done this you will need to log out and log back in again.


#### Docker for Windows

*NOTE with windows linux subsystem 2 you should install that, install ubuntu and then install docker for ubuntu on the subsystem.*

I have not made any scientific study of this but most *LSDTopoTools* users are on Windows operating systems.

Firstly, you need to have *Windows 10 Enterprise*. It will not work otherwise (well, that is [not exactly true](https://stefanscherer.github.io/yes-you-can-docker-on-windows-7/) but getting it to work on Windows 7 is a massive pain). If you don't have Windows 10 Enterprise but are on Windows you probably should use Vagrant; see [our vagrant documentation](https://lsdtopotools.github.io/LSDTT_documentation/LSDTT_installation.html#_installing_lsdtopotools_using_virtualbox_and_vagrant). If you do have Windows 10 enterprise then you can download and install Docker for Windows CE. After you install this you will need to restart your computer not once but twice: once after install and a second time to activate the hyper-V feature, which allows you to have 64 bit guest operating systems.

Second, if you have that and have it installed, you might also need to add yourself to the `docker-users` group. To do that, do this (instructions from here: https://github.com/docker/for-win/issues/868):

1. Logon to Windows as Administrator
2. Go to Windows Administrator Tools
3. Look for Windows Computer Management and click on it.
4. Or you can skip steps 1-3, right mouse clicking Computer Management, go to more, and select run as administrator and provide Administrator password.
5. Double click docker-users group and add your account as member.
6. Also add your account to Hyper-V Administrator. This was added when you installed docker for Windows.
7. Log off from Windows and log back on.
8. Click on Windows icon on bottom left and start Docker for Windows. This will start docker windows service.
9. Start Windows Powershell and type docker --version. It will show Docker version 17.09.1-ce, build 19e2cf6, or whatever version you have.

#### Notes on dockerhub (only for Simon)

These are notes for how to push the most recent container to dockerhub. This is required because Docker stopped automated builds. The notes are a reminder to Simon only. If you are not Simon you should only continue reading if you need something to help you fall asleep. 

1. Navigate to the repository and build the container locally with the appropriate tag:

```console
$ docker build -t lsdtopotools/lsdtt_pytools_docker .
```

2. Login to docker using `docker login`

3. Push the container to docker hub:

```console
$ docker push lsdtopotools/lsdtt_pytools_docker:latest
```

4. If you are working from home, you then need to wait a very, very long time. 
