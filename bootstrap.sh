#!/bin/bash
#
#  Copyright (c) 2013, Centre for Genomic Regulation (CRG) and the authors
#
#  This file is part of the virtual machine for the Gene2Farm Winter School
#  taking place in Piacenza, 13-16 of November 2013
#

log() {
    msg=$1
    date=`date`
    printf "$date - $msg" > /dev/stderr
}

install() {

  # Install missing packages

  log "Install missing packages"
  sudo apt-get update --fix-missing
  sudo apt-get install -y vim cmake make g++ git unzip libncurses5-dev libncursesw5-dev wget curl python-software-properties


  # Create software folder

  log "Create software folder"
  mkdir ~/soft && cd ~/soft


  # Update bash to fix the direxpand issue

  log "Update bash to fix the direxpand issue"
  cd ~/soft
  git clone git://git.sv.gnu.org/bash.git
  cd bash
  ./configure
  make
  sudo make install
  printf '\nshopt -s direxpand\n' >> ~/.bashrc

  # Install Oracle JRE

  log "Install Oracle JRE"
  sudo add-apt-repository -y ppa:webupd8team/java
  sudo apt-get update
  sudo apt-get install -y oracle-java7-installer


  # Install BAMtools

  log "Install BAMtools"
  cd ~/soft
  git clone git://github.com/pezmaster31/bamtools.git
  cd bamtools
  git checkout v2.3.0
  mkdir build
  cd build
  cmake ..
  make
  printf '\nexport PATH=$HOME/soft/bamtools/bin:$PATH\n' >> .bashrc
  printf '\nexport LD_LIBRARY_PATH=$HOME/soft/bamtools/lib:$LD_LIBRARY_PATH\n' >> .bashrc


  # Install BEDtools

  log "Install BEDtools"
  cd ~/soft
  wget -q http://bedtools.googlecode.com/files/BEDTools.v2.17.0.tar.gz
  tar xf BEDTools.v2.17.0.tar.gz
  cd bedtools-2.17.0
  make
  printf '\nexport PATH=$HOME/soft/bedtools-2.17.0:$PATH\n' >> ~/.bashrc


  # Install Bowtie2

  log "Install Bowtie2"
  cd ~/soft
  wget -q -O bowtie2-2.1.0-linux-x86_64.zip 'http://downloads.sourceforge.net/project/bowtie-bio/bowtie2/2.1.0/bowtie2-2.1.0-linux-x86_64.zip?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fbowtie-bio%2Ffiles%2Fbowtie2%2F2.1.0%2F&ts=1375884688&use_mirror=garr'
  unzip -q bowtie2-2.1.0-linux-x86_64.zip
  printf '\nexport PATH=$HOME/soft/bowtie2-2.1.0/:$PATH\n' >> ~/.bashrc


  # Install Tophat2

  log "Install Tophat2"
  cd ~/soft
  wget -q http://tophat.cbcb.umd.edu/downloads/tophat-2.0.9.Linux_x86_64.tar.gz
  tar xf tophat-2.0.9.Linux_x86_64.tar.gz
  printf '\nexport PATH=$HOME/soft/tophat-2.0.9.Linux_x86_64:$PATH\n' >> ~/.bashrc


  # Install Bwa

  log "Install Bwa"
  cd ~/soft
  wget -q http://downloads.sourceforge.net/project/bio-bwa/bwa-0.7.5a.tar.bz2
  tar xf bwa-0.7.5a.tar.bz2
  cd bwa-0.7.5a
  make
  printf '\nexport PATH=$HOME/soft/bwa-0.7.5a:$PATH\n' >> ~/.bashrc


  # Install Cufflinks

  log "Install Cufflinks"
  cd ~/soft
  wget -q http://cufflinks.cbcb.umd.edu/downloads/cufflinks-2.1.1.Linux_x86_64.tar.gz
  tar xf cufflinks-2.1.1.Linux_x86_64.tar.gz
  printf '\nexport PATH=$HOME/soft/cufflinks-2.1.1.Linux_x86_64:$PATH\n' >> ~/.bashrc


  # Install SAMtools

  log "Install SAMtools"
  cd ~/soft
  wget -q http://downloads.sourceforge.net/project/samtools/samtools/0.1.19/samtools-0.1.19.tar.bz2
  tar xf samtools-0.1.19.tar.bz2
  cd samtools-0.1.19
  make
  printf '\nexport PATH=$HOME/soft/samtools-0.1.19:$PATH\n' >> ~/.bashrc


  # Install Exonerate

  log "Install Exonerate"
  cd ~/soft
  wget http://www.ebi.ac.uk/~guy/exonerate/exonerate-2.2.0-x86_64.tar.gz
  tar xf exonerate-2.2.0-x86_64.tar.gz
  printf '\nexport PATH=$HOME/soft/exonerate-2.2.0-x86_64:$PATH\n' >> ~/.bashrc


  # Install Fastqc

  log "Install Fastqc"
  cd ~/soft
  wget -q http://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.10.1.zip
  unzip -q fastqc_v0.10.1.zip
  chmod 755 FastQC/fastqc
  printf '\nexport PATH=$HOME/soft/FastQC:$PATH\n' >> ~/.bashrc


  # Install GenomeAnalysisTK

  log "Install GenomeAnalysisTK"
  cd ~/soft
  wget -q http://genome.crg.es/~epalumbo/gene2farm/GenomeAnalysisTK-2.7-4.tar.bz2
  tar xf GenomeAnalysisTK-2.7-4.tar.bz2


  # Install Gmap

  log "Install Gmap"
  cd ~/soft
  wget -q http://research-pub.gene.com/gmap/src/gmap-gsnap-2013-10-28.tar.gz
  tar xf gmap-gsnap-2013-10-28.tar.gz
  cd gmap-2013-10-28
  ./configure
  make
  printf '\nexport PATH=$HOME/soft/gmap-2013-10-28/src:$PATH\n' >> ~/.bashrc

  # Install IGV

  log "Install IGV"
  cd ~/soft
  wget -q http://genome.crg.es/~epalumbo/gene2farm/IGV_2.3.20.zip
  unzip -q IGV_2.3.20.zip
  printf '\nexport PATH=$HOME/soft/IGV_2.3.20:$PATH\n' >> ~/.bashrc


  # Install Igvtools

  log "Install IGVtools"
  cd ~/soft
  wget -q http://genome.crg.es/~epalumbo/gene2farm/igvtools_2.3.20.zip
  unzip -q igvtools_2.3.20.zip
  printf '\nexport PATH=$HOME/soft/IGVTools:$PATH\n' >> ~/.bashrc


  # Install Last

  log "Install Last"
  cd ~/soft
  wget -q http://last.cbrc.jp/last-362.zip
  unzip -q last-362.zip
  cd last-362
  make
  printf '\nexport PATH=$HOME/soft/last-362/src:$PATH\n' >> ~/.bashrc

  # Install Picard-tools

  log "Install Picard-tools"
  cd ~/soft
  wget -q http://downloads.sourceforge.net/project/picard/picard-tools/1.101/picard-tools-1.101.zip
  unzip picard-tools-1.101.zip


  # Install Stampy

  log "Install Stampy"
  cd ~/soft
  wget -q http://genome.crg.es/~epalumbo/gene2farm/stampy-1.0.22r1848.tgz
  tar xf stampy-1.0.22r1848.tgz
  cd stampy-1.0.22
  make
  printf '\nexport PATH=$HOME/soft/stampy-1.0.22:$PATH\n' >> ~/.bashrc


  # Install Tagdust

  log "Install Tagdust"
  cd ~/soft
  wget -q http://genome.gsc.riken.jp/osc/english/software/src/tagdust.tgz
  tar xf tagdust.tgz
  cd tagdust
  make
  printf '\nexport PATH=$HOME/tagdust:$PATH\n' >> ~/.bashrc


  # Install Vcftools

  log "Install Vcftools"
  cd ~/soft
  wget -q http://downloads.sourceforge.net/project/vcftools/vcftools_0.1.11.tar.gz
  tar xf vcftools_0.1.11.tar.gz
  cd vcftools_0.1.11
  make
  printf '\nexport PATH=$HOME/soft/vcftools_0.1.11/bin:$PATH\n' >> ~/.bashrc


  # Install GEM

  log "Install GEMtools"
  cd ~/soft
  wget -q http://barnaserver.com/gemtools/releases/GEMTools-static-core2-1.6.2.tar.gz
  tar xf GEMTools-static-core2-1.6.2.tar.gz
  printf '\nexport PATH=$HOME/gemtools-1.6.2-core2/bin:$PATH\n' >> ~/.bashrc


  # Install FLUX

  log "Install Flux Capacitor"
  cd ~/soft
  wget -q http://sammeth.net/artifactory/barna/barna/barna.capacitor/1.2.4/flux-capacitor-1.2.4.tgz
  tar xf flux-capacitor-1.2.4.tgz
  printf '\nexport PATH=$HOME/flux-capacitor-1.2.4/bin/:$PATH\n' >> ~/.bashrc

}

# Exit if already bootstrapped.
test -f /etc/bootstrapped && exit

# set log file
logFile="bootstrap.log"

export -f install
export -f log
su vagrant -c "install > \$HOME/$logFile"

# Mark as bootstrapped
sudo sh -c "date > /etc/bootstrapped"
