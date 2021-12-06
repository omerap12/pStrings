    # 209493667 Omer Aplatony
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


.start_jmptbl:
  .quad .case50_60
  .quad .case52
  .quad .case53
  .quad .case54
  .quad .case55
  .quad .error


    .text
  .globl run_func
  .extern pstrlen,replaceChar, pstrijcpy, swapCase, pstrijcmp
run_func:
    leaq -60(%rdi), %rsi # compute x = x-60
    cmpq $0, %rsi # compare x == 0
    je .case50_60
    addq $60, %rsi # return x to original size
    leaq -50(%rdi), %rsi # compute x = x - 60
    cmpq $0, %rsi # compare x == 0
    je .case50_60
    cmpq  $1, %rsi # if %r12 =1 %rdi = 51 -> invalid_case
    je    .error
    cmpq $2, %rsi # compare x == 2
    je .case52
    cmpq $3, %rsi # compare x == 0
    je .case53
    cmpq $4, %rsi # compare x == 0
    je .case54
    cmpq $5, %rsi # compare x == 0    
    je .case55
    ja    .error
    jmp   *.start_jmptbl(,%rsi,8) # else, x < 6 go to the right case using start_jmptbl addres



    

.case50_60:
    leaq -1(%r13), %rdi # for the first string
    xor %rax, %rax
    call pstrlen 
    mov %rax, %r11  # saving the length of the first string
    xor %rax, %rax
    leaq -1(%r12), %rdi # for the second pstring
    call pstrlen
    mov %rax, %r10  # saving the length
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
    push %r14   # for the old char
    push %r15   # for the new char
    
    # getting the old char
    leaq -8(%rbp), %rsi # allocating memory for the char
    xor %rax, %rax
    movq $format_for_string, %rdi   # first argument for scanf
    call scanf
    movzbq -8(%rbp), %r14   # save the old char in r14
    
    # getting the new char
    leaq -16(%rbp), %rsi    # allocating memory for the char
    xor %rax, %rax
    movq $format_for_string, %rdi   # first argument for scanf
    call scanf
    movzbq -16(%rbp), %r15  # save the old char in r14
    
    # call replaceChar for string 1
    mov %r13, %rsi  # first argument (*pstring)
    mov %r14, %rdi  # second argument (char oldChar)
    mov %r15, %rdx  # third argument (char newChar)
    xor %rax,%rax
    call replaceChar
    
    #call replaceChar for string 2
    mov %r12, %rsi  # first argument (*pstring)
    mov %r14, %rdi  # second argument (char oldChar)
    mov %r15, %rdx  # third argument (char newChar)
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
    push %r14   # for start index
    push %r15   # for stop index
    
   # getting the start index
    leaq -8(%rbp), %rsi # allocating memory for the start int
    xor %rax, %rax
    movq $format_for_int, %rdi  # first argument for scanf
    call scanf
    movzbq -8(%rbp), %r14   # save the start int r14
    
    # getting the stop index char
    leaq -16(%rbp), %rsi    # allocating memory for the char
    xor %rax, %rax
    movq $format_for_int, %rdi  # first argument for scanf
    call scanf
    movzbq -16(%rbp), %r15  # save the stop index %r14
    
    
    #moving parametrs to psrijcpy
    xor %rax, %rax
    xor %rdx, %rdx
    xor %rcx, %rcx
    
    mov %r13, %rsi  # moving second string to rdi
    mov %r12, %rdi  # moving first string to rsi
    mov %r14, %rdx  # moving i index to rdx
    mov %r15, %rcx  # moving j index to rcx
    
    call pstrijcpy
    
    # check if error occur
    cmp $-2, %r9
    je .errorInCase53
    jmp .regular
    
.regular: 
    xor %rax,%rax
    leaq -1(%r13), %rdi
    call pstrlen    # getting the length of the first string
    mov %rax, %rsi  # put length of string into rsi
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
    call pstrlen    # getting the length of the first string
    mov %rax, %rsi  # put length of string into rsi
    xor %rax,%rax
    movq $case53_print_length, %rdi
    call printf
    
    # printing dest string
    xor %rax, %rax
    movq $case53_print_string, %rdi 
    mov %r12, %rsi
    call printf

    # free memory
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
    call pstrlen    # getting the length of the first string
    mov %rax, %rsi  # put length of string into rsi
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
    call pstrlen    # getting the length of the first string
    mov %rax, %rsi  # put length of string into rsi
    xor %rax,%rax
    movq $case53_print_length, %rdi
    call printf
    
    # printing dest string
    xor %rax, %rax
    movq $case53_print_string, %rdi 
    mov %r12, %rsi
    call printf
    ret

.case55:
    push %rbp
    mov %rsp, %rbp
    sub $16, %rsp 
    push %r14   # for start index
    push %r15   # for stop index
    
   # getting the start index
    leaq -8(%rbp), %rsi # allocating memory for the start int
    xor %rax, %rax
    movq $format_for_int, %rdi  # first argument for scanf
    call scanf
    movzbq -8(%rbp), %r14   # save the start int r14
    
    # getting the stop index char
    leaq -16(%rbp), %rsi    # allocating memory for the char
    xor %rax, %rax
    movq $format_for_int, %rdi  # first argument for scanf
    call scanf
    movzbq -16(%rbp), %r15  # save the stop index %r14
    
    
    #moving parametrs to psrijcpy
    xor %rax, %rax
    xor %rdx, %rdx
    xor %rcx, %rcx
    
    mov %r13, %rsi  # moving second string to rdi
    mov %r12, %rdi  # moving first string to rsi
    mov %r14, %rdx  # moving i index to rdx
    mov %r15, %rcx  # moving j index to rcx
    
    call pstrijcmp
    
    #checking if result is -2, than print error first
    cmp $-2, %rax
    jne .printResult55
    
.printErrorFirstCase55:
    movq %rax, %r15 # backup rax
    xor %rax, %rax
    mov $case53_invalid_input ,%rdi
    call printf
    mov %r15, %rax  # return rax as usual
    jmp .printResult55
       
    
    #print result
.printResult55:
    mov %rax, %rsi  # print the result of the function
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
    
