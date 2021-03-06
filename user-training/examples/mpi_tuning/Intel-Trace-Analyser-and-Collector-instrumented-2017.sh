#!/bin/bash
#SBATCH -J TraceCollector
#SBATCH --time=00:10:00
#SBATCH --mem-per-cpu=2G
ml intel/2017a 
ml VTune/2017_update2
ml itac/2017.2.028
source itacvars.sh impi5
######################################################################################
export VT_PCTRACE=4
export VT_CONFIG=$HOME/snow-labs/user-training/examples/mpi_tuning/trace.conf
# the code needs to be compiled with -tcollect option in order to be instrumented
# mpiicpc ../heart_demo.cpp ../luo_rudy_1991.cpp ../rcm.cpp ../mesh.cpp -tcollect -g \
#         -o heart_demo -O3 -std=c++11 -qopenmp -parallel-source-info=2 \
#         -D_GLIBCXX_USE_CXX11_ABI=0 $VT_ADD_LIBS
cp $HOME/snow-labs/user-training/examples/Cardiac_demo/mesh_mid* $SCRATCH_DIR/
cp $HOME/snow-labs/user-training/examples/Cardiac_demo/setup_mid.txt $SCRATCH_DIR/
cd $SCRATCH_DIR
srun $HOME/snow-labs/user-training/examples/Cardiac_demo/build_instrumented/heart_demo -m ./mesh_mid -s ./setup_mid.txt -t 50
mkdir -p $HOME/snow-labs/user-training/OUT/
cp -pr $SCRATCH_DIR $HOME/snow-labs/user-training/OUT/
