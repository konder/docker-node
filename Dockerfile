FROM centos

RUN yum update -y
RUN yum install -y tar curl wget
RUN yum install -y git

# verify gpg and sha256: http://nodejs.org/dist/v0.10.31/SHASUMS256.txt.asc
# gpg: aka "Timothy J Fontaine (Work) <tj.fontaine@joyent.com>"
# gpg: aka "Julien Gilli <jgilli@fastmail.fm>"
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys 7937DFD2AB06298B2293C3187D33FF9D0246406D 114F43EE0176B71C7BC219DD50A3051F888C628D

ENV NODE_VERSION 5.11.0
ENV NPM_VERSION 3.8.6

RUN wget "https://npm.taobao.org/mirrors/node/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" \
	&& wget "https://npm.taobao.org/mirrors/node/v$NODE_VERSION/SHASUMS256.txt.asc" \
	&& gpg --verify SHASUMS256.txt.asc \
	&& grep " node-v$NODE_VERSION-linux-x64.tar.gz\$" SHASUMS256.txt.asc | sha256sum -c - \
	&& tar -xzf "node-v$NODE_VERSION-linux-x64.tar.gz" -C /usr/local --strip-components=1 \
	&& rm "node-v$NODE_VERSION-linux-x64.tar.gz" SHASUMS256.txt.asc \
	&& npm install -g npm@"$NPM_VERSION" \
	&& npm install -g cnpm --registry=https://registry.npm.taobao.org \
	&& npm install -g grunt-cli \
	&& npm cache clear

RUN wget https://github.com/jwilder/dockerize/releases/download/v0.0.1/dockerize-linux-amd64-v0.0.1.tar.gz
RUN tar -C /usr/local/bin -xvzf dockerize-linux-amd64-v0.0.1.tar.gz

RUN yum install -y git gcc gcc-c++ make rubygems

RUN gem sources --add https://ruby.taobao.org/ --remove https://rubygems.org/

RUN gem install sass && \
    npm install -g bower --registry=https://registry.npm.taobao.org
    

RUN echo 'LANG="en_US.UTF-8"' > /etc/sysconfig/i18n
RUN echo 'LC_ALL="en_US.UTF-8"' >> /etc/sysconfig/i18n
RUN source /etc/sysconfig/i18n
