FROM ubuntu:18.04

LABEL maintainer="Sumanth Bade <sumo1998sumanth@gmail.com>"

# Install apt-utils along with other necessary packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends apt-utils && \
    apt-get install -y git openssh-server openjdk-8-jdk maven && \
    apt-get install -y openjdk-11-jre-headless && \
    apt-get -y autoremove && \
    apt-get clean

# Set up SSH server
RUN sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd && \
    mkdir -p /var/run/sshd

# Set password for jenkins user
RUN useradd -m -d /home/jenkins -s /bin/bash jenkins && \
    echo 'jenkins:password' | chpasswd

# Copy authorized keys
COPY .ssh/authorized_keys /home/jenkins/.ssh/authorized_keys

# Set permissions
RUN chown -R jenkins:jenkins /home/jenkins/.ssh/ && \
    chmod 600 /home/jenkins/.ssh/authorized_keys

# Standard SSH port
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
