section .data
    prompt db "Enter a number: ", 0
    result_msg db "Factorial: ", 0
    newline db 0xA, 0              ; Newline for better formatting
    invalid_msg db "Invalid input. Enter a non-negative integer.", 0

section .bss
    user_input resb 10             ; Buffer for user input

section .text
    global _start

_start:
    ; Prompt the user for input
    mov eax, 4                     ; sys_write system call
    mov ebx, 1                     ; file descriptor 1 (stdout)
    mov ecx, prompt                ; Address of prompt message
    mov edx, 17                    ; Length of prompt message
    int 0x80                       ; Make system call

    ; Read user input
    mov eax, 3                     ; sys_read system call
    mov ebx, 0                     ; file descriptor 0 (stdin)
    mov ecx, user_input            ; Address of input buffer
    mov edx, 10                    ; Maximum number of bytes to read
    int 0x80                       ; Make system call

    ; Convert input string to integer
    call str_to_int                ; Convert input to integer
    cmp eax, 0                     ; Check if input is a valid non-negative integer
    jl invalid_input               ; If negative, display error message

    ; Call factorial subroutine
    push rax                       ; Preserve the input value on the stack
    call factorial                 ; Call factorial subroutine
    mov rbx, rax                   ; Store the result in rbx for display

    ; Print the result message
    mov eax, 4                     ; sys_write system call
    mov ebx, 1                     ; file descriptor 1 (stdout)
    mov ecx, result_msg            ; Address of result message
    mov edx, 10                    ; Length of result message
    int 0x80                       ; Make system call

    ; Print the result (converted from integer)
    call int_to_str                ; Convert result in rbx to string
    mov eax, 4                     ; sys_write system call
    mov ebx, 1                     ; file descriptor 1 (stdout)
    mov ecx, user_input            ; Address of string result
    mov edx, 10                    ; Length of result string
    int 0x80                       ; Make system call

    ; Print a newline
    mov eax, 4                     ; sys_write system call
    mov ebx, 1                     ; file descriptor 1 (stdout)
    mov ecx, newline               ; Address of newline
    mov edx, 1                     ; Length of newline
    int 0x80                       ; Make system call

    ; Exit the program
    mov eax, 1                     ; sys_exit system call
    xor ebx, ebx                   ; Exit status 0
    int 0x80

factorial:
    ; Compute factorial of the number in rax (n!)
    ; Input:  rax = n
    ; Output: rax = n!
    cmp rax, 1                     ; Base case: if n <= 1
    jle base_case                  ; Return 1

    push rax                       ; Save n on the stack
    dec rax                        ; n = n - 1
    call factorial                 ; Recursively call factorial(n-1)
    pop rbx                        ; Restore original n
    imul rax, rbx                  ; Multiply rax (n-1)! by n
    ret                            ; Return to caller

base_case:
    mov rax, 1                     ; Return 1 for factorial(0) or factorial(1)
    ret                            ; Return to caller

str_to_int:
    ; Convert ASCII string in user_input to integer in rax
    xor rax, rax                   ; Clear rax (result)
    xor rcx, rcx                   ; Clear rcx (index)
next_digit:
    movzx rbx, byte [user_input + rcx] ; Load the next byte of input
    cmp rbx, 0xA                   ; Check for newline (end of input)
    je done_conversion             ; If newline, end conversion
    sub bl, '0'                    ; Convert ASCII to integer
    imul rax, rax, 10              ; Multiply result by 10
    add rax, rbx                   ; Add current digit
    inc rcx                        ; Move to the next character
    jmp next_digit
done_conversion:
    ret                            ; Return to caller

int_to_str:
    ; Convert integer in rbx to ASCII string in user_input
    xor rcx, rcx                   ; Clear index
    cmp rbx, 0                     ; Check if the number is zero
    jne convert_loop               ; If not zero, convert normally
    mov byte [user_input], '0'     ; Special case: zero
    inc rcx
    jmp conversion_done

convert_loop:
    xor rdx, rdx                   ; Clear remainder
    mov rax, rbx                   ; Move value to rax for division
    div qword 10                   ; Divide rbx by 10
    add dl, '0'                    ; Convert remainder to ASCII
    mov byte [user_input + rcx], dl; Store ASCII digit
    inc rcx                        ; Move to next digit
    test rax, rax                  ; Check if rax is zero
    jnz convert_loop               ; If not zero, continue conversion

conversion_done:
    mov byte [user_input + rcx], 0 ; Null-terminate the string
    ret                            ; Return to caller

invalid_input:
    ; Print invalid input message
    mov eax, 4                     ; sys_write system call
    mov ebx, 1                     ; file descriptor 1 (stdout)
    mov ecx, invalid_msg           ; Address of invalid message
    mov edx, 42                    ; Length of message
    int 0x80                       ; Make system call
    jmp done                       ; Exit the program
