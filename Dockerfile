FROM bioconductor/bioconductor_docker:devel

WORKDIR /home/rstudio

COPY --chown=rstudio:rstudio . /home/rstudio/

RUN apt-get update && apt-get install -y libglpk-dev
RUN Rscript -e "Sys.setenv(R_REMOTES_NO_ERRORS_FROM_WARNINGS='true'); devtools::install('.', dependencies=TRUE, build_vignettes=TRUE, repos = BiocManager::repositories())"
