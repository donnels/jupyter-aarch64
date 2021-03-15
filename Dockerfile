FROM debian:stable-slim as base-setup

# variable to use 
    ENV NB_USER rstudio
    ENV NB_UID 1000
    ENV HOME /home/rstudio

# prep user and homedir and install location
    RUN useradd -m ${NB_USER} -u ${NB_UID} \
        && usermod -a -G staff ${NB_USER} \
        && mkdir -p /usr/local/lib/R
# prep base software
    RUN apt-get update \
        && apt-get -y install \
            python3 python3-pip \
            locales \
            aptitude mc \
 		    ed less vim-tiny \
    		wget curl ca-certificates \
            libssl-dev libunwind-dev \
    		fonts-texgyre \
            r-base-core r-base-dev r-api-3.5 \
        && apt-get purge && apt-get clean && rm -rf /var/lib/apt/lists/*
    RUN python3 -m pip install --no-cache-dir \
            notebook==5.2 
    RUN chown -R ${NB_USER} /usr/local/lib/R 
# prep base locale to keep system sane 
    RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
	    && locale-gen en_US.utf8 \
	    && /usr/sbin/update-locale LANG=en_US.UTF-8
    ENV LC_ALL en_US.UTF-8
    ENV LANG en_US.UTF-8

    WORKDIR ${HOME}

FROM base-setup as base-setup-r
    USER ${NB_USER}

# Set up R Kernel for Jupyter
RUN R --quiet -e "install.packages(c('repr', 'IRdisplay', 'evaluate', 'crayon', 'pbdZMQ', 'devtools', 'uuid', 'digest'))"
RUN R --quiet -e "devtools::install_github('IRkernel/IRkernel')"
RUN R --quiet -e "IRkernel::installspec()"

FROM base-setup-r
# Additional packages for demo: 'TDA','TDAmapper','igraph'
    USER root
    RUN mkdir /var/lib/apt/lists/partial \
        && apt-get update \
        && apt-get -y install \
            libgmp-dev libmpfr-dev \
        && apt-get purge && apt-get clean && rm -rf /var/lib/apt/lists/*

    USER ${NB_USER}
    RUN R --quiet -e "install.packages(c('TDA','TDAmapper','igraph'))"

# Make sure the contents of our repo are in ${HOME}
    COPY . ${HOME}
    USER root
    RUN chown -R ${NB_UID}:${NB_UID} ${HOME}
    USER ${NB_USER}

# Run install.r if it exists
    RUN if [ -f install.r ]; then R --quiet -f install.r; fi