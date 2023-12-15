Monte Carlo Minimization.
August 2023

This 'read me' describes how to run MonteCarloMinimizationParallel.java program.

You will need:
*Java Development Kit(JDK)
*Make
to compile and run the program.

Steps:
1.Open a terminal or command prompt in the project directory.
2.Run the following command to compile the program using the Makefile:
  make
3.To run compiled program:
  make run ARGS="args[0] args[1] args[2] args[3] args[4] args[5] args[6]"

-where:
  rows = args[0]
  columns = args[1] 
  xmin = args[2] 
  xmax = args[3] 
  ymin = args[4] 
  ymax = args[5] 
  searches_density = args[6] 

e.g. 
  make run ARGS="10000 10000 -5000 5000 -5000 5000 0.05"

by
Rector Ratsaka(RTSREC001)
