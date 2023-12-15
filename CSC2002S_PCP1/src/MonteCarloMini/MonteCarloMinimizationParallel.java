package MonteCarloMini;

/**A parallel version of MonteCarloMinimization using the Java Fork/Join framework
 * Rector Ratsaka 
 * RTSREC001
 * 6 August 2023
 */

import java.util.Random;
import java.util.concurrent.ForkJoinPool;
import java.util.concurrent.RecursiveTask;

class MonteCarloMinimizationParallel extends RecursiveTask<Integer>{
	static final boolean DEBUG=false;

	static long startTime = 0;
	static long endTime = 0;
	 
	//variables for parallel implementation
	int lo;
	int hi;
	SearchParallel[] searches;
	static final int SEQUENTIAL_CUTOFF=5000;
	 static int min = Integer.MAX_VALUE;
	 static int finder;


	public MonteCarloMinimizationParallel(SearchParallel[] s, int l, int h){
		this.searches=s; this.lo=l; this.hi=h;
	}

	//timers - note milliseconds
	private static void tick(){
		startTime = System.currentTimeMillis();
	}
	private static void tock(){
		endTime=System.currentTimeMillis(); 
	}
    
	//responsible for performing a parallelized minimization search using the Monte Carlo method using the initialized searches array
	protected Integer compute() {
		if ((hi - lo) < SEQUENTIAL_CUTOFF) {
			int localMin = Integer.MAX_VALUE;
			for (int i = lo; i < hi; i++) {
				localMin = searches[i].find_valleys();
				if ((!searches[i].isStopped()) && (localMin < min)) {
					min=localMin;
					finder=i;
				}
				if (DEBUG) System.out.println("Search " + searches[i].getID() + " finished at " + localMin + " in " + searches[i].getSteps());
			}
			return min;
		} else {
			MonteCarloMinimizationParallel left = new MonteCarloMinimizationParallel(searches, lo, (hi + lo) / 2);
			MonteCarloMinimizationParallel right = new MonteCarloMinimizationParallel(searches, (hi + lo) / 2, hi);
			left.fork();
			int rightAns = right.compute();
			int leftAns = left.join();
			return Math.min(leftAns, rightAns);
		}
	}
        //utilizes the pool to perform parallel computation using the Fork-Join framework
		static final ForkJoinPool fjPool = new ForkJoinPool();
		static int minMethod(SearchParallel[] arr){
		return fjPool.invoke(new MonteCarloMinimizationParallel(arr,0,arr.length));
		}


    public static void main(String[] args)  {

    	int rows, columns; //grid size
    	double xmin, xmax, ymin, ymax; //x and y terrain limits
    	TerrainArea terrain;  //object to store the heights and grid points visited by searches
    	double searches_density;	// Density - number of Monte Carlo  searches per grid position - usually less than 1!

     	int num_searches;		// Number of searches
    	SearchParallel [] searches;		// Array of searches
    	Random rand = new Random();  //the random number generator
    	
    	if (args.length!=7) {  
    		System.out.println("Incorrect number of command line arguments provided.");   	
    		System.exit(0);
    	}
    	/* Read argument values */
    	rows =Integer.parseInt( args[0] );
    	columns = Integer.parseInt( args[1] );
    	xmin = Double.parseDouble(args[2] );
    	xmax = Double.parseDouble(args[3] );
    	ymin = Double.parseDouble(args[4] );
    	ymax = Double.parseDouble(args[5] );
    	searches_density = Double.parseDouble(args[6] );
  
    	if(DEBUG) {
    		/* Print arguments */
    		System.out.printf("Arguments, Rows: %d, Columns: %d\n", rows, columns);
    		System.out.printf("Arguments, x_range: ( %f, %f ), y_range( %f, %f )\n", xmin, xmax, ymin, ymax );
    		System.out.printf("Arguments, searches_density: %f\n", searches_density );
    		System.out.printf("\n");
    	}
    	
    	// Initialize 
    	terrain = new TerrainArea(rows, columns, xmin,xmax,ymin,ymax);
    	num_searches = (int)( rows * columns * searches_density );
    	searches= new SearchParallel [num_searches];
    	for (int i=0;i<num_searches;i++) 
    		searches[i]=new SearchParallel(i+1, rand.nextInt(rows),rand.nextInt(columns),terrain);
    	
      	if(DEBUG) {
    		/* Print initial values */
    		System.out.printf("Number searches: %d\n", num_searches);
    		//terrain.print_heights();
    	}
    	
    	//start timer
    	tick();
    	
		int minimum = minMethod(searches);
    	
   		//end timer
   		tock();
   		
    	if(DEBUG) {
    		/* print final state */
    		terrain.print_heights();
    		terrain.print_visited();
    	}
    	
		System.out.printf("Run parameters\n");
		System.out.printf("\t Rows: %d, Columns: %d\n", rows, columns);
		System.out.printf("\t x: [%f, %f], y: [%f, %f]\n", xmin, xmax, ymin, ymax );
		System.out.printf("\t Search density: %f (%d searches)\n", searches_density,num_searches );

		/*  Total computation time */
		System.out.printf("Time: %d ms\n",endTime - startTime );
		int tmp=terrain.getGrid_points_visited();
		System.out.printf("Grid points visited: %d  (%2.0f%s)\n",tmp,(tmp/(rows*columns*1.0))*100.0, "%");
		tmp=terrain.getGrid_points_evaluated();
		System.out.printf("Grid points evaluated: %d  (%2.0f%s)\n",tmp,(tmp/(rows*columns*1.0))*100.0, "%");
	
		/* Results*/
		System.out.printf("Global minimum: %d at x=%.1f y=%.1f\n\n", minimum, terrain.getXcoord(searches[finder].getPos_row()), terrain.getYcoord(searches[finder].getPos_col()) );

				
    	
    }
}