FROM osrf/ros:melodic-desktop-full

RUN apt-get update && \
    #apt-get install -y --no-install-recommends ubuntu-desktop 
    apt-get install -y gnome-panel gnome-settings-daemon metacity nautilus gnome-terminal && \
    apt-get install -y tightvncserver && \
	apt-get install -y wget && \
	apt-get install -y tar && \
	apt-get install ros-melodic-catkin python-catkin-tools 

	
# Install Choregraphe Suite 2.5.5.5
RUN wget -P /opt/Softbank\ Robotics/ https://community-static.aldebaran.com/resources/2.5.10/Choregraphe/choregraphe-suite-2.5.10.7-linux64-setup.run
RUN chmod +x /opt/Softbank\ Robotics/choregraphe-suite-2.5.10.7-linux64-setup.run
RUN /opt/Softbank\ Robotics/choregraphe-suite-2.5.10.7-linux64-setup.run --mode unattended
RUN rm /opt/Softbank\ Robotics/choregraphe-suite-2.5.10.7-linux64-setup.run
RUN sudo mv /opt/Softbank\ Robotics/Choregraphe\ Suite\ 2.5/lib/libz.so.1 libz.so.1.old
RUN sudo ln -s /opt/Softbank\ Robotics/Choregraphe\ Suite\ 2.5/lib/x86_64-linux-gnu/libz.so.1

# Install pynaoqi 2.5.5.5 library
RUN wget -P /root/ https://community-static.aldebaran.com/resources/2.5.10/Python%20SDK/pynaoqi-python2.7-2.5.7.1-linux64.tar.gz
RUN tar -xvzf /root/pynaoqi-python2.7-2.5.7.1-linux64.tar.gz -C /root/
RUN rm /root/pynaoqi-python2.7-2.5.7.1-linux64.tar.gz
ENV PYTHONPATH /root/pynaoqi-python2.7-2.5.7.1-linux64/lib/python2.7/site-packages
ENV LD_LIBRARY_PATH /opt/Aldebaran/lib/

WORKDIR "/home/user/ws/src"
ADD pepper_pkg pepper_pkg/
ADD robot_motivation robot_motivation/

# Additional Dependencies (for rospy python3)
RUN sudo apt-get install -y python3-pip python3-yaml
RUN sudo pip3 install rospkg catkin_pkg

# Additional Dependencies (for mocap)
RUN apt-get update --fix-missing
RUN sudo apt-get install ros-melodic-mocap-optitrack/bionic

RUN sudo apt install nano
RUN pip3 install numpy
RUN pip3 install matplotlib
RUN sudo apt-get install -y python3-tk
RUN sudo apt install -y python-pip
RUN sudo apt-get install -y python-tk
RUN pip3 install dill
RUN pip3 install more-itertools

WORKDIR "/home/user/ws"
RUN ["chmod", "+x", "/opt/ros/melodic/setup.bash"]
RUN bash -c "source /opt/ros/melodic/setup.bash \
		&& catkin build -DCMAKE_BUILD_TYPE=Release \
		&& echo 'source /home/user/ws/devel/setup.bash' >> ~/.bashrc"
