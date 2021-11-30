.data

  .section  .rodata
format_for_int: .string "%d"
format_for_string: .string "%s"
end_character:    .string "\0"
case_50_60: .string "first pstring length: %d, second pstring length: %d\n"
error:  .string "Invalid option!\n"


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
    mov -1(%r13), %rdi
    mov -1(%r12), %rsi
    xor %rax, %rax
    call printf
    
.case53:
    mov -1(%r13), %rdi
    mov -1(%r12), %rsi
    xor %rax, %rax
    call printf

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
    
