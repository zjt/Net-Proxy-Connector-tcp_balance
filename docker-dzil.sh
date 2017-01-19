#!/bin/bash

# allows for the use of Dist::Zilla (dzil)
# run inside a docker container
# so that prereque perl modules (or even perl itself)
# do not need to be installed on the host

# first construct a Dockerfile 
# that specifies all of the prereques needed to build this module
cat - > Dockerfile <<Dockerfile
FROM jmmills/dist-zilla
RUN cpanm -n Net::Proxy
RUN cpanm -n Dist::Zilla::Plugin::PodWeaver \
             Dist::Zilla::Plugin::Test::Compile \
             Dist::Zilla::Plugin::Test::Kwalitee \
             Dist::Zilla::Plugin::Test::Perl::Critic \
             Dist::Zilla::Plugin::MinimumPerl
Dockerfile

# build the docker image from the Dockerfile
docker build -t dzil-npctb .

# run the container from the built image
# - mount the current directory inside the container
# - pass into the container whatever was passed in to this script
# effectively this is running "dzil @args" inside the container
docker run -v $PWD:/project dzil-npctb $@

# clean up the temporary Dockerfile
rm Dockerfile

# see also: https://github.com/jmmills/docker-dist-zilla
