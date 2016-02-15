###################################################################
#   _____ _____ _   _ _____ ___  _____ ___________  _______   __  #
#  /  __ \  _  | \ | |_   _/ _ \/  __ \_   _| ___ \|  _  \ \ / /  #
#  | /  \/ | | |  \| | | |/ /_\ \ /  \/ | | | |_/ /| | | |\ V /   #
#  | |   | | | | . ` | | ||  _  | |     | | | ___ \| | | |/   \   #
#  | \__/\ \_/ / |\  | | || | | | \__/\ | | | |_/ /\ \_/ / /^\ \  #
#   \____/\___/\_| \_/ \_/\_| |_/\____/ \_/ \____/  \___/\/   \/  #
#                                                                 #
###################################################################

# Set the base image to Debian
FROM debian:7

# File Author / Maintainer
MAINTAINER Sebastian Knop <sk@i1box.de>

# Environment variables
ENV DL_DIR /root/install
ENV SRC_DIR /contactbox
ENV IOC_DIR /ioncube
ENV SH_DIR /scripts

# Update the repository sources list
RUN DEBIAN_FRONTEND=noninteractive apt-get -q update
RUN DEBIAN_FRONTEND=noninteractive apt-get -qy upgrade

# BEGIN INSTALLATION
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install apt-utils apache2 php5 php5-json php5-curl php-pear php5-ldap php5-mcrypt php5-mysql wget unzip
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install mysql-client mysql-server
RUN pear channel-update pear.php.net
RUN pear install --alldeps channel://pear.php.net/HTTP_OAuth-0.3.2
RUN mkdir $DL_DIR
RUN echo "wget --no-check-certificate -O $DL_DIR/ioncube.zip http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.zip" > $DL_DIR/download.sh
RUN chmod +x $DL_DIR/download.sh
RUN $DL_DIR/download.sh
RUN unzip $DL_DIR/ioncube.zip -d $DL_DIR; rm $DL_DIR/ioncube.zip
RUN touch /usr/bin/contactbox
RUN chmod +x /usr/bin/contactbox
# INSTALLATION END

# Expose defaults ports
EXPOSE 80 443 4765

# Start CMD
CMD ["/bin/bash", "/usr/bin/contactbox"]

