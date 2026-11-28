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


;-----------------------------------------------------
TileBackground PROC USES ebx edx
;
; Picks a tile's background color: brown for a free mine, blue for the
; player's mine, red for the bot's, and a black and gray checkerboard
; for tiles without a mine.
; Receives: EAX = cell
; Returns: EAX = background color
;-----------------------------------------------------
    call CellToRowCol           ; EAX = row, EDX = column
    add eax,edx
    and eax,1                   ; 0 when row + column is even, 1 when odd
    shl eax,3                   ; 0 is black and 8 is gray
    ret
TileBackground ENDP

END
