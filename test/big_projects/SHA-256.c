#include <stdio.h>
#include <string.h>
#include <stdint.h>
#define ROTR(x, n) ((x >> n) | (x << (32 - n)))

uint8_t* encrypt(char message[1000], int* outLength){
    message[strcspn(message, "\n")] = '\0';
    int length = strlen(message);
    static uint8_t characters[2000];
    int i;
    unsigned long long bitLength = length * 8;
    memset(characters, 0, sizeof(characters)); 
    for (i = 0; i < length; i ++){
        characters[i] = (unsigned char) message[i];
    }
    characters[i++] = 0x80;
    while ((i % 64) != 56) {
        characters[i++] = 0x00;
    }
    for (int j = 0; j < 8; j++) {
        characters[i++] = (bitLength >> (8 * (7 - j))) & 0xFF;
    } 
    printf("%d\n", i);
    int blockNum = i/64;
    for (int j = 0;j < blockNum; j += 1){
        int offset = j * 64;
        uint32_t W[64];
        for (int w = 0; w < 16; w++){
            W[w] = ((uint32_t) characters[offset + w * 4] << 24) | ((uint32_t) characters[offset + w * 4 + 1] << 16) | ((uint32_t) characters[offset + w * 4 + 2] << 8)| ((uint32_t) characters[offset + w * 4 + 3]);
            printf("W[%d] = 0x%08x\n", w, W[w]);
        }
        for (int t = 16; t < 64; t++) {
            uint32_t s0 = (ROTR(W[t-15], 7)) ^ (ROTR(W[t-15], 18)) ^ (W[t-15] >> 3);
            uint32_t s1 = (ROTR(W[t-2], 17)) ^ (ROTR(W[t-2], 19)) ^ (W[t-2] >> 10);
            W[t] = (W[t-16] + s0 + W[t-7] + s1) & 0xFFFFFFFF;
        }
    }
    *outLength = i;
    return characters;
}

int main(){
    char message[1000];
    int length;
    printf("What is the message you want you encrypt?\n");
    fgets(message, sizeof(message), stdin);
    uint8_t* encrypted = encrypt(message, &length);
    for (int i = 0; i < length; i++){
        printf("0x%02X ", encrypted[i]);
    }
    printf("\n");
    return(0);
}