#!/usr/local/bin/bash -l
#
#SBATCH --account=pr04
#SBATCH --nodes=1
##SBATCH --partition=prepost
#SBATCH --time=0:30:00
#SBATCH --constraint=gpu
#SBATCH --output=tar_cclm5.out
#SBATCH --error=tar_cclm5.err
#SBATCH --job-name="tar-cclm5"

# ***** get time
startyear=${1}
endyear=${2}

set +ex
NEXTYEAR=`expr ${startyear} + 1`
set -ex
echo $NEXTYEAR



scenario=evaluation

experiment=RUN_CCLM5.0_6_ERAI_EUR-44
experiment_id=ECMWF-ERAINT_${scenario}_CLMcom-CCLM5-0-6
datadir=/scratch/snx3000/demorym/${experiment}
storedir=/scratch/snx3000/ssilje/tmp/${experiment}


scriptdir=/users/ssilje/archive_runs


if [ ! -d $storedir ]
then
 mkdir $storedir
fi


if [ ! -d $storedir/$scenario ]
then
 mkdir $storedir/$scenario
fi


cd  $datadir/output/out01/${startyear}/


  if [ `ls -L | wc -l` -ne 2921 ] && [ `ls -L | wc -l` -ne 2929 ];
    then
        echo "Wrong number of files in out1"
        exit
   
fi


cd  $datadir/output/out02/${startyear}/

 if [ `ls -L | wc -l` -ne 366 ] && [ `ls -L | wc -l` -ne 365 ];
    then
        echo "Wrong number of files in out2"
        exit
fi

cd  $datadir/output/out03/${startyear}/
 if [ `ls -L | wc -l` -ne 8760 ] && [ `ls -L | wc -l` -ne 8784 ];
    then
        echo "Wrong number of files in out3"
        exit
   
fi


cd  $datadir/output/out04/${startyear}/
 if [ `ls -L | wc -l` -ne 2920 ] && [ `ls -L | wc -l` -ne 2928 ];
    then
        echo "Wrong number of files in out4"
        exit
   
fi


cd  $datadir/output/out05/${startyear}/
  if [ `ls -L | wc -l` -ne 1464 ] && [ `ls -L | wc -l` -ne 1460 ];
    then
        echo "Wrong number of files in out5"
        exit
fi

cd  $datadir/output/out06/${startyear}/
 if [ `ls -L | wc -l` -ne 1464 ] && [ `ls -L | wc -l` -ne 1460 ];
    then
        echo "Wrong number of files in out6"
        exit
  
fi
cd  $datadir/output/out07/${startyear}/
if [ `ls -L | wc -l` -ne 366 ] && [ `ls -L | wc -l` -ne 365 ];
    then
        echo "Wrong number of files in out7"
        exit

fi
cd ${datadir}

tar -cvf $storedir/$scenario/${experiment_id}_${startyear}.tar output/out??/${startyear}


if [ ${NEXTYEAR} -le ${endyear} ]
then
 cd $scriptdir
 sbatch transfer ${startyear}
 sbatch archive_cosmo_runs.bash ${NEXTYEAR} ${endyear}
fi

exit 0
