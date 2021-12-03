  .text
  .globl pstrlen,replaceChar, pstrijcpy, swapCase, pstrijcmp

    .type pstrlen @function
pstrlen:
    movzbq (%rdi), %rax
    ret

    .type replaceChar @function
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


    .type psrijcpy @function
pstrijcpy: 
    # pstring dst in rdi
    # pstring src in rsi
    # char i in rdx
    # char j in rcx
    
    # check valid indexes
    xor %rax, %rax
    mov %rdi, %r10 # backup rdi
    mov %rcx, %r11 # for getting rcx+1 save it in another register
    addq $1, %r11 # up rcx by one
    leaq -1(%r10), %rdi
    call pstrlen
    cmp %rax, %rdx # if start index is bigger than all length
    ja .erroCmp
    cmp %rax, %r11 # if stop index is bigger than all length
    ja .erroCmp

    xor %rax, %rax
    mov %rsi, %r9
    leaq -1(%rsi), %rdi
    call pstrlen
    cmp %rax, %rdx # if start index is bigger than all length
    ja .erroCmp
    cmp %rax, %r11 # if stop index is bigger than all length
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

    .type pstrijcmp @function
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

    .type swapCase @function
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
