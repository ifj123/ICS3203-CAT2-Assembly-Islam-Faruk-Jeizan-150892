section .data
    sensor_value dq 30           ; Simulated sensor value
    motor_status db 0            ; 0: off, 1: on
    alarm_status db 0            ; 0: off, 1: on
    debug_msg db "Debug: Sensor value: ", 0
    alarm_msg db "Alarm triggered!", 0
    motor_on_msg db "Motor turned on.", 0
    motor_off_msg db "Motor turned off.", 0
    newline db 10, 0

section .bss
    result_str resb 20           ; Buffer to store converted integer as string

section .text
    global _start

_start:
    ; Read sensor value
    mov rax, [sensor_value]

    ; Debug: Output sensor value
    mov rdi, rax
    call print_debug

    ; Decision-making logic
    cmp rax, 75               ; If sensor value > 75, trigger alarm
    ja trigger_alarm
    cmp rax, 50               ; If sensor value > 50, turn on motor
    ja turn_on_motor
    jmp turn_off_motor        ; Otherwise, turn off motor

trigger_alarm:
    mov byte [alarm_status], 1
    mov rsi, alarm_msg        ; Display alarm message
    call print_message
    jmp end_program

turn_on_motor:
    mov byte [motor_status], 1
    mov rsi, motor_on_msg     ; Display motor on message
    call print_message
    jmp end_program

turn_off_motor:
    mov byte [motor_status], 0
    mov rsi, motor_off_msg    ; Display motor off message
    call print_message

end_program:
    ; Exit program
    mov rax, 60               ; syscall: exit
    xor rdi, rdi              ; exit code 0
    syscall

print_debug:
    ; Print "Debug: Sensor value: " followed by the value
    mov rax, 1                ; syscall: write
    mov rdi, 1                ; file descriptor: stdout
    mov rsi, debug_msg        ; address of message
    mov rdx, 22               ; message length
    syscall

    ; Convert value in rdi to string
    mov rax, rdi
    mov rdi, result_str       ; Buffer for string
    call int_to_string        ; Convert integer to string

    ; Print the converted string
    mov rax, 1                ; syscall: write
    mov rdi, 1                ; file descriptor: stdout
    mov rsi, result_str       ; Address of result
    mov rdx, 20               ; Buffer size
    syscall

    ; Print newline
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall
    ret

print_message:
    ; Print the message in rsi
    mov rax, 1                ; syscall: write
    mov rdi, 1                ; file descriptor: stdout
    mov rdx, 20               ; Assume message length <= 20
    syscall

    ; Print newline
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall
    ret

int_to_string:
    ; Converts the integer in rax to a string in the buffer at rdi
    mov rcx, 0             ; Digit count

.convert_loop:
    xor rdx, rdx           ; Clear rdx
    mov rbx, 10            ; Divisor
    div rbx                ; rax = rax / 10, remainder in rdx
    add rdx, '0'           ; Convert remainder to ASCII
    mov [rdi + rcx], dl    ; Store ASCII character
    inc rcx                ; Increment digit count
    test rax, rax          ; Check if quotient is 0
    jnz .convert_loop

    ; Reverse the string
    mov rsi, rdi           ; Start of string
    add rdi, rcx           ; End of string (null-terminator position)
    dec rdi                ; Adjust to last character
.reverse_loop:
    cmp rsi, rdi           ; Compare pointers
    jge .done_reverse      ; If start >= end, done
    mov al, [rsi]          ; Swap characters
    mov bl, [rdi]
    mov [rsi], bl
    mov [rdi], al
    inc rsi                ; Move forward
    dec rdi                ; Move backward
    jmp .reverse_loop
.done_reverse:
    ret