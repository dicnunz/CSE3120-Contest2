; Everything that draws on the screen             (Render.asm)

INCLUDE Frontier.inc

.data

.code
;-----------------------------------------------------
WriteAt PROC USES edx
;
; Writes a string at a screen position in a color.
; Receives: DH = row, DL = column, EAX = color (text + background * 16),
;           ESI = OFFSET of the string
; Returns: nothing
;-----------------------------------------------------
    call Gotoxy
    call SetTextColor
    mov edx,esi
    call WriteString
    ret
WriteAt ENDP


;-----------------------------------------------------
WriteTwoDigits PROC USES eax
;
; Writes a number with two digits, so 7 shows as 07.
; Receives: EAX = number from 0 to 99
; Returns: nothing
;-----------------------------------------------------
    cmp eax,10
    jae TwoDigits
    push eax
    mov al,'0'
    call WriteChar
    pop eax
TwoDigits:
    call WriteDec
    ret
WriteTwoDigits ENDP

END
