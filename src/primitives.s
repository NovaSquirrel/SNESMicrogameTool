;
; SNES Microgame engine
; Copyright 2019-2020 NovaSquirrel
; 
; This software is provided 'as-is', without any express or implied
; warranty.  In no event will the authors be held liable for any damages
; arising from the use of this software.
; 
; Permission is granted to anyone to use this software for any purpose,
; including commercial applications, and to alter it and redistribute it
; freely, subject to the following restrictions:
; 
; 1. The origin of this software must not be misrepresented; you must not
;    claim that you wrote the original software. If you use this software
;    in a product, an acknowledgment in the product documentation would be
;    appreciated but is not required.
; 2. Altered source versions must be plainly marked as such, and must not be
;    misrepresented as being the original software.
; 3. This notice may not be removed or altered from any source distribution.
;
.include "snes.inc"
.include "global.inc"
.include "memory.inc"
.smart
.a16
.i16

.segment "RuntimeLibrary"

; Adds an actor's speed to its position
.export ActorApplyVelocity
.proc ActorApplyVelocity
  lda ActorPX,x
  add ActorVX,x
  sta ActorPX,x

  lda ActorPY,x
  add ActorVY,x
  sta ActorPY,x
  rtl
.endproc

.export ActorBallMovement
.proc ActorBallMovement
  lda ActorDir,x ; Multiply by 2 because SpeedAngle2Offset256 expects it to be doubled already
  and #$00ff     ; Just to be sure
  asl
  tay
  lda ActorSpeed,x
  jsr SpeedAngle2Offset256 ; A = speed, Y = angle -> 0,1,2(X) 2,3,4(Y)
  lda 1
  sta ActorVX,x
  lda 3
  sta ActorVY,x
  jmp ActorApplyVelocity
.endproc

; Inputs: A (Allowed directions)
.export Actor8WayMovement
.proc Actor8WayMovement
  and keydown
  sta 0

  and #KEY_LEFT
  beq :+
    lda ActorPX,x
    sub ActorSpeed,x
    sta ActorPX,x
  :

  lda 0
  and #KEY_RIGHT
  beq :+
    lda ActorPX,x
    add ActorSpeed,x
    sta ActorPX,x
  :

  lda 0
  and #KEY_DOWN
  beq :+
    lda ActorPY,x
    add ActorSpeed,x
    sta ActorPY,x
  :

  lda 0
  and #KEY_UP
  beq :+
    lda ActorPYH,x
    sub ActorSpeed,x
    sta ActorPYH,x
  :
  rtl
.endproc

; Inputs: A (Actor type to find)
; Outputs: Carry (success), OtherActor (found index)
.export ActorFindType
.proc ActorFindType
  sta 0

  ldy #ActorStart
: lda 0
  cmp ActorType,y
  beq Found

  tya
  add #ActorSize
  tay
  cmp #ActorEnd
  bne :-
Fail:
  ldy #INVALID_ACTOR
  sty OtherActor
  clc
  rtl
Found:
  sty OtherActor
  sec
  rtl
.endproc

; Finds a free actor slot
; Outputs: OtherActor (index), Carry (success)
.export ActorFindFree
.proc ActorFindFree
  ldy #ActorStart
: lda ActorType,y
  beq ActorFindType::Found
  tya
  add #ActorSize
  tay
  cmp #ActorEnd
  bne :-
  bra ActorFindType::Fail
.endproc

; Inputs: 0(X), 2(Y), A(Type)
; Outputs: OtherActor (index)
.proc ActorCreateAtXY
  sta Type
  jsl ActorFindFree
  bcc Fail
  jsl ActorClearY
  lda 0
  sta ActorPXH,y
  lda 2
  sta ActorPYH,y
  lda 4
  sta ActorType,y

  phx ; Save this actor's index
    lda OtherActor
    pha
      tyx
      sta ThisActor
      jsr CallActorInit
    pla
    sta OtherActor
  plx ; Restore this actor's index
  stx ThisActor

  sec
  rtl
Fail:
  clc
  rtl
.endproc

; Clears most fields of an actor
.export ActorClearY
.proc ActorClearY
  lda #0
  sta ActorType,y
  sta ActorDir,y
  sta ActorPX,y
  sta ActorPY,y
  sta ActorVar1,y
  sta ActorVar2,y
  sta ActorVar3,y
  sta ActorVar4,y
  sta ActorVar5,y
  sta ActorVar6,y
Stop:
  lda #0
  sta ActorSpeed,y
  sta ActorVX,y
  sta ActorVY,y
  rtl
.endproc
ActorStop = ActorClearY::Stop

.export ActorReverse
.proc ActorReverse
  lda ActorDir,x
  eor #128
  sta ActorDir,x

  ; Also negate the velocity
  lda ActorVX,x
  eor #$ffff
  ina
  sta ActorVX,x

  lda ActorVY,x
  eor #$ffff
  ina
  sta ActorVY,x
  rtl
.endproc

; Inputs: A (type of actor to destroy)
.export ActorDestroyType
.proc ActorDestroyType
  sta 0
  ldy #ActorStart
Loop:
  lda 0
  cmp ActorType,y
  bne :+
    tdc ; Clear the accumulator
    sta ActorType,y
  :
  tya
  add #ActorSize
  tay
  cmp #ActorEnd
  bne Loop
  rtl
.endproc

; Set position to another actor's position
.export ActorJumpToActor
.proc ActorJumpToActor
  ldy OtherActor
  lda ActorPX,y
  sta ActorPX,x
  lda ActorPY,y
  sta ActorPY,x
  rtl
.endproc

; Inputs: A (X), 0 (Y)
.export ActorJumpToXY
.proc ActorJumpToXY
  sta ActorPX,x
  lda 0
  sta ActorPY,x
  rtl
.endproc

; Swap positions
.export ActorSwapWithActor
.proc ActorSwapWithActor
  ldy OtherActor
  swaparray ActorPX
  swaparray ActorPY
  rtl
.endproc

; Inputs: A (block type), 0 (X), 1 (Y)
.proc SetBlock
  sta 2

  lda 1
  asl
  asl
  asl
  asl
  ora 0
  tay

  lda 2
  sta LevelMap,y

  ; todo: actually change the block onscreen
  rts
.endproc

; Inputs: A (maximum value allowed)
.proc RandomWithMax
  sta 0

  cmp #2
  bcs :+
    lda #1
    sta 1
    bne GotMask
  :
  cmp #4
  bcs :+
    lda #3
    sta 1
    bne GotMask
  :
  cmp #8
  bcs :+
    lda #7
    sta 1
    bne GotMask
  :
  cmp #16
  bcs :+
    lda #15
    sta 1
    bne GotMask
  :
  cmp #32
  bcs :+
    lda #31
    sta 1
    bne GotMask
  :
  cmp #64
  bcs :+
    lda #63
    sta 1
    bne GotMask
  :
  cmp #128
  bcs :+
    lda #127
    sta 1
    bne GotMask
  :
  lda #255
  sta 2
GotMask:
  ; Now find the number

:  jsl random
   and 2 ; Mask it to make the range smaller
   cmp 0 ; Too big?
   beq :+
   bcs :-
:  rts
.endproc

; Inputs: A (number the random result has to be greater or equal to)
.export RandomChance
.proc RandomChance
  sta 0
  jsl random
  cmp 0
  rtl
.endproc

.export WinGame
.proc WinGame
  lda #1
  sta MicrogameWon
  rtl
.endproc

.export LoseGame
.proc LoseGame
  lda #1
  sta MicrogameLost
  rtl
.endproc

; todo
.export PlaySoundEffect
.proc PlaySoundEffect
  rtl
.endproc

; Test if the actor is in the region defined by A (X1), 0 (X2), 2 (Y1), 4 (Y2)
.export ActorInRegion
.proc ActorInRegion
  sta 6

  lda ActorPXH,x
  cmp 6
  bcc No
  cmp 0
  bcs No

  lda ActorPYH,x
  cmp 2
  bcc No
  cmp 4
  bcs No

Yes:
  sec
  rtl
No:
  clc
  rtl
.endproc

; todo
.proc ActorTouchingType
  clc
  rts
.endproc

.export ActorLookAtActor
.proc ActorLookAtActor
  ldy OtherActor

  lda ActorPX,y
  sub ActorPX,x
  sta 0
  lda ActorPY,y
  sub ActorPY,x
  sta 2
  jsl GetAngle512
  lsr
  sta ActorDir,x
  ldy OtherActor ; Is this needed?
  rtl
.endproc

; Look towards a point. A (X) 0 (Y)
.export ActorLookAtPoint
.proc ActorLookAtPoint
  pha
  lda 0
  sub ActorPY,x
  sta 2
  pla
  sub ActorPX,x
  sta 0
  jsl GetAngle512
  lsr
  sta ActorDir,x
  rts
.endproc

; Calculates a horizontal and vertical speed from a speed and an angle
; input: A (speed) Y (angle, 0-255 times 2)
; output: 0,1,2 (X position), 2,3,4 (Y position)
.import MathSinTable, MathCosTable
.proc SpeedAngle2Offset256
  php
  seta8
  sta M7MUL ; 8-bit factor

  lda MathCosTable+0,y
  sta M7MCAND ; 16-bit factor
  lda MathCosTable+1,y
  sta M7MCAND

  lda M7PRODLO
  sta 0
  lda M7PRODHI
  sta 1
  lda M7PRODBANK
  sta 2

  ; --------

  lda MathSinTable+0,y
  sta M7MCAND ; 16-bit factor
  lda MathSinTable+1,y
  sta M7MCAND

  lda M7PRODLO
  sta 3
  lda M7PRODHI
  sta 4
  lda M7PRODBANK
  sta 5
  plp
  rtl
.endproc
.a16
