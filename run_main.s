.data

  .section  .rodata
format_for_int: .string "%d"
format_for_string: .string "%s"
end_character:    .string "\0"



.text
.global run_main
.extern run_func
.type run_main, @function
run_main:
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

