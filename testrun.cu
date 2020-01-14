#include <stdio.h>
#include <stdlib.h>

__global__ void add(int *a, int *b, int *c) {
	c[blockIdx.x] = a[blockIdx.x] + b[blockIdx.x];
	printf("hello ");
}


#define N 512
int main(void) {
	
	int *a, *b, *c;
	int *d_a, *d_b, *d_c;
	int size = N*sizeof(int);
	
	// host copies of a, b, c
	// device copies of a, b, c
	// Allocate space for device copies of a, c, b
	cudaMalloc((void **)&d_a, size);
	cudaMalloc((void **)&d_b, size);
	cudaMalloc((void **)&d_c, size);
	
	// Setup input values
	a = (int *) malloc(size);
	b = (int *) malloc(size);

	for(int i=0; i<N; i++){
		a[i]=rand()%10;
		b[i]=rand()%10;
	}
	c = (int *) malloc(size);

	// Copy inputs to device
	cudaMemcpy(d_a, a, size, cudaMemcpyHostToDevice);
	cudaMemcpy(d_b, b, size, cudaMemcpyHostToDevice);
	
	// Launch add() kernel on GPU
	add<<<N,1>>>(d_a, d_b, d_c);
	
	// Copy result back to host
	cudaMemcpy(c, d_c, size, cudaMemcpyDeviceToHost);
	
	for(int i=0; i<10; i++){
		printf("Executed: %d + %d = %d\n", a[i], b[i], c[i]);
	}

	// Cleanup
	free(a); free(b); free(c);
	cudaFree(d_a); cudaFree(d_b); cudaFree(d_c);
	
	

	return 0;
}