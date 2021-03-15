FROM debian:stable-slim as base-setup

ENV NB_USER rstudio
ENV NB_UID 1000
ENV HOME /home/rstudio

RUN apt-get update && \
    apt-get -y install python3-pip \
    r-base-core r-base-dev r-api-3.5 && \
    useradd -m ${NB_USER} -u ${NB_UID} && \
    mkdir -p /usr/local/lib/R && chown ${NB_USER} /usr/local/lib/R && \
    pip3 install --no-cache-dir notebook==5.2 && \
    apt-get purge && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR ${HOME}

FROM base-setup
USER ${NB_USER}

# Set up R Kernel for Jupyter
RUN R --quiet -e "install.packages(c('repr', 'IRdisplay', 'evaluate', 'crayon', 'pbdZMQ', 'devtools', 'uuid', 'digest'))"
RUN R --quiet -e "devtools::install_github('IRkernel/IRkernel')"
RUN R --quiet -e "IRkernel::installspec()"

# Additional packages for demo: 'TDA','TDAmapper','igraph'
USER root
RUN mkdir /var/lib/apt/lists/partial && \
    apt-get update && \
    apt-get -y install libgmp-dev libmpfr-dev && \
    apt-get purge && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
RUN echo "step2"
USER ${NB_USER}

RUN R --quiet -e "install.packages(c('TDA','TDAmapper','igraph'))"

# Make sure the contents of our repo are in ${HOME}
COPY . ${HOME}
USER root
RUN chown -R ${NB_UID}:${NB_UID} ${HOME}
USER ${NB_USER}

# Run install.r if it exists
RUN if [ -f install.r ]; then R --quiet -f install.r; fi