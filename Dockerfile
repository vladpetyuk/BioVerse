
# parent Docker
FROM rocker/verse:latest


# this part from old verse image (3.3.2)
# aparently it contained some LaTeX related packages that went missing in later versions
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    ## for building pdfs via pandoc/LaTeX (These are large!)
    lmodern \
    texlive-fonts-recommended \
    texlive-generic-recommended \
    texlive-humanities \
    texlive-latex-extra \
    texlive-science \
    texinfo \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/ \
  && cd /usr/share/texlive/texmf-dist/tex/latex \
  ## additional tex files needed for certain rticles templates
  && wget http://mirrors.ctan.org/macros/latex/contrib/ametsoc.zip \
  && unzip ametsoc.zip \
  && rm *.zip \
## R manuals use inconsolata font, but texlive-fonts-extra is huge, so:
  && cd /usr/share/texlive/texmf-dist \
  && wget http://mirrors.ctan.org/install/fonts/inconsolata.tds.zip \
  && unzip inconsolata.tds.zip \
  && rm *.zip \
  && echo "Map zi4.map" >> /usr/share/texlive/texmf-dist/web2c/updmap.cfg \
  && mktexlsr \
  && updmap-sys \
  ## Currently (2017-06-06) need devel PKI for ssl issue: https://github.com/s-u/PKI/issues/19
  && install2.r -r http://rforge.net PKI \
  ## And some nice R packages for publishing-related stuff
  && install2.r --error --deps TRUE \
    bookdown rticles



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
