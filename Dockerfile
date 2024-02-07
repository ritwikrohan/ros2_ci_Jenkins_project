FROM ros:galactic

ENV DEBIAN_FRONTEND=noninteractive
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN apt-get update && apt-get install -y \
  git \
  ros-galactic-joint-state-publisher \
  ros-galactic-robot-state-publisher \
  ros-galactic-cartographer \
  ros-galactic-cartographer-ros \
  ros-galactic-gazebo-plugins \
  ros-galactic-teleop-twist-keyboard \
  ros-galactic-teleop-twist-joy \
  ros-galactic-xacro ros-galactic-nav2* \
  ros-galactic-urdf \
  ros-galactic-v4l2-camera \
  python3-dev \
  --no-install-recommends \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Make the prompt a little nicer
RUN echo "PS1='${debian_chroot:+($debian_chroot)}\u@:\w\$ '" >> /etc/bash.bashrc 

RUN mkdir -p /ros2_ws/src

RUN git clone -b ros2-galactic --recursive https://github.com/rigbetellabs/tortoisebot.git /ros2_ws/src/tortoisebot
RUN rm -rf /ros2_ws/src/tortoisebot/tortoisebot_control
WORKDIR /ros2_ws

RUN rosdep update
RUN rosdep install --from-paths src --ignore-src -r -y



RUN echo "source /opt/ros/$ROS_DISTRO/setup.bash" >> /etc/bash.bashrc

COPY ./tortoisebot_waypoints /ros2_ws/src/tortoisebot/tortoisebot_waypoints
COPY mybringup.launch.py /ros2_ws/src/tortoisebot/tortoisebot_bringup/launch/

RUN /bin/bash -c 'source /opt/ros/$ROS_DISTRO/setup.bash && colcon build 2>&1 > /ros2_ws/build.log && exit 0'

RUN echo "source /ros2_ws/install/setup.bash" >> /etc/bash.bashrc

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD /bin/bash -c "source /ros2_ws/install/setup.bash; ros2 launch tortoisebot_bringup mybringup.launch.py use_sim_time:=True"