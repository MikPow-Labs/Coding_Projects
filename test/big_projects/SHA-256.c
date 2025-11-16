#include <stdio.h>
#include <string.h>
#include <stdint.h>

int* encrypt(char message[1000]){
    message[strcspn(message, "\n")] = '\0';
    int length = strlen(message);
    static int characters[2000];
    int i;
    unsigned long long bitLength = length * 8; 
    for (i = 0; i < length; i ++){
        characters[i] = (unsigned char) message[i];
    }
    characters[i] = 0x80;
    i += 1;
    while (i%64 < 56){
        characters[i++] = 0x00;
    }
    for (int j = 0; j < 8; j++) {
    characters[i + j] = (bitLength >> (8 * (7 - j))) & 0xFF;
    }
    i += 8; 
    characters[i] = -1;
    for (int j = 0; j < 32; j ++){
        for (int w = 0; w < 16; w++){
            uint32_t word = (characters[w*4] << 24) | (characters[w*4+1] << 16) | (characters[w*4+2] << 8) | (characters[w*4+3]);
            if (w == 0){
                printf("0x%02x\n", word);
            }
        }
    }
    return characters;
}

int main(){
    char message[1000];
    printf("What is the message you want you encrypt?\n");
    fgets(message, sizeof(message), stdin);
    int* encrypted = encrypt(message);
    for (int i = 0; encrypted[i] != -1; i++){
        printf("0x%02X ", encrypted[i]);
    }
    printf("\n");
    return(0);
}

