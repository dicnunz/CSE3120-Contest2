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

END
