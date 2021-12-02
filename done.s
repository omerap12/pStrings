.data

  .section  .rodata
format_for_int: .string "%d"
format_for_string: .string "%s"
end_character:    .string "\0"
case_50_60: .string "first pstring length: %d, second pstring length: %d\n"
error:  .string "invalid option!\n"
format_for_char:    .string "%c"
case52_oldchar: .string "old char: %c, "
case52_newchar: .string "new char: %c, "
case52_firststring: .string "first string: %s, "
case52_secondstring:    .string "second string: %s\n"
case53_invalid_input:   .string "invalid input!\n"
case53_print_length:    .string "length: %d, "
case53_print_string:    .string "string: %s\n"
case55_print_result:    .string "compare result: %d\n"


.text
.global main
main:
    movq %rsp, %rbp #for correct debugging
    pushq %rbp
    movq  %rsp, %rbp
    subq  $528, %rsp # allocating 256*2 + 8*2 for the two Pstrings 
    push  %r13 # the first Pstring
    push  %r12 # the second Pstring
    xorq  %rax, %rax
    
    # getting first number and Pstring
    movq  $format_for_int, %rdi  # first argument to scanf
    leaq  -536(%rbp), %rsi  # second argument
    xor   %rax, %rax
    call  scanf
    leaq  -528(%rbp), %r13 # for the scanf string
    addq  $1, %r13    # add 1 for string len
   
    movq  $format_for_string, %rdi # first argument for scanf 
    movq  %r13, %rsi # second argument for scanf 
    xor   %rax, %rax
    call  scanf
    mov   -536(%rbp), %eax # getting the length of the Pstring put it in eax
    mov   %al, -528(%rbp) #puting string lenght in the start of the string
    
    # getting second number and Pstring
    movq  $format_for_int, %rdi  # first argument to scanf
    leaq  -536(%rbp), %rsi  # second argument
    xor   %rax, %rax
    call  scanf
    leaq -272(%rbp), %r12 # for the scanf string
    addq $1, %r12 # add 1 for string len
    
    movq  $format_for_string, %rdi # first argument for scanf 
    movq  %r12, %rsi # second argument for scanf 
    xor %rax, %rax
    call scanf
    mov   -536(%rbp), %eax # getting the length of the Pstring put it in eax
    mov   %al, -272(%rbp) #puting string lenght in the start of the string
    
    # getting the option
    movq $format_for_int, %rdi # first argument to scanf
    leaq -8(%rbp), %rsi # second argument
    xor %rax, %rax
    call scanf
    mov -8(%rbp), %rdi # first argument for run_func
    
    # intilliaze run_func
    mov %r13, %rsi # getting the first pstring
    mov %r12, %rdx # getting the second pstring
    
    call run_func
    
    xor %rax,%rax
    pop %r12
    pop %r13
    addq $536, %rsp
    mov %rbp, %rsp
    pop %rbp
    xor %rax, %rax
    
    
    ret


run_func:
    leaq -60(%rdi), %rsi # compute x = x-60
    cmpq $0, %rsi # compare x == 0
    je .case50_60
    addq $60, %rsi # return x to original size
    leaq -50(%rdi), %rsi # compute x = x - 60
    cmpq $0, %rsi # compare x == 0
    je .case50_60
    cmpq $2, %rsi # compare x == 2
    je .case52
    cmpq $3, %rsi # compare x == 0
    je .case53
    cmpq $4, %rsi # compare x == 0
    je .case54
    cmpq $5, %rsi # compare x == 0    
    je .case55
    jmp .error
    

.case50_60:
    leaq -1(%r13), %rdi # for the first string
    xor %rax, %rax
    call pstrlen 
    mov %rax, %r11 # saving the length of the first string
    xor %rax, %rax
    leaq -1(%r12), %rdi # for the second pstring
    call pstrlen
    mov %rax, %r10 # saving the length
    mov $case_50_60, %rdi
    mov %r11, %rsi
    mov %r10, %rdx
    xor %rax, %rax
    call printf
    xor %rax, %rax
    ret

 
 .case52:
    push %rbp
    mov %rsp, %rbp
    sub $16, %rsp 
    push %r14 # for the old char
    push %r15 # for the new char
    
    # getting the old char
    leaq -8(%rbp), %rsi # allocating memory for the char
    xor %rax, %rax
    movq $format_for_string, %rdi # first argument for scanf
    call scanf
    movzbq -8(%rbp), %r14 # save the old char in r14
    
    # getting the new char
    leaq -16(%rbp), %rsi # allocating memory for the char
    xor %rax, %rax
    movq $format_for_string, %rdi # first argument for scanf
    call scanf
    movzbq -16(%rbp), %r15 # save the old char in r14
    
    # call replaceChar for string 1
    mov %r13, %rsi # first argument (*pstring)
    mov %r14, %rdi # second argument (char oldChar)
    mov %r15, %rdx # third argument (char newChar)
    xor %rax,%rax
    call replaceChar
    
    #call replaceChar for string 2
    mov %r12, %rsi # first argument (*pstring)
    mov %r14, %rdi # second argument (char oldChar)
    mov %r15, %rdx # third argument (char newChar)
    xor %rax,%rax
    call replaceChar
    
    # printing old char
    xor %rax, %rax
    mov $case52_oldchar, %rdi
    movb %r14b, %sil
    call printf
    
    #printing the new char
    xor %rax, %rax
    mov $case52_newchar, %rdi
    movb %r15b, %sil
    call printf
    
    #printing the first string
    xor %rax, %rax
    mov $case52_firststring, %rdi
    mov %r13, %rsi
    call printf
    
    #printing the second string
    xor %rax, %rax
    mov $case52_secondstring, %rdi
    mov %r12, %rsi
    call printf
    
    
    # free memory
    pop %r15
    pop %r14
    addq $16, %rsp
    mov %rsp, %rbp
    pop %rbp
    ret
    
    
    
.case53:
    push %rbp
    mov %rsp, %rbp
    sub $16, %rsp 
    push %r14 # for start index
    push %r15 # for stop index
    
   # getting the start index
    leaq -8(%rbp), %rsi # allocating memory for the start int
    xor %rax, %rax
    movq $format_for_int, %rdi # first argument for scanf
    call scanf
    movzbq -8(%rbp), %r14 # save the start int r14
    
    # getting the stop index char
    leaq -16(%rbp), %rsi # allocating memory for the char
    xor %rax, %rax
    movq $format_for_int, %rdi # first argument for scanf
    call scanf
    movzbq -16(%rbp), %r15 # save the stop index %r14
    
    
    #moving parametrs to psrijcpy
    xor %rax, %rax
    xor %rdx, %rdx
    xor %rcx, %rcx
    
    mov %r13, %rsi # moving second string to rdi
    mov %r12, %rdi # moving first string to rsi
    mov %r14, %rdx # moving i index to rdx
    mov %r15, %rcx # moving j index to rcx
    
    call psrijcpy
    
    # check if error occur
    cmp $-2, %r9
    je .errorInCase53
    jmp .regular
    
.regular: 
    xor %rax,%rax
    leaq -1(%r13), %rdi
    call pstrlen # getting the length of the first string
    mov %rax, %rsi # put length of string into rsi
    xor %rax,%rax
    movq $case53_print_length, %rdi
    call printf
    
    # printing dest string
    xor %rax, %rax
    movq $case53_print_string, %rdi 
    mov %r13, %rsi
    call printf
    
    # printing the dest length 
    xor %rax,%rax
    leaq -1(%r12), %rdi
    call pstrlen # getting the length of the first string
    mov %rax, %rsi # put length of string into rsi
    xor %rax,%rax
    movq $case53_print_length, %rdi
    call printf
    
    # printing dest string
    xor %rax, %rax
    movq $case53_print_string, %rdi 
    mov %r12, %rsi
    call printf
    pop %r15
    pop %r14
    addq $16, %rsp
    mov %rsp, %rbp
    pop %rbp
    ret
    
.errorInCase53:
    xor %rax, %rax
    movq $case53_invalid_input, %rdi
    call printf
    jmp .regular

.invalidInput:
    
    xor %rax, %rax
    mov $case53_invalid_input ,%rdi
    call printf
    # free memory
    pop %r15
    pop %r14
    addq $16, %rsp
    mov %rsp, %rbp
    pop %rbp
    ret

.case54:
    
    mov %r13, %rsi
    call swapCase
    mov %r12, %rsi
    call swapCase
    
    # printing the dest length 
    xor %rax,%rax
    leaq -1(%r13), %rdi
    call pstrlen # getting the length of the first string
    mov %rax, %rsi # put length of string into rsi
    xor %rax,%rax
    movq $case53_print_length, %rdi
    call printf
    
    # printing dest string
    xor %rax, %rax
    movq $case53_print_string, %rdi 
    mov %r13, %rsi
    call printf
    
    # printing the dest length 
    xor %rax,%rax
    leaq -1(%r12), %rdi
    call pstrlen # getting the length of the first string
    mov %rax, %rsi # put length of string into rsi
    xor %rax,%rax
    movq $case53_print_length, %rdi
    call printf
    
    # printing dest string
    xor %rax, %rax
    movq $case53_print_string, %rdi 
    mov %r12, %rsi
    call printf
    
    
    ret
    
swapCase:
    # string in rsi
    # getting the length of the first pstring
    leaq -1(%rsi), %rdi # argument for pstrlen
    call pstrlen
    mov %rax, %r15 # getting the length to %r15
    xor %r14, %r14 # %r14 as counter (i)
    
   
    
    
    #main loop
.mainLoopswapCase:
    cmp %r14, %r15 # if i == pstringLength
    jne .inMainLoopswapCase
    ret
    
    
.inMainLoopswapCase:
    xor %r9, %r9 
    movb (%rsi,%r14,1), %r9b # saving char in %r9b
    
    #checking if it's small word
    # check if its bigger then 96
    movb $96, %r8b #for comparing reasons
    cmpb %r8b,%r9b 
    ja .biggerThan96 # if its bigger than 96 maybe its small word
    movb $64, %r8b #for comparing reasons
    cmp %r8b,%r9b 
    ja .biggerThan64 # if its bigger than 64 maybe its big word
    inc %r14
    jmp .mainLoopswapCase
    


.biggerThan96:
    movb $123, %r8b #for comparing reasons
    cmp %r8b,%r9b 
    jb .lowerThan123 # if its lower than 123 means its small word
    inc %r14 # i = i+1
    jmp .mainLoopswapCase # got to main loop again
    

.lowerThan123:
    sub $32, %r9b
    mov %r9b, (%rsi, %r14, 1)
    inc %r14 # i = i+1
    jmp .mainLoopswapCase # got to main loop again
    
.biggerThan64:
    movb $91, %r8b #for comparing reasons
    cmp %r8b,%r9b 
    jb .lowerThan91 # if its lower than 91 means its big word
    inc %r14 # i = i+1
    jmp .mainLoopswapCase # got to main loop again
    
.lowerThan91:
    add $32, %r9b
    mov %r9b, (%rsi,%r14,1)
    inc %r14 # i = i+1
    jmp .mainLoopswapCase # got to main loop again
     

.case55:
    push %rbp
    mov %rsp, %rbp
    sub $16, %rsp 
    push %r14 # for start index
    push %r15 # for stop index
    
   # getting the start index
    leaq -8(%rbp), %rsi # allocating memory for the start int
    xor %rax, %rax
    movq $format_for_int, %rdi # first argument for scanf
    call scanf
    movzbq -8(%rbp), %r14 # save the start int r14
    
    # getting the stop index char
    leaq -16(%rbp), %rsi # allocating memory for the char
    xor %rax, %rax
    movq $format_for_int, %rdi # first argument for scanf
    call scanf
    movzbq -16(%rbp), %r15 # save the stop index %r14
    
    
    #moving parametrs to psrijcpy
    xor %rax, %rax
    xor %rdx, %rdx
    xor %rcx, %rcx
    
    mov %r13, %rsi # moving second string to rdi
    mov %r12, %rdi # moving first string to rsi
    mov %r14, %rdx # moving i index to rdx
    mov %r15, %rcx # moving j index to rcx
    
    call pstrijcmp
    
    #checking if result is -2, than print error first
    cmp $-2, %rax
    jne .printResult55
    
.printErrorFirstCase55:
    movq %rax, %r15 # backup rax
    xor %rax, %rax
    mov $case53_invalid_input ,%rdi
    call printf
    mov %r15, %rax # return rax as usual
    jmp .printResult55
       
    
    #print result
.printResult55:
    mov %rax, %rsi # print the result of the function
    mov $case55_print_result, %rdi
    xor %rax, %rax
    call printf
    jmp .freeMemory
    
     # free memory
.freeMemory:
    pop %r15
    pop %r14
    addq $16, %rsp
    mov %rsp, %rbp
    pop %rbp
    ret

.error:
    mov $error, %rdi
    xor %rax, %rax
    call printf
    ret
    
pstrlen:
    movzbq (%rdi), %rax
    ret
    
replaceChar:
    # string in rsi
    # old char in rdi
    # new char in rdx
    
    xor %r8, %r8 # counter in r8
    movq %rsi, %r9 # copy rsi to r9 for getting the length
    decq %r9 # getting pointer to the first pstring -> length
    
    # start loop
.firstLoop:
    cmp %r8b,(%r9)
    jne .firstCondition
    ret

.firstCondition:
    cmpb (%rsi,%r8,1), %dil # compart %rsi+%r8 to %rdi (pstring[i] to oldchar)
    je .switchChar
    inc %r8 # counter+=1 
    jmp .firstLoop

.switchChar:
    mov %dl, (%rsi,%r8,1) # replace the char
    inc %r8 # counter+=1 
    jmp .firstLoop

psrijcpy: 
    # pstring dst in rdi
    # pstring src in rsi
    # char i in rdx
    # char j in rcx
    
    # check valid indexes
    xor %rax, %rax
    mov %rdi, %r10 # backup rdi
    leaq -1(%r10), %rdi
    call pstrlen
    cmp %rax, %rdx # if start index is bigger than all length
    ja .erroCmp
    cmp %rax, %rcx # if stop index is bigger than all length
    ja .erroCmp

    
    
    xor %rax, %rax
    mov %rsi, %r9
    leaq -1(%rsi), %rdi
    call pstrlen
    cmp %rax, %rdx # if start index is bigger than all length
    ja .erroCmp
    cmp %rax, %rcx # if stop index is bigger than all length
    ja .erroCmp
    mov %r10, %rdi # restor rdi
    
  
    xor %r10, %r10
    inc %rcx # because we need to include last byte
    # main loop
.mainLoop:
    cmp %rdx, %rcx
    jne .inLoop
    mov %rdi, %rax # return the pointer to dest
    ret

.inLoop:
    movb (%rdi, %rdx, 1), %r10b #get the src[i]
    movb %r10b, (%rsi,%rdx,1) #put dest[i] = src[i]
    inc %rdx # i = i+1
    jmp .mainLoop
    
.erroCmp:
    mov %rax, %rax
    mov %rdi, %rax # return dest
    movq $-2, %r9 # sign that error occur
    ret
    
pstrijcmp:
    # first pstring in %rsi
    # second pstring in %rdi
    # i in rdx
    # j in rcx
    
    
    # check valid indexes
    xor %rax, %rax
    mov %rdi, %r10 # backup rdi
    leaq -1(%r10), %rdi
    call pstrlen
    cmp %rax, %rdx # if start index is bigger than all length
    ja .errorPst
    cmp %rax, %rcx # if stop index is bigger than all length
    ja .errorPst
    
    xor %rax, %rax
    mov %rsi, %r9
    leaq -1(%rsi), %rdi
    call pstrlen
    cmp %rax, %rdx # if start index is bigger than all length
    ja .errorPst
    cmp %rax, %rcx # if stop index is bigger than all length
    ja .errorPst

    mov %r10, %rdi
    mov %r9, %rsi
            
    
    #main loop
.mainLooppstrijcmp:
    cmp %rdx, %rcx
    jne .inLooppstrijcmp
    # last check
    
    xor %r9, %r9 # for comparing reasons
    movb (%rdi,%rdx,1), %r9b
    cmpb (%rsi,%rdx,1),%r9b
    ja .psrt2IsBigger
    jb .pstr1IsBigger
    
    movq $0, %rax # strings are identical
    ret
    
.inLooppstrijcmp:
    xor %r9, %r9 # for comparing reasons
    movb (%rdi,%rdx,1), %r9b
    cmpb (%rsi,%rdx,1),%r9b
    ja .psrt2IsBigger
    jb .pstr1IsBigger
    inc %rdx # i = i+1
    jmp .mainLooppstrijcmp

.psrt2IsBigger:
    movq $-1, %rax
    ret
.pstr1IsBigger:
    movq $1, %rax
    ret

.errorPst:
    movq $-2, %rax
    ret
