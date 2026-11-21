; Frontier                                        (Main.asm)

; Program Description: Main module of Frontier, a board game against a
;   bot on a 5 by 5 grid. Step on mines to take them. Every mine you own
;   scores 1 point each turn, and you have to outscore the bot in 20
;   turns. Each board you clear starts the next one with the bot further
;   ahead, and one loss ends the run.
; Author: Nicholas Welsh
; Creation Date: 11/20/2026
; Revisions: see the commit history

INCLUDE Frontier.inc
.code
main PROC
    call Randomize              ; seed RandomRange so every board is new
    call NewBoard
    exit
main ENDP
END main
