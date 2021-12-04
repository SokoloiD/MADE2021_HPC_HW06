#include <stdint.h>


#define STB_IMAGE_IMPLEMENTATION
#include "stb_image.h"

#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb_image_write.h"

__global__ void matrixFilter(uint8_t* srcImage, uint8_t* dstImage, int w, int h, size_t size, int dw, int  dh, uint8_t * filter){

    int globalIdx = 0, x,y, summ;
    globalIdx  = threadIdx.z * blockDim.x * blockDim.y + threadIdx.y * blockDim.x + threadIdx.x;
    globalIdx += (blockIdx.z * gridDim.x * gridDim.y + blockIdx.y * gridDim.x + blockIdx.x) * blockDim.x * blockDim.y*blockDim.z;
    int hIdx =  globalIdx / (w / dw);
    int wIdx =  globalIdx % (w / dw);
    for(int i=0; i< dw; ++i){
        x = dw * wIdx + i;
        if (x > w){
            continue;
        }
        for(int j =0; j < dh; j++){
            y = dh* hIdx + j;
            if (y > h){
                continue;
            }
            summ = 0;

            for(int k=-2;k<=2; k++){
                for(int l=-2; l<=2; l++){

                    summ += srcImage[ x + k +  (y + l) * w] * filter[2 + k + (2 +l) *5];                
                }
            dstImage[x + y * w] = summ /25;
            }
        }
    }

}

int main() {
    int width, height, bpp;

    uint8_t* h_grayImage = stbi_load("../data/lena_gray.png", &width, &height, &bpp, 1);
    size_t imageSize = height * width * sizeof(uint8_t);



    uint8_t * h_newImage = (uint8_t *) malloc(imageSize);
    uint8_t * h_filter = (uint8_t *) malloc(25 * sizeof(uint8_t));
    uint8_t* d_grayImage;
    uint8_t* d_newImage;
    uint8_t* d_filter;
    cudaMalloc(&d_grayImage, imageSize);
    cudaMalloc(&d_newImage, imageSize);
    cudaMalloc(&d_filter, 25 * sizeof(uint8_t));


    int gridCnt = 4;
    int dw = width / gridCnt;
    int dh = height/ gridCnt;

    // Фильтр усиления контуров
    for( int i = 0; i< 25; ++i){
        h_filter[i]=1;
    }
    h_filter[12]=0;

    cudaMemcpy(d_filter, h_filter, 25, cudaMemcpyHostToDevice);
    cudaMemcpy(d_grayImage, h_grayImage, imageSize, cudaMemcpyHostToDevice);

    matrixFilter<<<1, 16>>>(d_grayImage, d_newImage, width, height, imageSize, dw, dh, d_filter );      
    cudaDeviceSynchronize();

    cudaMemcpy(h_newImage, d_newImage, imageSize, cudaMemcpyDeviceToHost);
    


    stbi_write_png("../data/lena_123.png", width, height, 1, h_newImage, width*1);

    stbi_image_free(h_grayImage);
    free(h_newImage);
    free(h_filter);

 
    cudaFree(d_filter);
    cudaFree(d_grayImage);
    cudaFree(d_newImage);

    return 0;
}