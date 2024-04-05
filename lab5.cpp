/*
File: lab5.cpp
Author: Jacob Wade Godwin
Class: CS 413-02
Term: Spring 2024
Date: 4/5/2024

Software Description: This program simulates the process of using a vending machine.
You input how much money you wish to using coins, and then choose what drink you want.

Run command lines:
1) as -o Lab4.o Lab4.s -g && gcc -o lab4 Lab4.o -g
2) ./lab4


Debug lines
3) gdb ./Lab4
*/
#include <iostream>
#include <fstream>

using namespace std;


int totalCoke = 2;
int totalSprite = 2;
int totalPepper = 2;
int totalZero = 2;

void inventory(int w, int x, int y, int z)
{
    cout << "Coke: " << w << endl;
    cout << "Sprite: " << x << endl;
    cout << "Dr. Pepper: " << y << endl;
    cout << "coke Zero: " << z << endl;
}

float inputCheck(float x, char c)
{
    switch (c)
    {
        case 'N': case 'n':
            x = x + .05;
            break;
        case 'D': case 'd':
            x = x + .10;
            break;
        case 'Q': case 'q':
            x = x + .25;
            break;
        case 'B': case 'b':
            x = x + 1;
            break;
        case 'I': case 'i':
            inventory(totalCoke, totalSprite, totalPepper, totalZero);
            break;
        default:
        cout << "incorrect input" << endl;
    }
    cout << "Money Inserted: $" << x << endl;
    return x;
}

float makeSelection(float x, char c)
{
    bool i = false;
    switch (c)
    {
        case 'C': case 'c':
            if (totalCoke == 0)
            {
                cout << "There is no more of this item. Please select something else" << endl;
                i = true;
                break;
            }
            x = x - .55;
            totalCoke--;
            cout << "Coke has been dispensed with $" << x << " in change." << endl;
            break;
        case 'S': case 's':
            if (totalSprite == 0)
            {
                cout << "There is no more of this item. Please select something else" << endl;
                i = true;
                break;
            }
            x = x - .55;
            totalSprite--;
            cout << "Dr. Pepper has been dispensed with $" << x << " in change." << endl;
            break;
        case 'P': case 'p':
            if (totalPepper == 0)
            {
                cout << "There is no more of this item. Please select something else" << endl;
                i = true;
                break;
            }
            x = x - .55;
            totalPepper--;
            cout << "Sprite has been dispensed with $" << x << " in change." << endl;
            break;
        case 'Z': case 'z':
            if (totalZero == 0)
            {
                cout << "There is no more of this item. Please select something else" << endl;
                i = true;
                break;
            }
            x = x - .55;
            totalZero--;
            cout << "Coke Zero has been dispensed with $" << x << " in change." << endl;
            break;
        case 'I': case 'i':
            inventory(totalCoke, totalSprite, totalPepper, totalZero);
            i = true;
            break;
        case 'X': case 'x':
            cout << "Selection canceled. $" << x << " in change returned." << endl;
            break;
        default:
        cout << "incorrect input" << endl;
    }
    if (i == true)
    {
        return x;
    }
    else
    {
        return 0;
    }
    
}

int main() {
    char input;
    float bank = 0;
    system("cls");


    cout << "Welcome to Mr. Zippy's soft drink vending machine.\nCost of Coke, Sprite, Dr. Pepper, and Coke Zero is 55 cents." << endl;

    while(true)
    {

        while(bank <= 0.54)
        {
            cout << "Enter money nickel (N), dime (D), quarter (Q), and one dollar bill (B)." << endl;
            cin >> input;
            bank = inputCheck(bank, input);

        }
        cout << "Make selection:\n(C) Coke, (S) Sprite, (P) Dr. Pepper, or (Z) Coke Zero (X) to cancel and return all money." << endl;
        cin >> input;
        bank = makeSelection(bank, input);
        if (totalCoke == 0 && totalSprite == 0 && totalPepper == 0 && totalZero == 0)
        {
            cout << "Machine empty, shutting down..." << endl;
            break;
        }
        
    }

}