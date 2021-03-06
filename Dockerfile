FROM continuumio/miniconda3
################################## JUPYTERLAB ##################################
SHELL ["/bin/bash", "-c"]

RUN conda create -n robostackenv python=3.8

# Make RUN commands use the new environment:
SHELL ["conda", "run", "-n", "robostackenv", "/bin/bash", "-c"]

# RUN conda activate robostackenv
# this adds the conda-forge channel to your persistent configuration in ~/.condarc
RUN conda config --add channels conda-forge
# and the robostack channel
RUN conda config --add channels robostack
# it's very much advised to use strict channel priority
RUN conda config --set channel_priority strict

RUN conda install -y jupyterlab-ros 
RUN conda install -y sidecar

EXPOSE 8888

###################################### ROS #####################################
ENV ROS_DISTRO=noetic
RUN conda install -y nodejs=12 jupyterlab ros-$ROS_DISTRO-ros-core ros-$ROS_DISTRO-rosauth ros-$ROS_DISTRO-rospy ros-$ROS_DISTRO-rosbridge-suite ros-$ROS_DISTRO-rosbag ros-$ROS_DISTRO-tf2-web-republisher
RUN conda install -y jupyter-ros

CMD ["conda", "run", "--no-capture-output", "-n", "robostackenv", "jupyter", "lab", "--allow-root", "--no-browser", "--ip=0.0.0.0", "--NotebookApp.token=''"]