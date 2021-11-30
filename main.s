.data

  .section  .rodata
format_for_int: .string "%d"
format_for_string: .string "%s"
end_character:    .string "\0"


.text
.global main
main:
    movq %rsp, %rbp #for correct debugging
    pushq %rbp
    movq  %rsp, %rbp
    subq  $528, %rsp 
    push  %r13 # first pstring
    push  %r12 # second pstring
    xorq  %rax, %rax
    
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
       
    
    ret
