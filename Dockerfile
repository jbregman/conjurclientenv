#
# Conjur Client Env that can be used to launch images in AWS 
# using Vagrant with the AWS and Chef provisioners
# and interact with them using the CLI
#
# https://hub.docker.com/r/jbregman/conjurclientenv/
#

# Pull base image.
FROM ubuntu:14.04
RUN sudo apt-get -yqq update


#pre-requisites for aws-vagrant
# Found install instructions  https://github.com/mitchellh/vagrant-aws/issues/163
RUN sudo apt-get install build-essential libxslt-dev libxml2-dev zlib1g-dev ruby-dev vagrant -y
RUN sudo gem install ruby-debug19 -- --with-ruby-include=$rvm_path/src/ruby-1.9.2-head/

# Need wget to download
RUN sudo apt-get -yqq install wget

#Ubuntu has an old version of Vagrant, so get the latest with at this time is 1.8.1
RUN wget https://releases.hashicorp.com/vagrant/1.8.1/vagrant_1.8.1_x86_64.deb
RUN dpkg -i vagrant_1.8.1_x86_64.deb

# Download the ChefDK -> Required for the Vagrant Berksfile
RUN wget https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/14.04/x86_64/chefdk_0.10.0-1_amd64.deb
# Install it
RUN dpkg -i chefdk_0.10.0-1_amd64.deb
# Install vagrant-berkshelf
RUN vagrant plugin install vagrant-berkshelf

#And the omnibus package
RUN vagrant plugin install vagrant-omnibus

# And the AWS Plugin
# There is a bug in older versions of AWS Plugin
RUN vagrant plugin install vagrant-aws --plugin-version 0.5.0

#Using the AWS CLI to Create a Key Pair Just to Launch the Server
RUN apt-get install -yqq python 
RUN apt-get -yqq install python-pip
RUN pip install awscli

#Need this to get the files up to AWS
RUN sudo apt-get install -yqq rsync 

#Install the Conjur CLI
RUN wget https://s3.amazonaws.com/conjur-releases/omnibus/conjur_4.29.0-1_amd64.deb 
RUN dpkg -i conjur_4.29.0-1_amd64.deb 

RUN apt-get -yqq install git
