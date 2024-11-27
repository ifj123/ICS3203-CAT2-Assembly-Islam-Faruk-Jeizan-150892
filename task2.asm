section .data
    array db 1, 2, 3, 4, 5    ; Example array
    len equ 5                 ; Length of the array
    msg db "Array reversed successfully", 0xA, 0
    space db " "              ; Space character
    newline db 0xA            ; Newline character

section .text
global _start

_start:
    ; Initialize pointers for array reversal
    mov esi, array            ; Start pointer (points to first element)
    mov edi, array + len - 1  ; End pointer (points to last element)

reverse_loop:
    ; Compare start and end pointers
    cmp esi, edi              ; Check if pointers meet or cross
    jge end_reverse           ; Exit loop if condition is met

    ; Swap elements
    mov al, [esi]             ; Load value at start pointer
    mov bl, [edi]             ; Load value at end pointer
    mov [esi], bl             ; Store value at end pointer to start pointer
    mov [edi], al             ; Store value at start pointer to end pointer

    ; Move pointers
    inc esi                   ; Move start pointer forward
    dec edi                   ; Move end pointer backward
    jmp reverse_loop          ; Repeat for next pair of elements

end_reverse:
    ; Print success message
    mov eax, 4                ; syscall: write
    mov ebx, 1                ; file descriptor: stdout
    mov ecx, msg              ; Message address
    mov edx, 27               ; Message length
    int 0x80                  ; Invoke syscall

    ; Print the reversed array
    call print_array

    ; Exit program
    mov eax, 1                ; syscall: exit
    xor ebx, ebx              ; Exit code 0
    int 0x80

print_array:
    ; Routine to print the array
    mov esi, array            ; Start pointer to array
    mov ecx, len              ; Number of elements in the array

print_loop:
    mov al, [esi]             ; Load current element
    add al, '0'               ; Convert number to ASCII
    mov eax, 4                ; syscall: write
    mov ebx, 1                ; file descriptor: stdout
    lea edx, [space]          ; Load address of space character
    mov dl, [edx]             ; Move the space into dl
    mov edx, 1                ; Write one character
    int 0x80                  ; Invoke syscall

    ; Print space after the number (except the last one)
    dec ecx                   ; Decrement counter
    jz done_print             ; If last element, skip printing a space
    lea ecx, [space]          ; Load space character address
    mov edx, 1                ; Write space character
    int 0x80                  ; Invoke syscall

    inc esi                   ; Move to the next array element
    jmp print_loop            ; Repeat for next element

done_print:
    ; Print a newline after the array
    mov eax, 4                ; syscall: write
    mov ebx, 1                ; file descriptor: stdout
    lea ecx, [newline]        ; Load address of newline character
    mov edx, 1                ; Write one character
    int 0x80                  ; Invoke syscall
    ret