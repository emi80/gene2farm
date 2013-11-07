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
    printf "$date - $msg\n"
}

install() {

  # Create installation folders

  log "Create installation folders"
  mkdir $HOME/soft && cd $HOME/soft
  mkdir -p $HOME/soft/logs


  # Define log folder and files

  logDir="$HOME/soft/logs"

  systemLog="$logDir/system.log"
  bashLog="$logDir/bash.log"
  javaLog="$logDir/java.log"
  bamtoolsLog="$logDir/bamtools.log"
  bedtoolsLog="$logDir/bedtools.log"
  bwaLog="$logDir/bwa.log"
  samtoolsLog="$logDir/samtools.log"
  gmapLog="$logDir/gmap.log"
  lastLog="$logDir/last.log"
  stampyLog="$logDir/stampy.log"
  tagdustLog="$logDir/tagdust.log"
  vcftoolsLog="$logDir/vcftools.log"

  # Unused log files

  # bowtieLog="$logDir/bowtie.log"
  # tophatLog="$logDir/tophat.log"
  # cufflinksLog="$logDir/cufflinks.log"
  # exonerateLog="$logDir/exonerate.log"
  # fastqcLog="$logDir/fastqc.log"
  # gatkLog="$logDir/gatk.log"
  # igvLog="$logDir/igv.log"
  # igvToolsLog="$logDir/igvTools.log"
  # picardLog="$logDir/picard.log"
  # gemtoolsLog="$logDir/gemtools.log"
  # fluxLog="$logDir/flux.log"


  # Install missing packages

  log "Install missing packages"
  sudo apt-get update --fix-missing &> $systemLog
  sudo apt-get install -y vim cmake make g++ git unzip gettext wget curl python-software-properties x11-apps libncurses5-dev libncursesw5-dev &> $systemLog


  # Update bash to fix the direxpand issue

  log "Update bash to v4.2.45"
  cd ~/soft
  git clone git://git.sv.gnu.org/bash.git &> $bashLog
  cd bash
  ./configure --prefix="/" &> $bashLog
  make &> $bashLog
  sudo make install &> $bashLog
  cd .. && rm -rf bash
  printf '\nshopt -s direxpand\n' >> ~/.bashrc


  # Install Oracle JRE

  log "Install Oracle JRE 7"
  sudo add-apt-repository -y ppa:webupd8team/java &> $javaLog
  sudo apt-get update &> $javaLog
  echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
  echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
  sudo apt-get install -y oracle-java7-installer &> $javaLog
  sudo apt-get install -y libxrender1 libxtst6 libxi6 &> $javaLog

  # Install BAMtools

  log "Install BAMtools v2.3.0"
  cd ~/soft
  git clone git://github.com/pezmaster31/bamtools.git &> $bamtoolsLog
  cd bamtools
  git checkout v2.3.0 &> $bamtoolsLog
  mkdir build
  cd build
  cmake .. &> $bamtoolsLog
  make &> $bamtoolsLog
  printf '\nexport PATH=$HOME/soft/bamtools/bin:$PATH' >> ~/.bashrc
  printf '\nexport LD_LIBRARY_PATH=$HOME/soft/bamtools/lib:$LD_LIBRARY_PATH\n' >> ~/.bashrc


  # Install BEDtools

  log "Install BEDtools v2.17.0"
  cd ~/soft
  wget -q http://bedtools.googlecode.com/files/BEDTools.v2.17.0.tar.gz
  tar xf BEDTools.v2.17.0.tar.gz && rm BEDTools.v2.17.0.tar.gz
  cd bedtools-2.17.0
  make &> $bedtoolsLog
  printf '\nexport PATH=$HOME/soft/bedtools-2.17.0:$PATH\n' >> ~/.bashrc


  # Install Bowtie2

  log "Install Bowtie2 v2.1.0"
  cd ~/soft
  wget -q -O bowtie2-2.1.0-linux-x86_64.zip 'http://downloads.sourceforge.net/project/bowtie-bio/bowtie2/2.1.0/bowtie2-2.1.0-linux-x86_64.zip?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fbowtie-bio%2Ffiles%2Fbowtie2%2F2.1.0%2F&ts=1375884688&use_mirror=garr'
  unzip -q bowtie2-2.1.0-linux-x86_64.zip && rm bowtie2-2.1.0-linux-x86_64.zip
  printf '\nexport PATH=$HOME/soft/bowtie2-2.1.0/:$PATH\n' >> ~/.bashrc


  # Install Tophat

  log "Install Tophat v2.0.9"
  cd ~/soft
  wget -q http://tophat.cbcb.umd.edu/downloads/tophat-2.0.9.Linux_x86_64.tar.gz
  tar xf tophat-2.0.9.Linux_x86_64.tar.gz && rm tophat-2.0.9.Linux_x86_64.tar.gz
  printf '\nexport PATH=$HOME/soft/tophat-2.0.9.Linux_x86_64:$PATH\n' >> ~/.bashrc


  # Install Bwa

  log "Install Bwa v0.7.5a"
  cd ~/soft
  wget -q http://downloads.sourceforge.net/project/bio-bwa/bwa-0.7.5a.tar.bz2
  tar xf bwa-0.7.5a.tar.bz2 && rm bwa-0.7.5a.tar.bz2
  cd bwa-0.7.5a
  make &> $bwaLog
  printf '\nexport PATH=$HOME/soft/bwa-0.7.5a:$PATH\n' >> ~/.bashrc


  # Install Cufflinks

  log "Install Cufflinks v2.1.1"
  cd ~/soft
  wget -q http://cufflinks.cbcb.umd.edu/downloads/cufflinks-2.1.1.Linux_x86_64.tar.gz
  tar xf cufflinks-2.1.1.Linux_x86_64.tar.gz && rm cufflinks-2.1.1.Linux_x86_64.tar.gz
  printf '\nexport PATH=$HOME/soft/cufflinks-2.1.1.Linux_x86_64:$PATH\n' >> ~/.bashrc


  # Install SAMtools

  log "Install SAMtools v0.1.19"
  cd ~/soft
  wget -q http://downloads.sourceforge.net/project/samtools/samtools/0.1.19/samtools-0.1.19.tar.bz2
  tar xf samtools-0.1.19.tar.bz2 && rm samtools-0.1.19.tar.bz2
  cd samtools-0.1.19
  make &> $samtoolsLog
  printf '\nexport PATH=$HOME/soft/samtools-0.1.19:$PATH\n' >> ~/.bashrc


  # Install Exonerate

  log "Install Exonerate v 2.2.0"
  cd ~/soft
  wget -q http://www.ebi.ac.uk/~guy/exonerate/exonerate-2.2.0-x86_64.tar.gz
  tar xf exonerate-2.2.0-x86_64.tar.gz && rm exonerate-2.2.0-x86_64.tar.gz
  printf '\nexport PATH=$HOME/soft/exonerate-2.2.0-x86_64:$PATH\n' >> ~/.bashrc


  # Install Fastqc

  log "Install Fastqc v0.10.1"
  cd ~/soft
  wget -q http://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.10.1.zip
  unzip -q fastqc_v0.10.1.zip && rm fastqc_v0.10.1.zip
  chmod 755 FastQC/fastqc
  printf '\nexport PATH=$HOME/soft/FastQC:$PATH\n' >> ~/.bashrc


  # Install GenomeAnalysisTK

  log "Install GenomeAnalysisTK v2.7.4"
  cd ~/soft
  wget -q http://genome.crg.es/~epalumbo/gene2farm/GenomeAnalysisTK-2.7-4.tar.bz2
  tar xf GenomeAnalysisTK-2.7-4.tar.bz2 && rm GenomeAnalysisTK-2.7-4.tar.bz2


  # Install Gmap

  log "Install Gmap - 28 Nov 2013"
  cd ~/soft
  wget -q http://research-pub.gene.com/gmap/src/gmap-gsnap-2013-10-28.tar.gz
  tar xf gmap-gsnap-2013-10-28.tar.gz && rm gmap-gsnap-2013-10-28.tar.gz
  cd gmap-2013-10-28
  ./configure &> $gmapLog
  make &> $gmapLog
  printf '\nexport PATH=$HOME/soft/gmap-2013-10-28/src:$PATH\n' >> ~/.bashrc

  # Install IGV

  log "Install IGV v2.3.20"
  cd ~/soft
  wget -q http://genome.crg.es/~epalumbo/gene2farm/IGV_2.3.20.zip
  unzip -q IGV_2.3.20.zip && rm IGV_2.3.20.zip
  printf '\nexport PATH=$HOME/soft/IGV_2.3.20:$PATH\n' >> ~/.bashrc


  # Install Igvtools

  log "Install IGVtools v2.3.20"
  cd ~/soft
  wget -q http://genome.crg.es/~epalumbo/gene2farm/igvtools_2.3.20.zip
  unzip -q igvtools_2.3.20.zip && rm igvtools_2.3.20.zip
  printf '\nexport PATH=$HOME/soft/IGVTools:$PATH\n' >> ~/.bashrc


  # Install Last

  log "Install Last v362"
  cd ~/soft
  wget -q http://last.cbrc.jp/last-362.zip
  unzip -q last-362.zip && rm last-362.zip
  cd last-362
  make &> $lastLog
  printf '\nexport PATH=$HOME/soft/last-362/src:$PATH\n' >> ~/.bashrc

  # Install Picard-tools

  log "Install Picard-tools v1.101"
  cd ~/soft
  wget -q http://downloads.sourceforge.net/project/picard/picard-tools/1.101/picard-tools-1.101.zip
  unzip -q picard-tools-1.101.zip && rm picard-tools-1.101.zip
  # Uncomment the following line if you do not need the snappy-java jar bundled with picard
  # rm snappy-java*.jar


  # Install Stampy

  log "Install Stampy v1.0.22r1848"
  cd ~/soft
  wget -q http://genome.crg.es/~epalumbo/gene2farm/stampy-1.0.22r1848.tgz
  tar xf stampy-1.0.22r1848.tgz && rm stampy-1.0.22r1848.tgz
  cd stampy-1.0.22
  make &> $stampyLog
  printf '\nexport PATH=$HOME/soft/stampy-1.0.22:$PATH\n' >> ~/.bashrc


  # Install Tagdust

  log "Install Tagdust v1.12"
  cd ~/soft
  wget -q http://genome.gsc.riken.jp/osc/english/software/src/tagdust.tgz
  tar xf tagdust.tgz && rm tagdust.tgz
  cd tagdust
  make &> $tagdustLog
  printf '\nexport PATH=$HOME/tagdust:$PATH\n' >> ~/.bashrc


  # Install Vcftools

  log "Install Vcftools v0.1.11"
  cd ~/soft
  wget -q http://downloads.sourceforge.net/project/vcftools/vcftools_0.1.11.tar.gz
  tar xf vcftools_0.1.11.tar.gz && rm vcftools_0.1.11.tar.gz
  cd vcftools_0.1.11
  make &> $vcftoolsLog
  printf '\nexport PATH=$HOME/soft/vcftools_0.1.11/bin:$PATH\n' >> ~/.bashrc


  # Install GEMtools

  log "Install GEMtools v1.7"
  cd ~/soft
  wget -q http://genome.crg.es/~epalumbo/gene2farm/gemtools-1.7-core2.tar.gz
  tar xf gemtools-1.7-core2.tar.gz && rm gemtools-1.7-core2.tar.gz
  printf '\nexport PATH=$HOME/soft/gemtools-1.7-core2/bin:$PATH\n' >> ~/.bashrc


  # Install Flux Capacitor

  log "Install Flux Capacitor v1.2.4"
  cd ~/soft
  wget -q http://sammeth.net/artifactory/barna/barna/barna.capacitor/1.2.4/flux-capacitor-1.2.4.tgz
  tar xf flux-capacitor-1.2.4.tgz && rm flux-capacitor-1.2.4.tgz
  printf '\nexport PATH=$HOME/soft/flux-capacitor-1.2.4/bin/:$PATH\n' >> ~/.bashrc

}

# Exit if already bootstrapped.
test -f /etc/bootstrapped && exit

# fix stdin is not a tty issue
sed -i 's/^mesg n$/tty -s \&\& mesg n/g' /root/.profile

# install
export -f install
export -f log
su vagrant -c "install"

# Mark as bootstrapped
date > /etc/bootstrapped
