#!/bin/bash

##########################################################################################################################################################################################
                                                                        # PYTHON 3 ENVIRONMENT #
##########################################################################################################################################################################################

## create a separate Python3 environment for aditional packages

if [[ ! -d ${bcbio_install_path}/extra3 ]]; then
   echo "--- [$(date +"%F %R")] Setting up a Python3 environment for utility packages"

   bash ${path_to_scripts}/Miniconda3-*.sh -b -p ${bcbio_install_path}/extra3
   ln -s ${bcbio_install_path}/extra3/bin/conda ${bcbio_install_path}/extra3/bin/conda_extra3

   ${bcbio_install_path}/extra3/bin/conda_extra3 install --yes -c conda-forge -c bioconda mamba
   
   ln -s ${bcbio_install_path}/extra3/bin/mamba ${bcbio_install_path}/extra3/bin/mamba_extra3

   ## installing packages
#   ${bcbio_install_path}/extra3/bin/mamba_extra3 install --yes -c conda-forge -c bioconda wget git bedops vcftools sra-tools pyyaml perl entrez-direct tassel beagle plink openssl=1.1.1l ensembl-vep=105 "bcftools>=1.13" biobambam=2.0.87
#   ${bcbio_install_path}/extra3/bin/mamba_extra3 install --yes -c conda-forge r-base
#   ${bcbio_install_path}/extra3/bin/mamba_extra3 install --yes -c conda-forge r-essentials
#   ${bcbio_install_path}/extra3/bin/mamba_extra3 install --yes -c conda-forge gxx_linux-64

#   ${bcbio_install_path}/extra3/bin/mamba_extra3 install --yes -c conda-forge -c bioconda bioconductor-annotationhub bioconductor-annotationdbi bioconductor-meshdbi r-ggplot2 bioconductor-clusterprofiler bioconductor-dose bioconductor-meshes bioconductor-chipseeker bioconductor-gosemsim bioconductor-reactomepa bioconductor-variantannotation bioconductor-deseq2 r-rcolorbrewer r-pheatmap bioconductor-enrichplot
   
#   ${bcbio_install_path}/extra3/bin/mamba_extra3 install --yes -c conda-forge -c bioconda gxx_linux-64 wget git bedops vcftools pyyaml kraken2 sra-tools perl-net-ssleay entrez-direct tassel beagle gcta "gdal>=2.0.1" plink "bcftools>=1.15" haploview gatk4 "ensembl-vep>=105" "perl-bioperl>=1.7.2" "r-base>=4.1" r-essentials "r-raster>=3.5_21" r-xml r-knitr r-rmarkdown r-shiny r-rcpp r-devtools r-reticulate perl-bio-tools-run-alignment-tcoffee r-terra r-rgdal r-ragg bioconductor-annotationhub bioconductor-annotationdbi bioconductor-meshdbi r-ggplot2 bioconductor-clusterprofiler bioconductor-dose bioconductor-meshes bioconductor-chipseeker bioconductor-gosemsim bioconductor-reactomepa bioconductor-variantannotation bioconductor-deseq2 r-rcolorbrewer r-pheatmap bioconductor-enrichplot
#   ${bcbio_install_path}/extra3/bin/mamba_extra3 install --yes -c conda-forge -c bioconda gxx_linux-64 wget git bedops vcftools pyyaml perl-yaml perl-encode-locale "sra-tools>=2.11" perl-net-ssleay entrez-direct tassel beagle gcta "gdal>=2.0.1" plink "bcftools>=1.15" haploview gatk4 "ensembl-vep>=105" "perl-bioperl>=1.7.2" "r-base>=4.1" r-essentials r-raster r-xml r-knitr r-rmarkdown r-shiny r-rcpp r-devtools r-reticulate perl-bio-tools-run-alignment-tcoffee r-terra r-rgdal r-ragg

   ${bcbio_install_path}/extra3/bin/mamba_extra3 install --yes -c conda-forge -c bioconda gxx_linux-64 wget git vcftools pyyaml perl-yaml perl-encode-locale "sra-tools>=2.11" perl-net-ssleay entrez-direct tassel beagle gcta "gdal>=2.0.1" plink haploview "ensembl-vep>=107" "perl-bioperl>=1.7.2" "r-base>=4.1" r-essentials r-raster r-xml r-knitr r-rmarkdown r-shiny r-rcpp r-devtools r-reticulate perl-bio-tools-run-alignment-tcoffee r-terra r-rgdal r-ragg
   
   ## install the Encode::Locale perl module
   yes | ${bcbio_install_path}/extra3/bin/cpan install Encode::Locale
   
fi
