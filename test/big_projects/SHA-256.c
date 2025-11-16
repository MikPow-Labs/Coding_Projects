#include <stdio.h>
#include <string.h>

int* encrypt(char message[1000]){
    int length = strlen(message);
    static int characters[2000];
    for (int i = 0; i < length; i ++){
        characters[i] = (unsigned char) message[i];
    }
    return characters;
}

int main(){
    char message[1000];
    printf("What is the message you want you encrypt?\n");
    fgets(message, sizeof(message), stdin);
    int* encrypted = encrypt(message);
    for (int i = 0; encrypted[i] != 10; i++){
        printf("%d", encrypted[i]);
    }
    printf("\n");
    return(0);
}

