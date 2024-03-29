/*=================================================================
 *
 * DOTDISC.C	Performs dot discrimination for dotdiscriminator.
 *  Part of the NelsonLabTools package
 *  2002-08-21, Steve Van Hooser, vanhoosr@brandeis.edu
 * The calling syntax is:
 *
 *		[T] = DOTDISC(YIN, DOTS_IN)
 *
 *  Look at the corresponding M-code, dotdisc.m, for help.
 *
 *=================================================================*/
#include <math.h>
#include "mex.h"

#define	Y_IN	prhs[0] 
#define DOTS_IN prhs[1]
#define	S_OUT	plhs[0]

#if !defined(MAX)
#define MAX(A, B)   ((A) > (B) ? (A) : (B))
#endif

#if !defined(MIN)
#define MIN(A, B)   ((A) < (B) ? (A) : (B))
#endif

static void dotdisc(double y[],int ylen,double *t[],size_t *numT,double dots[],
						int numdots)
{
	int ptsgood=0,i,j,m,earlydot=0,latedot=0,off,sg;
	double *T,thresh;

	T = 0;
    
	/* to avoid detecting dots that are too close to the data edges, check the span of the dots */
	for (i=0;i<numdots;i++) {
		if (dots[i*3+2]<earlydot) earlydot = (int) dots[i*3+2];
		if (dots[i*3+2]>latedot) latedot = (int) dots[i*3+2];
		/*mexPrintf("Dot %d: %g %g %g\n",i,dots[i*3+0],dots[i*3+1],dots[i*3+2]);*/
	}

	/*mexPrintf("Early and late dot:  %d,%d\n",earlydot,latedot);*/

	*numT = 0;

	for (i=-earlydot;i<(ylen-latedot);i++) { /* avoid window edge problems */
		m=1;
		for (j=0;m&(j<numdots);j++) { /* see if we have a dot match */
			/* note: thresh=dots[j*3+0];sg=(int)dots[j*3+1];off=(int)dots[j*3+2];*/
			if (dots[j*3+1]>0) m=m&(y[i+(int)dots[j*3+2]]>dots[j*3+0]);
			else m=m&(y[i+(int)dots[j*3+2]]<dots[j*3+0]);
		}
		if ((m==0)&(ptsgood>0)) {
			(*numT)++;
			T = (double *)realloc(T,(*numT)*sizeof(double));
			T[(int)(*numT)-1] = ceil(i-((double)ptsgood/2.0));
			ptsgood = 0;
		} else {if (m==1) { ptsgood = ptsgood+1; }}
	}
	*t = T;
}

void mexFunction( int nlhs, mxArray *plhs[], 
		  int nrhs, const mxArray*prhs[] )
     
{ 
#if MX_HAS_INTERLEAVED_COMPLEX
    mxDouble *y, *dots;
    mxDouble *t,*newt;
#else
    double *y,*dots; 
	double *t,*newt;
#endif
	size_t numdots, numY, numT;
    int i;
    
	/* this is an internal function...let's dispense with argument checking*/

#if MX_HAS_INTERLEAVED_COMPLEX
    dots = mxGetDoubles(DOTS_IN); y = mxGetDoubles(Y_IN);
#else
    dots=mxGetPr(DOTS_IN); y=mxGetPr(Y_IN);
#endif
    
	numY = MAX(mxGetM(Y_IN),mxGetN(Y_IN));
	numdots=mxGetM(DOTS_IN);
	/*mexPrintf("Number of dots: %d\n",numdots);*/
	/*mexPrintf("Size of y: %d\n",numY);*/
	dotdisc(y,numY,&t,&numT,dots,numdots); 
	/*mexPrintf("Done with dotdisc.\n");*/
	/* Create a matrix for the return argument */ 
	S_OUT = mxCreateDoubleMatrix(numT, 1, mxREAL); 
#if MX_HAS_INTERLEAVED_COMPLEX
    newt = mxGetDoubles(S_OUT);
#else
    newt = mxGetPr(S_OUT);
#endif

	/* copy the data into the new matrix */
	for (i=0;i<numT;i++) {newt[i]=t[i];}
	free(t);
}
