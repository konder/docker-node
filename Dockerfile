FROM centos

RUN yum update -y
RUN yum install -y tar curl
RUN yum install -y git

# verify gpg and sha256: http://nodejs.org/dist/v0.10.31/SHASUMS256.txt.asc
# gpg: aka "Timothy J Fontaine (Work) <tj.fontaine@joyent.com>"
# gpg: aka "Julien Gilli <jgilli@fastmail.fm>"
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys 7937DFD2AB06298B2293C3187D33FF9D0246406D 114F43EE0176B71C7BC219DD50A3051F888C628D

ENV NODE_VERSION 0.10.36
ENV NPM_VERSION 2.5.0

RUN curl -SLO "http://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" \
	&& curl -SLO "http://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
	&& gpg --verify SHASUMS256.txt.asc \
	&& grep " node-v$NODE_VERSION-linux-x64.tar.gz\$" SHASUMS256.txt.asc | sha256sum -c - \
	&& tar -xzf "node-v$NODE_VERSION-linux-x64.tar.gz" -C /usr/local --strip-components=1 \
	&& rm "node-v$NODE_VERSION-linux-x64.tar.gz" SHASUMS256.txt.asc \
	&& npm install -g npm@"$NPM_VERSION" \
	&& npm install -g cnpm --registry=https://registry.npm.taobao.org \
	&& npm install -g grunt-cli \
	&& npm cache clear

RUN npm install -g nodemon
RUN npm install -g forever

RUN yum install -y git gcc gcc-c++ make rubygems && \
    gem install sass && \
    npm install -g bower
    

RUN echo 'LANG="en_US.UTF-8"' > /etc/sysconfig/i18n
RUN echo 'LC_ALL="en_US.UTF-8"' >> /etc/sysconfig/i18n
RUN source /etc/sysconfig/i18n
