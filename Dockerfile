FROM debian
MAINTAINER christian@cshaheen.tech

# Sets timezone to UTC by default
ENV TZ=UTC
ARG DEBIAN_FRONTEND=noninteractive

# Install Cron, Docker, wget, curl, and TZDate
RUN apt-get -y update
RUN apt-get -y install cron wget curl docker.io tzdata python3 python3-pip rsync dnsutils openssl
RUN pip3 install pyopenssl ruamel_yaml requests qbittorrent-api --break-system-packages

# Install Proxmox Backup Client
RUN echo "deb http://download.proxmox.com/debian/pbs-client bookworm main" > /etc/apt/sources.list.d/pbs-client.list
RUN wget https://enterprise.proxmox.com/debian/proxmox-release-bookworm.gpg -O /etc/apt/trusted.gpg.d/proxmox-release-bookworm.gpg
RUN apt-get -y update
RUN apt-get -y install proxmox-backup-client

# Cleanup
RUN apt-get -y autoremove && apt-get clean && rm -rf /var/lib/apt/lists/*

# Make log file
RUN touch /var/log/cron.log

# In order, on start of the container:
# 1. Loads file into Crontab
# 2. Creates symlink from timezone to localtime
# 3. Reconfiures tzdata with the new timezone
# 4. Start cron
# 5. Tails the output of the cron log for docker logs to display later
CMD crontab /etc/cron.d/* && ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && dpkg-reconfigure --frontend noninteractive tzdata && cron && tail -f /var/log/cron.log
