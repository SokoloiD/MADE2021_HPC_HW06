#include <stdint.h>

#define STB_IMAGE_IMPLEMENTATION
#include "stb_image.h"

#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb_image_write.h"

int main() {
    int width, height, bpp;

    uint8_t* h_grayImage = stbi_load("../data/lena_gray.png", &width, &height, &bpp, 1);
    size_t imageSize = height * width * sizeof(uint8_t);



    uint8_t* h_newImage = malloc(imageSize);
    uint8_t* d_grayImage;
    uint8_t* d_newImage;
    cudaMalloc(&d_grayImage, imageSize);
    cudaMalloc(&d_newImage, imageSize);


    

    stbi_write_png("../data/lena_123.png", width, height, 1, h_newImage, width*1);

    stbi_image_free(h_grayImage);
    free(h_newImage);

    cudaDeviceSyncronize();
    cudaFree(d_grayImage);
    cudaFree(d_newImage);

    return 0;
}