#include <stdio.h>
#include <string.h>
#include <stdint.h>

uint8_t* encrypt(char message[1000], int* outLength){
    message[strcspn(message, "\n")] = '\0';
    int length = strlen(message);
    static uint8_t characters[2000];
    int i;
    unsigned long long bitLength = length * 8; 
    for (i = 0; i < length; i ++){
        characters[i] = (unsigned char) message[i];
    }
    characters[i] = 0x80;
    i += 1;
    if (i + 8 > 56){
        int j = i - 56;
        while (j%64 < 56){
            characters[i + j++] = 0x00;
        }
    } else {
        while (i%64 < 56){
            characters[i++] = 0x00;
        }
    }
    for (int j = 0; j < 8; j++) {
    characters[i + j] = (bitLength >> (8 * (7 - j))) & 0xFF;
    }
    i += 8; 
    printf("%d\n", i);
    int blockNum = i/64;
    for (int j = 0;j < blockNum; j += 1){
        int offset = j * 64;
        for (int w = 0; w < 16; w++){
            uint32_t word = ((uint32_t) characters[offset + w * 4] << 24) | ((uint32_t) characters[offset + w * 4 + 1] << 16) | ((uint32_t) characters[offset + w * 4 + 2] << 8) | (uint32_t) (characters[offset + w * 4 + 3]);
            printf("0x%08x\n", word);
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