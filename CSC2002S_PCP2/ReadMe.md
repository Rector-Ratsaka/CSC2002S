Club Simulation
August 2023

This 'read me' describes how to run ClubSimulation.java program.

You will need:
*Java Development Kit(JDK)
*Make
to compile and run the program.

Steps:
1.Open a terminal or command prompt in the project directory.
2.Run the following command to compile the program using the Makefile:
  make
3.To run compiled program:
  make run ARGS="args[0] args[1] args[2] args[3]"

-where:
    noClubgoers=args[0]);  //total people to enter room
    gridX=args[1]); // No. of X grid cells
    gridY=args[2]); // No. of Y grid cells
    max=args[3]);  // max people allowed in club

    e.g.
      make run ARGS="300 15 15 100"

by
Rector Ratsaka (RTSREC001)
