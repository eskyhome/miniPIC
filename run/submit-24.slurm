#!/bin/bash
#SBATCH -J MINIPIC-ATS3
#SBATCH -N 1
#SBATCH -p debug
#SBATCH --workdir=/global/homes/s/sdhammo/miniPIC-201602/run

module load gcc/4.9.2

echo "Running MiniPIC in $PWD ..."

MINIPIC_PATH=/global/homes/s/sdhammo/miniPIC-201602/build/src/main

export OMP_NUM_THREADS=1

srun -n 24 -c $OMP_NUM_THREADS --ntasks-per-node 24 \
	$MINIPIC_PATH --mesh=$PWD/brick.txt 2>&1 | tee \
	minipic-mpi-24-omp-$OMP_NUM_THREADS-run-0.out

