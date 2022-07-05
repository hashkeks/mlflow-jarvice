### MLflow Dockerfile for JARVICE PushToCompute

#Based on Ubuntu 22.04 LTS
FROM ubuntu:jammy
LABEL maintainer="Cedric Casper"

ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /tmp 

# Update SERIAL_NUMBER to force rebuild of subsequent layers
#   (i.e. don't use cached layers)
ENV SERIAL_NUMBER 20171009.1713

# Update, upgrade and install prerequisites
RUN apt-get update && apt-get install -y \
	vim \
	ssh \
	sudo \
	curl \
	wget \
	python3 \
	pip \
	software-properties-common

# Install Nimbix Desktop
RUN apt-get -y update && \
  DEBIAN_FRONTEND=noninteractive apt-get -y install curl && \
  curl -H 'Cache-Control: no-cache' \
    https://raw.githubusercontent.com/nimbix/image-common/master/install-nimbix.sh \
    | bash

# Intall MLflow
RUN pip install mlflow[extras]

# Install Miniconda
# 	https://conda.io/projects/conda/en/latest/user-guide/install/macos.html#install-macos-silent
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh -O miniconda.sh && \
	bash miniconda.sh -b -p /home/nimbix/miniconda

# Clone the MLflow test directory
RUN git clone https://github.com/mlflow/mlflow /home/nimbix/mlflow

# Expose port 22 for local JARVICE emulation in docker
EXPOSE 22


