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

; Cells a random mine can't use: the corners, the squares next to them,
; and the center, which always gets its own mine. The comma at the end of
; the first line joins the two lines, so LENGTHOF counts all 7 cells.
OffLimits    BYTE 0, 1, BoardSize, CenterCell,
                  LastCell - BoardSize, LastCell - 1, LastCell

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


;-----------------------------------------------------
IsOffLimits PROC USES ecx esi
;
; Tells whether a random mine is not allowed on a cell.
; Receives: EAX = cell
; Returns: EAX = 1 if the cell is in OffLimits, 0 if a mine can go there
;-----------------------------------------------------
    mov esi,0
    mov ecx,LENGTHOF OffLimits
CheckCell:
    cmp al,OffLimits[esi]
    je Banned
    inc esi
    loop CheckCell
    mov eax,0                   ; not in the table
    ret
Banned:
    mov eax,1
    ret
IsOffLimits ENDP


;-----------------------------------------------------
ResetBoard PROC USES eax ecx esi
;
; Clears the mines, puts both soldiers back in their corners and starts
; the score. The bot gets HeadStart points for every board already
; cleared in this run.
; Receives: nothing
; Returns: nothing
; Requires: BoardLevel holds the number of the board to start
;-----------------------------------------------------
    mov esi,0
    mov ecx,CellCount
ClearCell:
    mov CellType[esi],CellEmpty
    inc esi
    loop ClearCell
    mov PlayerCell,0
    mov BotCell,LastCell
    mov PlayerPoints,0
    mov eax,BoardLevel
    dec eax                     ; boards already cleared
    imul eax,eax,HeadStart
    mov BotPoints,eax
    mov TurnNumber,1
    mov GamePhase,PhaseYou
    ret
ResetBoard ENDP


;-----------------------------------------------------
PlaceMines PROC USES eax ebx ecx
;
; Puts the center mine and MinePairs random mirrored pairs on the board.
; A mine on cell c also goes on cell 24 - c, so both corners are the same
; distance from the same mines and neither side starts closer.
; Receives: nothing
; Returns: nothing
; Requires: Randomize was called once, ResetBoard cleared CellType
;-----------------------------------------------------
    mov CellType[CenterCell],CellFree
    mov ecx,MinePairs           ; pairs still to place
PickCell:
    mov eax,CellCount
    call RandomRange            ; EAX = 0 to 24
    mov ebx,eax                 ; EBX = the cell picked
    call IsOffLimits
    cmp eax,1
    je PickCell                 ; corners, next to corners or the center
    cmp CellType[ebx],CellEmpty
    jne PickCell                ; already has a mine
    mov CellType[ebx],CellFree
    mov eax,LastCell
    sub eax,ebx                 ; EAX = 24 - c, the mirror cell
    mov CellType[eax],CellFree
    loop PickCell
    ret
PlaceMines ENDP

END
