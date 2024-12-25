# Use the official Kali Linux image
FROM kalilinux/kali-rolling

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install required dependencies
RUN apt update && \
    apt install -y git python3 python3-venv python3-pip npm && \
    apt clean

# Clone the Caldera repository
WORKDIR /opt
RUN git clone https://github.com/mitre/caldera.git --recursive

# Navigate to the Caldera directory
WORKDIR /opt/caldera

# Set up a Python virtual environment
RUN python3 -m venv venv

# Activate the virtual environment and install Python dependencies
RUN /bin/bash -c "source venv/bin/activate && pip3 install -r requirements.txt"

# Add the Magma submodule
RUN git submodule add https://github.com/mitre/magma

# Install Magma's dependencies
WORKDIR /opt/caldera/plugins/magma
RUN npm install

# Return to the Caldera directory
WORKDIR /opt/caldera

# Expose necessary ports
EXPOSE 8888
# Default HTTPS port for web interface and agent beacons over HTTPS (requires SSL plugin to be enabled)
EXPOSE 8443
# TCP and UDP contact ports
EXPOSE 7010
EXPOSE 7011/udp
# Websocket contact port
EXPOSE 7012
# Default port to listen for DNS requests for DNS tunneling C2 channel
EXPOSE 8853
# Default port to listen for SSH tunneling requests
EXPOSE 8022
# Default FTP port for FTP C2 channel
EXPOSE 2222

# Command to start the Caldera server in insecure mode
CMD ["/bin/bash", "-c", "source venv/bin/activate && python3 server.py --insecure --build"]
