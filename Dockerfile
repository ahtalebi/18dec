FROM rocker/r-ver:4.1.2

RUN apt-get update && apt-get install -y \
    libglpk-dev \
    libxml2-dev \
    libcairo2-dev \
    libgit2-dev \
    default-libmysqlclient-dev \
    libpq-dev \
    libsasl2-dev \
    libsqlite3-dev \
    libssh2-1-dev \
    libxtst6 \
    libcurl4-openssl-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev \
    libxt-dev \
    unixodbc-dev \
    wget \
    pandoc


RUN R -e "install.packages('remotes')"

RUN R -e "remotes::install_github('rstudio/renv@0.16.0')"

RUN mkdir /home/LinReg

RUN mkdir /home/LinReg/pipeline_output

RUN mkdir /home/LinReg/shared_folder

COPY renv.lock   /home/LinReg/renv.lock

#COPY functions /home/LinReg/functions

COPY proj_II.Rmd /home/LinReg/proj_II.Rmd

COPY tvmarketing.csv /home/LinReg/tvmarketing.csv

# COPY _targets.R /home/housing/_targets.R

RUN R -e "setwd('/home/LinReg');renv::init();renv::restore()"

RUN cd /home/LinReg  && R -e "rmarkdown::render('/home/LinReg/proj_II.Rmd', output_file = '/home/LinReg/shared_folder/proj_II.html')"

#RUN cd /home/LinReg  && R -e \"rmarkdown::render('/home/LinReg/proj_II.Rmd', output_dir = '/home/LinReg/shared_folder', output_file = 'proj_II.html')

CMD mv  /home/LinReg/pipeline_output/*  /home/LinReg/shared_folder/
