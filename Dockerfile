FROM ubuntu:latest
MAINTAINER christian@cshaheen.tech

# Sets timezone to UTC by default
ENV TZ=UTC
ARG DEBIAN_FRONTEND=noninteractive

# Install Cron, Docker, wget, curl, and TZDate
RUN apt-get -y update
RUN apt-get -y install cron wget curl docker.io tzdata python3 python3-pip rsync dnsutils
RUN pip3 install requests qbittorrent-api
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
