# The *LSDTopoTools* OpenCV container

![](https://raw.githubusercontent.com/LSDtopotools/lsdtt_viz_docker/master/images/LSD-logo.png)

This docker container allows you to run the LSDTopoTools command line tools for valley extraction. It has the OpenCV dependency installed.
It also allows you to run all the other [LSDTopoTools command line tools](https://github.com/LSDtopotools/LSDTopoTools2). 

## Instructions

These instructions tell you how to download the valley extraction tools and run them in a Docker environment.

### Installing Docker

These are the bare bones instructions. For a bit more detail and potential bug fixes, scroll down to the section on [Docker notes](#docker-notes).

1. Download and install [Docker Desktop for Windows](https://hub.docker.com/editions/community/docker-ce-desktop-windows) (only works with Windows 10+), [Docker Desktop for Mac](https://hub.docker.com/editions/community/docker-ce-desktop-mac), or Docker for [Ubuntu](https://hub.docker.com/editions/community/docker-ce-server-ubuntu) or [Debian](https://hub.docker.com/editions/community/docker-ce-server-debian).
  * If you are installing Docker Desktop for Windows you should use the WSL 2 Backend. WSL 2 has been supported on Windows since around 2020. More details are on the [Docker for Windows documentation](https://docs.docker.com/desktop/windows/install/). 
  * On MacOS we recommend installing docker using brew: `brew cask install docker`
  * On MacOS and Linux, after you install docker you will need to add permissions: `sudo usermod -a -G docker $USER`
2. We will henceforth assume that you actually have a functioning version of Docker on your host machine. If you want more details about how to use Docker, or getting it set up (particularly in Windows, in Linux and MacOS this is more straightforward), see our [Docker notes](#docker-notes).

### Running the container

#### Part 1: set up an LSDTopoTools directory on your host machine

1. You will want to be able to see *LSDTopoTools* output on your host operating system, so you will need to create a directory for hosting your *LSDTopoTools* data, code, and scripts.
2. For the purposes of this tutorial, we will assume you are using Windows and that you have made a directory `C:\LSDTopoTools`.
  * You can put this directory anywhere you want as long as you remember where it is. You don't need to put anything in this directory yet.

#### Part 2: start the docker container

_Preamble_: Once you have downloaded docker, you can control how much memory you give the docker containers. The default is 3Gb. If you have even moderate sized DEM data, this will not be enough. You can go into the docker settings (varies by operating system, use a search engine to figure out where they are) and increase the memory.

There are 2 options for getting the docker container so that you can run the valley extraction tools.

#### Option 1: download the docker container from DockerHub

The first (preferred) option is to simply download and run the docker container that we have already built. To do this, just run the following command in a terminal (MacOS or Linux) or Powershell window (Windows):

Windows:

```console
docker run -it -v C:\LSDTopoTools:/LSDTopoTools lsdtopotools/lsdtt_opencv_docker
```
Linux:

```console
docker run -it -v /LSDTopoTools:/LSDTopoTools lsdtopotools/lsdtt_opencv_docker
```
  1. The `-it` means "interactive".
  2. The `-v` stands for "volume" and in practice it links the files in the docker container with files in your host operating system.
  3. After the `-v` you need to tell docker where the directories are on both the host operating system (in this case `C:\LSDTopoTools`) and the container (in this case `/LSDTopoTools`). These are separated by a colon (`:`).

Once you do this you will get a `#` symbol showing that you are inside the container. You can now do *LSDTopoTools* stuff.

#### Option 2: build the container on your local machine (most users should use option 1)

1. First of all, clone this GitHub repository onto your local machine. Create a new directory on your machine where you want to store the files. Navigate to the directory you just created and run:

```console
git clone https://github.com/LSDtopotools/lsdtt_opencv_docker
```
2. Now build the docker container using the Dockerfile. Navigate to the new directory:

```console
cd lsdtt_opencv_docker
```
and then build the docker file. NOTE: this will take a long time (an hour or so).

```console
docker build -t lsdtt_opencv_docker .
```
3. Now you need to run the container:
```console
$ docker run -it -v C:\LSDTopoTools:/LSDTopoTools lsdtt_opencv_docker
```

#### Running command line tools

1. Command line tools are ready for use immediately. Try this:

```console
# lsdtt-valley-metrics -h
```

You will get a screen saying you need a parameter file, and it will also tell you that some help files have been generated. If you look in your current directory there will be an .html file called *lsdtt-valley-metrics-README.html* that has instructions on how to run the command line tool.  

2. To run the valley extraction methods, you need to have a DEM in ENVI bil format and a suitable parameter file in your `C:\LSDTopoTools` directory. Let's assume your parameter file is called `LSDTT_valleys.param`. We would run the valley metrics algorithm by navigating to the `LSDTopoTools` where the DEM is stored in docker and then run:

```console
lsdtt-valley-metrics LSDTT_valleys.param
```

#### A minimally functioning parameter file

Here is an example parameter file that will extract a valley width with the minimum amount of settings:

```
# File information
read fname: My_DEM

# Parameters for preprocessing
# Parameters that will change on the basis of DEM grid spacing. 
# window radius should be ~3x DEM grid spacing
# threshold pixels should be ~100 for 30m DEM and a few thousand for 2m DEM
surface_fitting_window_radius: 90
threshold_contributing_pixels: 100

# Some steps to visualise outputs
write_hillshade: true
print_channels_to_csv: true
remove_seas: true

# Parameters for floodplain extraction
use_absolute_thresholds: true
relief_threshold: 10
slope_threshold: 0.05
threshold_SO: 4
fill_floodplain: true

# Parameters to get the valley centreline
channel_source_fname: coords.csv
get_valley_centreline: false
convert_csv_to_geojson: true
centreline_loops: 5
trough_scaling_factor: 0.5
extract_single_channel: true

# Parameters for valley widths
# These will depend on grid resolution.
# the bank search radius will depend on the valley width. It should be around half the width of the valley. 
get_valley_widths: true
width_node_spacing: 50
valley_banks_search_radius: 50
```

Some things to note:

1. This file will need to be in the same directory as your DEM that is in *ENVI bil* format. 
2. The read fname line near the top needs to have the prefix of your DEM. So if your DEM is composed of files `Tay.bil` and `Tay.hdr` then this line needs to read `read fname: Tay`. The `read fname` is case sensitive. 
3. You navigate to this directory in your docker shell and call `lsdtt-valley-metrics` from there. 
4. You will, in this directory, also need a csv file called `coords.csv` with the `latitude,longitude` in the first row and the lat-long coordinates of the starting point of your channel in the second row. 


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

This section used to be very complicated, with many tips and tricks and gotchas. But Docker Desktop for Windows is much more streamlined now and you should just follow the instructions on the [Docker for Windows installation website](https://docs.docker.com/desktop/windows/install/)

