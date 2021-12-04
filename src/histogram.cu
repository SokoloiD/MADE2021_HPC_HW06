#include <stdint.h>


#define STB_IMAGE_IMPLEMENTATION
#include "stb_image.h"

#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb_image_write.h"

__global__ void calcHistogram(uint8_t* srcImage, double * resultHistogram, size_t size, size_t chunk_cnt){

    int globalIdx = 0;
    globalIdx  = threadIdx.z * blockDim.x * blockDim.y + threadIdx.y * blockDim.x + threadIdx.x;
    globalIdx += (blockIdx.z * gridDim.x * gridDim.y + blockIdx.y * gridDim.x + blockIdx.x) * blockDim.x * blockDim.y*blockDim.z;

    double localHistogram[255];
    for (size_t i = 0; i < 255; ++i){
        localHistogram[i] = 0.;
    }

    size_t chunkSize = size / chunk_cnt;
    size_t startIdx = chunkSize * globalIdx;
    size_t endtIdx = startIdx + chunkSize;
    if (endtIdx > size){
        endtIdx = size;
    } 
    //printf(" %d \t %d \t %d\n",(int)globalIdx, (int)startIdx, (int)endtIdx);
    for(size_t i = startIdx; i < endtIdx; ++i){
        localHistogram[srcImage[i]] += 1.;
    }

    for(size_t i = 0; i < 255; ++i){
        atomicAdd(&resultHistogram[i], localHistogram[i]);

    }
}

int main() {
    int width, height, bpp;

    uint8_t* h_grayImage = stbi_load("../data/lena_gray_noise.png", &width, &height, &bpp, 1);
    size_t imageSize = height * width * sizeof(uint8_t);



    double * h_histogram= (double *) malloc(255 * sizeof(double));
    for (size_t i =0; i< 255; ++i){
        h_histogram[i] = 0.;

    }


 
    uint8_t* d_grayImage;
    double * d_histogram;
 
    cudaMalloc(&d_grayImage, imageSize);
    cudaMalloc(&d_histogram, 255 * sizeof(double));
 

 
    cudaMemcpy(d_grayImage, h_grayImage, imageSize, cudaMemcpyHostToDevice);
    cudaMemcpy(d_histogram, h_histogram, 255 * sizeof(double), cudaMemcpyHostToDevice);

    calcHistogram<<<1, 16>>>(d_grayImage, d_histogram, imageSize, 16);      
    cudaDeviceSynchronize();    
    
    cudaMemcpy(h_histogram, d_histogram, 255 * sizeof(double), cudaMemcpyDeviceToHost);
    

    stbi_image_free(h_grayImage);


    double histSumm = 0.;
    for (size_t i =0; i< 255; ++i){
        histSumm += h_histogram[i];

    }

    printf(" color \t normalized value\n");

    for (size_t i =0; i< 255; ++i){
        h_histogram[i] /= histSumm;
        printf("color %d \t %f\n", (int)i, h_histogram[i]);

    }

    free(h_histogram); 

 
    cudaFree(d_grayImage);
    cudaFree(d_histogram);  
 

    return 0;
}