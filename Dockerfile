# --------------------------------------------------------------------------
# This is a Dockerfile to build an Ubuntu 14.04 Docker image with
# pymssql and FreeTDS
#
# Use a command like:
#     docker build -t pymssql/pymssql .
# --------------------------------------------------------------------------


FROM phusion/baseimage:0.9.18
# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

MAINTAINER  Tim Birkett <tim@birkett-bros.com> (@pysysops)

# Install apt packages
RUN apt-get update && apt-get install -y \
    freetds-bin \
    freetds-common \
    freetds-dev \
    git \
    wget \
    bzip2 \
    ca-certificates \
    libglib2.0-0 \
    libxext6 \
    libsm6 \
    libxrender1 \
    pwgen \
    binutils \
    unixodbc \
    unixodbc-dev \
    libpq-dev \
    build-essential \
    python \
    python-pip \
    python-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN pip install Cython
RUN pip install ipython
RUN pip install SQLAlchemy
RUN pip install pandas
RUN pip install Alembic
RUN pip install psycopg2
RUN pip install pyodbc
RUN pip install luigi

# Luigi bits
RUN mkdir /etc/luigi
ADD logging.conf /etc/luigi/
ADD luigi.conf /etc/luigi/
VOLUME /etc/luigi

RUN mkdir -p /luigi/logs
VOLUME /luigi/logs

RUN mkdir -p /luigi/state
VOLUME /luigi/state

EXPOSE 8082

RUN mkdir /etc/service/luigid
COPY luigid.sh /etc/service/luigid/run

# Add source directory to Docker image
# Note that it's beneficial to put this as far down in the Dockerfile as
# possible to maximize the chances of being able to use image caching
ADD . /opt/src/pymssql/

RUN pip install /opt/src/pymssql
