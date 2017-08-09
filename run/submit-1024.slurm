#!/bin/bash
#SBATCH -J MINIPIC-ATS3
#SBATCH -N 1024
#SBATCH -p regular
#SBATCH --time=00:30:00
#SBATCH --workdir=/global/homes/s/sdhammo/miniPIC-201602/run

module load gcc/4.9.2

echo "Running MiniPIC in $PWD ..."

MINIPIC_PATH=/global/homes/s/sdhammo/miniPIC-201602/build/src/main

export OMP_NUM_THREADS=1
srun -n 24576 -c $OMP_NUM_THREADS --ntasks-per-node 24 \
	$MINIPIC_PATH 2>&1 | tee \
	minipic-mpi-24576-omp-$OMP_NUM_THREADS-run-0.out

export OMP_NUM_THREADS=2
srun -n 12288 -c $OMP_NUM_THREADS --ntasks-per-node 12 \
        $MINIPIC_PATH 2>&1 | tee \
        minipic-mpi-12288-omp-$OMP_NUM_THREADS-run-0.out

export OMP_NUM_THREADS=6
srun -n 4096 -c $OMP_NUM_THREADS --ntasks-per-node 4 \
        $MINIPIC_PATH 2>&1 | tee \
        minipic-mpi-4096-omp-$OMP_NUM_THREADS-run-0.out

export OMP_NUM_THREADS=12
srun -n 2048 -c $OMP_NUM_THREADS --ntasks-per-node 2 \
        $MINIPIC_PATH 2>&1 | tee \
        minipic-mpi-2048-omp-$OMP_NUM_THREADS-run-0.out

