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

  if [ ! -d $HOME/soft ]; then
    log "Create installation folder"
    mkdir $HOME/soft && cd $HOME/soft
  fi
  if [ ! -d $HOME/soft/logs ]; then
    log "Create log folder"
    mkdir -p $HOME/soft/logs
  fi


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
  sudo apt-get install -y vim cmake make g++ git unzip gettext wget curl python-software-properties x11-apps nano nedit libncurses5-dev libncursesw5-dev &> $systemLog


  # Install xfce4

  if [[ ! `grep "service lightdm start" /etc/rc.local` ]]; then
    log "Install Xfce 4"
    sudo apt-get install -y lightdm &> $systemLog
    sudo /usr/lib/lightdm/lightdm-set-defaults -s xfce
    sudo apt-get install -y xfce4 &> $systemLog
    sudo apt-get install -y elementary-icon-theme xfce4-terminal &> $systemLog
  fi


    # Update bash to fix the direxpand issue

  if [ ! -d $HOME/soft/bash ]; then
    log "Update bash to v4.2.45"
    cd ~/soft
    git clone http://git.savannah.gnu.org/r/bash.git &> $bashLog
    cd bash
    ./configure --prefix="/" &> $bashLog
    make &> $bashLog
    sudo make install &> $bashLog
    cd .. && rm -rf bash
    printf '\nshopt -s direxpand\n' >> ~/.bashrc
  fi

  # Install Oracle JRE

  java=`java -version 2>&1 | head -2 | tail -n1 | cut -d " " -f1`
  if [[ $java != 'Java(TM)' ]]; then
    log "Install Oracle JRE 7"
    sudo add-apt-repository -y ppa:webupd8team/java &> $javaLog
    sudo apt-get update &> $javaLog
    echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
    echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
    sudo apt-get install -y oracle-java7-installer &> $javaLog
    sudo apt-get install -y libxrender1 libxtst6 libxi6 &> $javaLog
  fi

  # Install BAMtools

  if [ ! -d $HOME/soft/bamtools ]; then
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
  fi

  # Install BEDtools

  if [ ! -d $HOME/soft/bedtools-2.17.0 ]; then
    log "Install BEDtools v2.17.0"
    cd ~/soft
    wget -q http://bedtools.googlecode.com/files/BEDTools.v2.17.0.tar.gz
    tar xf BEDTools.v2.17.0.tar.gz && rm BEDTools.v2.17.0.tar.gz
    cd bedtools-2.17.0
    make &> $bedtoolsLog
    printf '\nexport PATH=$HOME/soft/bedtools-2.17.0/bin:$PATH\n' >> ~/.bashrc
  fi


  # Install Bowtie2

  if [ ! -d $HOME/soft/bowtie2-2.1.0 ]; then
    log "Install Bowtie2 v2.1.0"
    cd ~/soft
    wget -q -O bowtie2-2.1.0-linux-x86_64.zip 'http://downloads.sourceforge.net/project/bowtie-bio/bowtie2/2.1.0/bowtie2-2.1.0-linux-x86_64.zip?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fbowtie-bio%2Ffiles%2Fbowtie2%2F2.1.0%2F&ts=1375884688&use_mirror=garr'
    unzip -q bowtie2-2.1.0-linux-x86_64.zip && rm bowtie2-2.1.0-linux-x86_64.zip
    printf '\nexport PATH=$HOME/soft/bowtie2-2.1.0/:$PATH\n' >> ~/.bashrc
  fi


  # Install Tophat

  if [ ! -d $HOME/soft/tophat-2.0.9.Linux_x86_64 ]; then
    log "Install Tophat v2.0.9"
    cd ~/soft
    wget -q http://tophat.cbcb.umd.edu/downloads/tophat-2.0.9.Linux_x86_64.tar.gz
    tar xf tophat-2.0.9.Linux_x86_64.tar.gz && rm tophat-2.0.9.Linux_x86_64.tar.gz
    printf '\nexport PATH=$HOME/soft/tophat-2.0.9.Linux_x86_64:$PATH\n' >> ~/.bashrc
  fi


  # Install Bwa

  if [ ! -d $HOME/soft/bwa-0.7.5a ]; then
    log "Install Bwa v0.7.5a"
    cd ~/soft
    wget -q http://downloads.sourceforge.net/project/bio-bwa/bwa-0.7.5a.tar.bz2
    tar xf bwa-0.7.5a.tar.bz2 && rm bwa-0.7.5a.tar.bz2
    cd bwa-0.7.5a
    make &> $bwaLog
    printf '\nexport PATH=$HOME/soft/bwa-0.7.5a:$PATH\n' >> ~/.bashrc
  fi


  # Install Cufflinks

  if [ ! -d $HOME/soft/cufflinks-2.1.1.Linux_x86_64 ]; then
    log "Install Cufflinks v2.1.1"
    cd ~/soft
    wget -q http://cufflinks.cbcb.umd.edu/downloads/cufflinks-2.1.1.Linux_x86_64.tar.gz
    tar xf cufflinks-2.1.1.Linux_x86_64.tar.gz && rm cufflinks-2.1.1.Linux_x86_64.tar.gz
    printf '\nexport PATH=$HOME/soft/cufflinks-2.1.1.Linux_x86_64:$PATH\n' >> ~/.bashrc
  fi


  # Install SAMtools

  if [ ! -d $HOME/soft/samtools-0.1.19 ]; then
    log "Install SAMtools v0.1.19"
    cd ~/soft
    wget -q http://downloads.sourceforge.net/project/samtools/samtools/0.1.19/samtools-0.1.19.tar.bz2
    tar xf samtools-0.1.19.tar.bz2 && rm samtools-0.1.19.tar.bz2
    cd samtools-0.1.19
    make &> $samtoolsLog
    printf '\nexport PATH=$HOME/soft/samtools-0.1.19:$PATH\n' >> ~/.bashrc
  fi


  # Install Exonerate

  if [ ! -d $HOME/soft/exonerate-2.2.0-x86_64 ]; then
    log "Install Exonerate v 2.2.0"
    cd ~/soft
    wget -q http://www.ebi.ac.uk/~guy/exonerate/exonerate-2.2.0-x86_64.tar.gz
    tar xf exonerate-2.2.0-x86_64.tar.gz && rm exonerate-2.2.0-x86_64.tar.gz
    printf '\nexport PATH=$HOME/soft/exonerate-2.2.0-x86_64/bin:$PATH\n' >> ~/.bashrc
  fi


  # Install Fastqc

  if [ ! -d $HOME/soft/FastQC ]; then
    log "Install Fastqc v0.10.1"
    cd ~/soft
    wget -q http://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.10.1.zip
    unzip -q fastqc_v0.10.1.zip && rm fastqc_v0.10.1.zip
    chmod 755 FastQC/fastqc
    printf '\nexport PATH=$HOME/soft/FastQC:$PATH\n' >> ~/.bashrc
  fi


  # Install GenomeAnalysisTK

  if [ ! -d $HOME/soft/GenomeAnalysisTK-2.7-4-g6f46d11 ]; then
    log "Install GenomeAnalysisTK v2.7.4"
    cd ~/soft
    wget -q http://genome.crg.es/~epalumbo/gene2farm/GenomeAnalysisTK-2.7-4.tar.bz2
    tar xf GenomeAnalysisTK-2.7-4.tar.bz2 && rm GenomeAnalysisTK-2.7-4.tar.bz2
  fi


  # Install Gmap

  if [ ! -d $HOME/soft/gmap-2013-10-28 ]; then
    log "Install Gmap - 28 Nov 2013"
    cd ~/soft
    wget -q http://research-pub.gene.com/gmap/src/gmap-gsnap-2013-10-28.tar.gz
    tar xf gmap-gsnap-2013-10-28.tar.gz && rm gmap-gsnap-2013-10-28.tar.gz
    cd gmap-2013-10-28
    ./configure &> $gmapLog
    make &> $gmapLog
    printf '\nexport PATH=$HOME/soft/gmap-2013-10-28/src:$PATH\n' >> ~/.bashrc
  fi

  # Install IGV

  if [ ! -d $HOME/soft/IGV_2.3.20 ]; then
    log "Install IGV v2.3.20"
    cd ~/soft
    wget -q http://genome.crg.es/~epalumbo/gene2farm/IGV_2.3.20.zip
    unzip -q IGV_2.3.20.zip && rm IGV_2.3.20.zip
    printf '\nexport PATH=$HOME/soft/IGV_2.3.20:$PATH\n' >> ~/.bashrc
  fi


  # Install Igvtools

  if [ ! -d $HOME/soft/IGVTools ]; then
    log "Install IGVtools v2.3.20"
    cd ~/soft
    wget -q http://genome.crg.es/~epalumbo/gene2farm/igvtools_2.3.20.zip
    unzip -q igvtools_2.3.20.zip && rm igvtools_2.3.20.zip
    printf '\nexport PATH=$HOME/soft/IGVTools:$PATH\n' >> ~/.bashrc
  fi


  # Install Last

  if [ ! -d $HOME/soft/last-362 ]; then
    log "Install Last v362"
    cd ~/soft
    wget -q http://last.cbrc.jp/last-362.zip
    unzip -q last-362.zip && rm last-362.zip
    cd last-362
    make &> $lastLog
    printf '\nexport PATH=$HOME/soft/last-362/src:$PATH\n' >> ~/.bashrc
  fi

  # Install Picard-tools

  if [ ! -d $HOME/soft/picard-tools-1.101 ]; then
    log "Install Picard-tools v1.101"
    cd ~/soft
    wget -q http://downloads.sourceforge.net/project/picard/picard-tools/1.101/picard-tools-1.101.zip
    unzip -q picard-tools-1.101.zip && rm picard-tools-1.101.zip
    # Uncomment the following line if you do not need the snappy-java jar bundled with picard
    # rm snappy-java*.jar
  fi


  # Install Stampy

  if [ ! -d $HOME/soft/stampy-1.0.22 ]; then
    log "Install Stampy v1.0.22r1848"
    cd ~/soft
    wget -q http://genome.crg.es/~epalumbo/gene2farm/stampy-1.0.22r1848.tgz
    tar xf stampy-1.0.22r1848.tgz && rm stampy-1.0.22r1848.tgz
    cd stampy-1.0.22
    make &> $stampyLog
    printf '\nexport PATH=$HOME/soft/stampy-1.0.22:$PATH\n' >> ~/.bashrc
  fi


  # Install Tagdust

  if [ ! -d $HOME/soft/tagdust ]; then
    log "Install Tagdust v1.12"
    cd ~/soft
    wget -q http://genome.gsc.riken.jp/osc/english/software/src/tagdust.tgz
    tar xf tagdust.tgz && rm tagdust.tgz
    cd tagdust
    make &> $tagdustLog
    printf '\nexport PATH=$HOME/soft/tagdust:$PATH\n' >> ~/.bashrc
  fi


  # Install Vcftools

  if [ ! -d $HOME/soft/vcftools_0.1.11 ]; then
    log "Install Vcftools v0.1.11"
    cd ~/soft
    wget -q http://downloads.sourceforge.net/project/vcftools/vcftools_0.1.11.tar.gz
    tar xf vcftools_0.1.11.tar.gz && rm vcftools_0.1.11.tar.gz
    cd vcftools_0.1.11
    make &> $vcftoolsLog
    printf '\nexport PATH=$HOME/soft/vcftools_0.1.11/bin:$PATH\n' >> ~/.bashrc
  fi


  # Install GEMtools

  if [ ! -d $HOME/soft/gemtools-1.7-core2 ]; then
    log "Install GEMtools v1.7"
    cd ~/soft
    wget -q http://genome.crg.es/~epalumbo/gene2farm/gemtools-1.7-core2.tar.gz
    tar xf gemtools-1.7-core2.tar.gz && rm gemtools-1.7-core2.tar.gz
    printf '\nexport PATH=$HOME/soft/gemtools-1.7-core2/bin:$PATH\n' >> ~/.bashrc
  fi


  # Install Flux Capacitor

  if [ ! -d $HOME/soft/flux-capacitor-1.2.4 ]; then
    log "Install Flux Capacitor v1.2.4"
    cd ~/soft
    wget -q http://sammeth.net/artifactory/barna/barna/barna.capacitor/1.2.4/flux-capacitor-1.2.4.tgz
    tar xf flux-capacitor-1.2.4.tgz && rm flux-capacitor-1.2.4.tgz
    printf '\nexport PATH=$HOME/soft/flux-capacitor-1.2.4/bin/:$PATH\n' >> ~/.bashrc
  fi

}

# Force re-bootstrapping
if [[ $1 == "reset" ]]; then
  log "Reset bootstrapping"
  rm /etc/bootstrapped
fi

# Exit if already bootstrapped.
test -f /etc/bootstrapped && exit

# fix stdin is not a tty issue
sed -i 's/^mesg n$/tty -s \&\& mesg n/g' /root/.profile

# install
export -f install
export -f log
su vagrant -c "install"

# start gdm
ldm=`dpkg -l lightdm | tail -n 1 | cut -d " " -f1`
ldmStatus=`service lightdm status | cut -d " " -f2`
[[ $ldm == "ii" ]] && [[ $ldmStatus != "start/running" ]] && service lightdm start

# Mark as bootstrapped
date > /etc/bootstrapped
