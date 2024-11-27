section .data
    prompt db "Enter a number: ", 0      ; Null-terminated string for output
    positive db "POSITIVE", 0           ; Output for positive numbers
    negative db "NEGATIVE", 0           ; Output for negative numbers
    zero db "ZERO", 0                   ; Output for zero

section .bss
    num resb 4                          ; Reserve space for user input

section .text
global _start

_start:
    ; Print prompt
    mov eax, 4                          ; syscall: write
    mov ebx, 1                          ; file descriptor: stdout
    mov ecx, prompt                     ; message address
    mov edx, 17                         ; message length
    int 0x80                            ; invoke syscall

    ; Read input number
    mov eax, 3                          ; syscall: read
    mov ebx, 0                          ; file descriptor: stdin
    mov ecx, num                        ; buffer address
    mov edx, 4                          ; buffer size
    int 0x80                            ; invoke syscall

    ; Convert input to integer (manual atoi)
    mov esi, num                        ; Load buffer address
    xor eax, eax                        ; Clear eax (result)
    xor ecx, ecx                        ; Clear ecx (sign flag)

atoi:
    lodsb                               ; Load next byte from [esi] into al
    cmp al, 0x0A                        ; Check for newline
    je classify                         ; If newline, go to classification
    sub al, '0'                         ; Convert ASCII to number
    imul eax, 10                        ; Multiply result by 10
    add eax, eax                        ; Add the new digit
    jmp atoi                            ; Repeat for next character

classify:
    cmp eax, 0
    je zero_label
    jl negative_label
    jmp positive_label

zero_label:
    mov ecx, zero                       ; Select zero message
    jmp print_result

negative_label:
    mov ecx, negative                   ; Select negative message
    jmp print_result

positive_label:
    mov ecx, positive                   ; Select positive message

print_result:
    mov edx, 8                          ; Length of output message
    mov ebx, 1                          ; stdout
    mov eax, 4                          ; syscall: write
    int 0x80

    ; Exit program
    mov eax, 1                          ; syscall: exit
    xor ebx, ebx                        ; exit code 0
    int 0x80