.data

  .section  .rodata
format_for_int: .string "%d"
format_for_string: .string "%s"
end_character:    .string "\0"
case_50_60: .string "first pstring length: %d, second pstring length: %d\n"
error:  .string "Invalid option!\n"
format_for_char:    .string "%c"
case52_oldchar: .string "old char: %c,"
case52_newchar: .string "new char: %c,"
case52_firststring: .string "first string: %s,"
case52_secondstring:    .string "second string: %s\n"
case53_invalid_input:   .string "invalid input!\n"


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
    
   # getting the old char
    leaq -8(%rbp), %rsi # allocating memory for the char
    xor %rax, %rax
    movq $format_for_int, %rdi # first argument for scanf
    call scanf
    movzbq -8(%rbp), %r14 # save the old char in r14
    
    # getting the stop index char
    leaq -16(%rbp), %rsi # allocating memory for the char
    xor %rax, %rax
    movq $format_for_int, %rdi # first argument for scanf
    call scanf
    movzbq -16(%rbp), %r15 # save the stop index %r14
    
    #checking if input is valid
    xor %rax,%rax
    leaq -1(%r13), %rdi
    
    call pstrlen # getting the length of the first string
    cmpb %al, %r14b # if start index is bigger than string.length
    
    ja .invalidInput
    ret

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
   
    
    #moving parametrs to psrijcpy
    xor %rax, %rax
    xor %rdx, %rdx
    xor %rcx, %rcx
    
    
    
    mov %r13, %rsi # moving first string to rsi
    mov %r12, %rdi # moving second string to rdi
    mov %r14, %rdx # moving i index to rdx
    mov %r15, %rcx # moving j index to rcx
    
    
    call psrijcpy
    
    # free memory
    pop %r15
    pop %r14
    addq $16, %rsp
    mov %rsp, %rbp
    pop %rbp
    ret
    
    
    
    

.case54:
    mov -1(%r13), %rdi
    mov -1(%r12), %rsi
    xor %rax, %rax
    call printf

.case55:
    mov -1(%r13), %rdi
    mov -1(%r12), %rsi
    xor %rax, %rax
    call printf

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
    # pstring dst in rsi
    # pstring src in rdi
    # char i in rdx
    # char j in rcx
    
    
    ret
    
    
    
