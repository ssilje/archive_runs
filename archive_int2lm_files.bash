#!/usr/local/bin/bash -l
#
#SBATCH --account=pr04
#SBATCH --nodes=1
##SBATCH --partition=prepost
#SBATCH --time=0:30:00
#SBATCH --constraint=gpu
#SBATCH --output=tar_laf.out
#SBATCH --error=tar_laf.err
#SBATCH --job-name="tar-laf"

# ***** get time
startyear=${1}
endyear=${2}

set +ex
NEXTYEAR=`expr ${startyear} + 1`
set -ex
echo $NEXTYEAR

#storedir=/project/pr04/CORDEX-driving-data/EUR-44/ERA-Interim_aerocom
storedir=/scratch/snx3000/ssilje/tmp_int2lm
datadir=/scratch/snx3000/ssilje/RUN_int2lm_ERAI_EUR-44_aerocom/output/
scriptdir=/users/ssilje/archive_runs

if [ ! -d $storedir ]
then
 mkdir $storedir
fi

if [ ! -d $storedir/year$startyear ]
then
 mkdir $storedir/year$startyear
fi

cd ${datadir}
tar -cvf $storedir/year$startyear/laf${startyear}.tar ${startyear}


if [ ${NEXTYEAR} -le ${endyear} ]
then
    cd $scriptdir
    sbatch transfer_laf  ${startyear} ${endyear}
    
    if [ -e ${storedir}/year$startyear/laf${startyear}.tar ]
    then
#	rm -r ${storedir}/year$startyear
	sbatch archive_int2lm_files.bash ${NEXTYEAR} ${endyear}
    fi
    
fi

exit 0
