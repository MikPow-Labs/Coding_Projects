// Vignere Cipher, can work on 1000 chars

#include <stdio.h>
#include <string.h>

int encrypt(int character, int keyCharacter){
    int value = character + keyCharacter - 1;
    return(value);
}

int decrypt(int character, int keyCharacter){
    int value = character - keyCharacter + 1;
    return(value);
}

char* cipher(char message[1000], char key[1000], int (*operation)(int, int)) {
    int lengthMessage = strlen(message);
    int lengthKey = strlen(key);
    static char newMessage[1000];
    int k = 0;
    int j = 0;
    int i;
    char character = 'a';
    for (i = 0; i < lengthMessage; i ++){
        int uppercase = 0;
        int character = (int) message[i];
        int keyCharacter = (int) key[j];
        int value = 0;
        if (character >= 65 && character <= 90){
            character = character - 64;
            uppercase = 1;
        } else if (character >= 97 && character <= 122){
            character = character - 96;
        } else {
            newMessage[i] = character;
            continue;
        }
        if (keyCharacter >= 65 && keyCharacter <= 90){
            keyCharacter = keyCharacter - 64;
            j += 1;
        } else if (keyCharacter >= 97 && keyCharacter <= 122){
            keyCharacter = keyCharacter - 96;
            j += 1;
        } 
        value = operation(character, keyCharacter);
        while (value > 26){
            value -= 26;
        }
        while (value < 1){
            value += 26;
        }
        switch (uppercase) {
            case (0):
                value += 96;
                break;
            case(1):
                value += 64;
                break;
            default:
                break;
        }
        if (j == lengthKey){
            j = 0;
        }
        newMessage[i] = (char) value;
    }
    newMessage[lengthMessage] = '\0';
    return(newMessage);
}
int main(){
    char message[1000];
    char key[1000];
    char function;
    printf("What is your message: \n");
    fgets(message, sizeof(message), stdin);
    size_t len = strlen(message);
    if (len > 0 && message[len-1] == '\n'){
        message[len-1] = '\0';
    } 
    printf("What is your key: \n");
    fgets(key, sizeof(key), stdin);
    len = strlen(key);
    if (len > 0 && key[len-1] == '\n'){
        key[len-1] = '\0';
    } 
    printf("Do you want to encrypt(E) or decrypt(D)?\n");
    scanf(" %c", &function);
    if (function == 'E'){
        char* encrypted = cipher(message, key, encrypt);
        printf("%s\n", encrypted);
    } else {
        char* decrypted = cipher(message, key, decrypt);
        printf("%s\n", decrypted);
    }
}