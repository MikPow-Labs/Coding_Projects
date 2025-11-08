#include <stdio.h>

double power(double a, double b){
    int i;
    double c;
    c = a;
    for (i = 1; i < b; i++) {
        a *= c;
    }
    return(a);
}

void main(){
    double numb1;
    double numb2;
    char operator;
    double result;
    printf("Input your first number: ");
    scanf("%lf", &numb1);
    printf("Input your second number: ");
    scanf("%lf", &numb2);
    printf("Enter your operation: ");
    scanf(" %c", &operator);
    result = power(numb1, numb2);
    switch (operator){
        case '+':
            printf("%lf %c %lf = %lf\n", numb1, operator, numb2, numb1 + numb2);
            break;
        case '^':
            printf("%lf %c %lf = %lf\n", numb1, operator, numb2, result);
            break;
        case '*':
            printf("%lf %c %lf = %lf\n", numb1, operator, numb2, numb1 * numb2);
            break;
        case '-':
            printf("%lf %c %lf = %lf\n", numb1, operator, numb2, numb1 - numb2);
            break;
        case '/':
            printf("%lf %c %lf = %lf\n", numb1, operator, numb2, numb1 - numb2);
            break;
    };
}