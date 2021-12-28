# pStrings Project 
Assembly implementation of basic pString functions.
A project from Computer Structure course in my second year at Bar-Ilan university

## Abstract
We were assigned a task to implement basic functions regarding pStrings in the assembly language, as described in pstring.h:
* char pstrlen(Pstring* pstr) - return the length of a pString
* Pstring* replaceChar(Pstring* pstr, char oldChar, char newChar) - replace every occourance of the oldChar in the pString with the newChar given.
* Pstring* pstrijcpy(Pstring* dst, Pstring* src, char i, char j) - given a range, copy the the content of src to dst.
* Pstring* swapCase(Pstring* pstr) - itterate through the pString and change upper case letter to lower case, and vise verca, whilst ignoring non-letter characters.
* int pstrijcmp(Pstring* pstr1, Pstring* psrt2, char i, char j) - in a given range, determine the lexical relation between two pString.

In this project we used GAS/AT&T x86 Assembly.
# pString Structure Defenition
'''c
typedef struct{
    char size;
    char strign[255];
}pString;
'''

## Project Files
# run_main.s
The engine of the project. We are reciveing two pStrings from the user, allocating memory on the stack frame.
Also we scan an int from the user, which will be used as a case for our switch case implementation in func_select.s

The function passes as parameters pointers to each pString and to the choice scaned from the user.
# func_select.s
Implementation of switch case using a jump table.
First we make sure to clear the offset between the user's choice and the cases on the jump table (In our case an off set of 50).

Each choice from the user can result in two outcomes: invoking a proper function from pstring.s or a default case which will print the prompt 'invalid option!'

# pstring.s
Assembly implementation of the functions declared in pstring.h file
