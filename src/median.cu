#include <stdint.h>


#define STB_IMAGE_IMPLEMENTATION
#include "stb_image.h"

#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb_image_write.h"

__global__ void medianFilter(uint8_t* srcImage, uint8_t* dstImage, int w, int h, size_t size, int dw, int  dh){

    int globalIdx = 0, x,y;
    globalIdx  = threadIdx.z * blockDim.x * blockDim.y + threadIdx.y * blockDim.x + threadIdx.x;
    globalIdx += (blockIdx.z * gridDim.x * gridDim.y + blockIdx.y * gridDim.x + blockIdx.x) * blockDim.x * blockDim.y*blockDim.z;
    int hIdx =  globalIdx / (w / dw);
    int wIdx =  globalIdx % (w / dw);
    uint8_t filterBuffer[25];
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
 
            // заполняем фильтр
            for(int k=-2;k<=2; k++){
                for(int l=-2; l<=2; l++){

                    filterBuffer[2 + k + (2 +l) *5] = srcImage[ x + k +  (y + l) * w]; 
        
                }
            // абы как (пузырьком) сортируем
            uint8_t tmp;        
            for(int k = 0; k < 25; ++k){
                for(int l = 0; l < 25 - k; ++l){
                    if (filterBuffer[l] < filterBuffer[l + 1]){
                        tmp = filterBuffer[l];
                        filterBuffer[l] =  filterBuffer[l + 1];
                        filterBuffer[l + 1] = tmp;
                    }

                }
            }




            dstImage[x + y * w] = filterBuffer[12];
            }
        }
    }

}

int main() {
    int width, height, bpp;

    uint8_t* h_grayImage = stbi_load("../data/lena_gray_noise.png", &width, &height, &bpp, 1);
    size_t imageSize = height * width * sizeof(uint8_t);



    uint8_t * h_newImage = (uint8_t *) malloc(imageSize);
 
    uint8_t* d_grayImage;
    uint8_t* d_newImage;
 
    cudaMalloc(&d_grayImage, imageSize);
    cudaMalloc(&d_newImage, imageSize);
  


    int gridCnt = 4;
    int dw = width / gridCnt;
    int dh = height/ gridCnt;

 

 
    cudaMemcpy(d_grayImage, h_grayImage, imageSize, cudaMemcpyHostToDevice);
    medianFilter<<<1, 16>>>(d_grayImage, d_newImage, width, height, imageSize, dw, dh);      
    cudaMemcpy(h_newImage, d_newImage, imageSize, cudaMemcpyDeviceToHost);
    


    stbi_write_png("../data/lena_gray_median.png", width, height, 1, h_newImage, width*1);

    stbi_image_free(h_grayImage);
    free(h_newImage);
 

    cudaDeviceSynchronize();
 
    cudaFree(d_grayImage);
    cudaFree(d_newImage);

    return 0;
}