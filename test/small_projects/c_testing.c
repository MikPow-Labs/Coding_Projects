#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

int main() {
    char color[20];
    char pluralNoun[20];
    char celebrityF[20];
    char celebrityL[20];

    printf("Enter a color: ");
    fgets(color, 20, stdin);
    color[strcspn(color, "\n")] = 0;

    printf("Enter a plural noun: ");
    fgets(pluralNoun, 20, stdin);
    pluralNoun[strcspn(pluralNoun, "\n")] = 0;

    printf("Enter a celebrity first name: ");
    fgets(celebrityF, 20, stdin);
    celebrityF[strcspn(celebrityF, "\n")] = 0;

    printf("Enter a celebrity last name: ");
    fgets(celebrityL, 20, stdin);
    celebrityL[strcspn(celebrityL, "\n")] = 0;

    printf("Roses are %s\n", color);
    printf("%s are blue\n", pluralNoun);
    printf("I love %s %s\n", celebrityF, celebrityL);

    return 0;
}
/*
int main() {
    int luckyNumbers[] = {4, 7, 8, 16, 24};
    luckyNumbers[2] = 200;
    printf("%d\n", luckyNumbers[2]);
    return(0);
}
*/