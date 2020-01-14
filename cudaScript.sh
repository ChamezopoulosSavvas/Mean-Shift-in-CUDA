#!/bin/bash

SOURCE=cuda_impl

cp $SOURCE.c $SOURCE.cu

nvcc $SOURCE.cu -lm -o $SOURCE.out

echo -n "Enter problem SIZE, DIMSIZE, RANGE > "
read input

./$SOURCE.out $input

rm $SOURCE.cu