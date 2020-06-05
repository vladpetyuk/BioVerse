
# parent Docker
FROM rocker/verse:latest

# this is necessary for installing mzR and nloptr
RUN apt-get update \
 && apt-get install -y --no-install-recommends  \
    libnetcdf-dev \
    libnlopt-dev # NLopt library

# FreeTDS
RUN apt-get install -y --no-install-recommends \
 unixodbc unixodbc-dev freetds-dev freetds-bin tdsodbc

# CIFS for accessing files on Windows shares
RUN apt-get install -y --no-install-recommends \
  cifs-utils

# bumping up rstudio user to sudoer just in case
# RUN useradd -m rstudio --groups sudo # failed
RUN usermod -a -G sudo rstudio
