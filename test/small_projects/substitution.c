// Vignere Cipher, can work on 100 chars w/ spaces as _

#include <stdio.h>
#include <string.h>

char* encrypt(char message[100], char key[100]) {
    int lengthMessage = strlen(message);
    int lengthKey = strlen(key);
    static char newMessage[100];
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
        value = character + keyCharacter - 1;
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
    char message[100];
    char key[100];
    printf("What is your message: \n");
    scanf("%99s", message);
    printf("What is your key: \n");
    scanf("%99s", key);
    char* encrypted = encrypt(message, key);
    printf("%s\n", encrypted);
}