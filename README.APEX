
===========================================================
Mini Particle-in-Cell (MiniPIC) for APEX
===========================================================

The miniPIC benchmarking used for the APEX procurement is based on git revision
51e22de99774c94bd539f6a88af2cfa442a7a409 from Sandia's internal repository

===========================================================

== I. 	Description: ==

MiniPIC solves the discrete Boltzman equation in an electrostatic field in an arbitrary 
domain with reflective walls. The code has potentially difficult dynamic memory 
requirements, localized work (potentially with imbalances) and stochastic processes. The 
MiniPIC benchmark uses an unstructured hex- or tet-based mesh with a static partition 
used for a particle mesh. Particles are tracked to every cell crossing, packed and passed 
off to adjacent processors using MPI. The main code base uses Tpetra objects from the 
Trilinos mathematics library for matrix/vector operations. Kokkos kernels are used to 
provide performance portability across architectures.


== II. Parallelism: ==

MiniPIC implements parallelism using the Kokkos performance portable programming model
developed by Sandia National Laboratories. Typically it is configured to utilize OpenMP
or CUDA backends depending on the target host. For the purposes of this benchmarking
exercise vendors are permitted to use any backend which is appropriate for their
hardware (since Kokkos abstracts this for the application).

== III. How to Build: == 

(1) The first step to build MiniPIC requires a compile of the Trilinos mathematics
library (https://trilinos.org). Scripts to configure Trilinos can be found in the
extra directory of the source distribution. Example configurations for CPU and GPU
systems are included although these are very likely to be modified to use appropriate
third party libraries and compiler settings.

(2) Make a directory called build in the MiniPIC base directory

(3) In "build" configure MiniPIC with cmake using:

cmake -DTrilinos_PREFIX=/path-to-install ..

(4) Run make and MiniPIC will be built

== IV.  How to Run: == 

In the "run" directory is an example brick.txt file. This file defines the problem size
in Nx, Ny, Nz being solved by MiniPIC and is read in during the start of computation.
The problem state should be ideally kept with the dimensions equal.

Global Problem Sizes Definitions:

Small - 10 10 10
Large (APEX Reference Problem) - 70 70 70
Grand Challenge (APEX Target Problem) - 140 140 140

Mapping of MPI ranks to nodes or global mesh decomposition over nodes can be modifed by
the user as required but the final mesh must meet the sizes outlined.

** IMPORTANT FOR SCALING RUNS OF MiniPIC - READ **

In order to maintain the same time stepping as the original algorithm, the user may
choose to modify the dt (time stepping value) and tfinal (the simulated stop time).
For the APEX reference problem the benchmark dt default (dt=0.1) and tfinal default
(tfinal=1.0) are used. To provide an approximate weak scaling approach the dt and
tfinal ratio should be maintained. To scale these values by example if the problem
size increases by 2X in each dimension (as in the APEX challenge problem) then a dt
value of old_dt/2 (= 0.1/2 = 0.05) should be used. This can be specified by using the
--dt=0.05 option to MiniPIC when running the (2X * 2X * 2X = 8X) larger problem
definition. tfinal should be set to 0.5 to maintain the ratio.

To run MiniPIC:

Small Problem (10 x 10 x 10):

(dt = 0.1 / (1/7) = 0.7, tfinal = 1.0 / (1/7) = 7.0)

mpirun -np <# of ranks> ../src/main --kokkos-threads=<# of threads> \
	--dt=0.7 --tfinal=7.0

APEX Reference Problem (70 x 70 x 70):

(dt = 0.1 / 1.0 = 0.1, tfinal = 1.0 / 1.0 = 1.0)

mpirun -np <# of ranks> ../src/main --kokkos-threads=<# of threads> \
	--dt=0.1 --tfinal=1.0

(Note that these are the MiniPIC default parameters and so specifying them on the
run line is optional)

Grand Challenge (APEX Target Problem) (140 x 140 x 140):

(dt = 0.1 / 2 = 0.05, tfinal = 1.0 / 2 = 0.5)

mpirun -np <# of ranks> ../src/main --kokkos-threads=<# of threads> \
	--dt=0.05 --tfinal=0.5

For the default run performed on Edison the dt and tfinal parameters are not set
(default is used dt = 0.1, tfinal = 1.0).

== V.	Reporting Results ==

MiniPIC will print performance information to the standard output. The FOM for the 
benchmark is the updates/second value printed at the end of the run. This figure should
be provided in the Offeror response spreadsheet.
