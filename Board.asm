; Board data, moves, mines and scoring            (Board.asm)

INCLUDE Frontier.inc

.data
CellType     BYTE CellCount DUP(CellEmpty)  ; what is on each cell
PlayerCell   BYTE 0             ; the player starts in the top-left corner
BotCell      BYTE LastCell      ; the bot starts in the bottom-right corner
PlayerPoints DWORD 0
BotPoints    DWORD 0
TurnNumber   DWORD 1            ; MaxTurns + 1 once the board is over
BoardLevel   DWORD 1            ; which board of the run this is
GamePhase    DWORD PhaseYou     ; whose move it is, or how the board ended

.code
;-----------------------------------------------------
CellToRowCol PROC USES ebx
;
; Splits a cell number into its row and column.
; Receives: EAX = cell (0 to 24)
; Returns: EAX = row, EDX = column
;-----------------------------------------------------
    mov edx,0                   ; DIV divides EDX:EAX
    mov ebx,BoardSize
    div ebx                     ; EAX = cell / 5, EDX = cell mod 5
    ret
CellToRowCol ENDP


;-----------------------------------------------------
NeighborCell PROC USES ecx edx
;
; Finds the cell one step away in a direction.
; Receives: EAX = cell, EBX = CmdUp, CmdDown, CmdLeft or CmdRight
; Returns: EAX = the next cell, or NoCell past the edge of the board
;-----------------------------------------------------
    mov ecx,eax                 ; ECX = the starting cell
    call CellToRowCol           ; EAX = row, EDX = column
    cmp ebx,CmdUp
    jne NotUp
    cmp eax,0
    je OffBoard                 ; already on the top row
    sub ecx,BoardSize
    jmp Done
NotUp:
    cmp ebx,CmdDown
    jne NotDown
    cmp eax,BoardSize - 1
    je OffBoard                 ; already on the bottom row
    add ecx,BoardSize
    jmp Done
NotDown:
    cmp ebx,CmdLeft
    jne NotLeft
    cmp edx,0
    je OffBoard                 ; already in the left column
    dec ecx
    jmp Done
NotLeft:                        ; anything else moves right
    cmp edx,BoardSize - 1
    je OffBoard                 ; already in the right column
    inc ecx
Done:
    mov eax,ecx
    ret
OffBoard:
    mov eax,NoCell
    ret
NeighborCell ENDP

END
