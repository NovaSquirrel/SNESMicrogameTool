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
YOnly:
  lda ActorPY,x
  add ActorVY,x
  sta ActorPY,x
  rtl
.endproc
ActorApplyYVelocity = ActorApplyVelocity::YOnly

.export ActorBallMovement
.proc ActorBallMovement
  lda ActorDirection,x ; Multiply by 2 because SpeedAngle2Offset256 expects it to be doubled already
  and #$00ff     ; Just to be sure
  asl
  tay
  lda ActorSpeed,x
  jsl SpeedAngle2Offset256 ; A = speed, Y = angle -> 0,1,2(X) 2,3,4(Y)
  lda 1
  asr_n 6
  sta ActorVX,x
  lda 4
  asr_n 6
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
    lda ActorPY,x
    sub ActorSpeed,x
    sta ActorPY,x
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
.export ActorCreateAtXY
.proc ActorCreateAtXY
  sta 4
  jsl ActorFindFree
  bcc Fail
  jsl ActorClearY
  lda 0
  sta ActorPX,y
  lda 2
  sta ActorPY,y
  lda 4
  sta ActorType,y

  phx ; Save this actor's index
    lda OtherActor
    pha
      tyx
      sta ThisActor
      jsl CallActorInit
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

.export CallActorInit
.proc CallActorInit
  ; I'll assume the data bank is already set correctly
  seta8
  lda GameDataPointer+2
  sta 2
  seta16

  lda ActorType,x
  asl
  tay
  lda [GameDataPointer_ActorInit],y
  bne :+
    rtl
  :
  sta 0  
  jml [0]
.endproc

; Clears most fields of an actor
.export ActorClearY
.proc ActorClearY
  lda #0
  sta ActorType,y
  sta ActorDirection,y
  sta ActorPX,y
  sta ActorPY,y
  sta ActorVarA,y
  sta ActorVarB,y
  sta ActorVarC,y
  sta ActorVarD,y
  sta ActorVarE,y
  sta ActorVarF,y
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
  lda ActorDirection,x
  eor #128
  sta ActorDirection,x

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

.a16
.proc RandomWithMaxConstant
  sta 2
: jsl random
  and 0 ; Mask supplied in 0
  cmp 2 ; Too big?
  beq :+
  bcs :-
: rtl
.endproc

.if 0
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

: jsl random
  and 2 ; Mask it to make the range smaller
  cmp 0 ; Too big?
  beq :+
  bcs :-
: rts
.endproc
.endif

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

  lda ActorPX,x
  cmp 6
  bcc No
  cmp 0
  bcs No

  lda ActorPY,x
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
  .import GetAngle512
  jsl GetAngle512
  lsr
  sta ActorDirection,x
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
  .import GetAngle512
  jsl GetAngle512
  lsr
  sta ActorDirection,x
  rts
.endproc

; Calculates a horizontal and vertical speed from a speed and an angle
; input: A (speed) Y (angle, 0-255 times 2)
; output: 0,1,2 (X position), 2,3,4 (Y position)
.import MathSinTable, MathCosTable
.proc SpeedAngle2Offset256
  php
  phb
  seta8
  sta M7MUL ; 8-bit factor

  lda #^MathCosTable
  pha
  plb

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
  plb
  plp
  rtl
.endproc
.a16

.proc random
  phx ; Needed because setaxy8 will clear the high byte of X
  phy
  php
  setaxy8
  tdc ; Clear A, including the high byte

  ; rotate the middle bytes left
  ldy seed+2 ; will move to seed+3 at the end
  lda seed+1
  sta seed+2
  ; compute seed+1 ($C5>>1 = %1100010)
  lda seed+3 ; original high byte
  lsr
  sta seed+1 ; reverse: 100011
  lsr
  lsr
  lsr
  lsr
  eor seed+1
  lsr
  eor seed+1
  eor seed+0 ; combine with original low byte
  sta seed+1
  ; compute seed+0 ($C5 = %11000101)
  lda seed+3 ; original high byte
  asl
  eor seed+3
  asl
  asl
  asl
  asl
  eor seed+3
  asl
  asl
  eor seed+3
  sty seed+3 ; finish rotating byte 2 into 3
  sta seed+0

  plp
  ply
  plx
  rtl
.endproc
.a16

.export ActorOverlapBlock
.proc ActorOverlapBlock
  rtl
.endproc

.export ActorFall
.proc ActorFall
  jsl ActorGravity
  jmp ActorCheckStandingOnSolid
.endproc

.export ActorCheckStandingOnSolid
.proc ActorCheckStandingOnSolid
  seta8
  stz ActorOnGround,x
  seta16

  ; If going upwards, bounce against ceilings
  stz 0

  lda ActorVY,x
  bpl NotUp
    lda ActorPY,x
    sub #$0080
    tay
    lda ActorPX,x
    jsl ActorTryVertInteraction
    asl
    bcc :+
      lda #$20
      sta ActorVY,x
      clc
    :
    rtl
  NotUp:

  ; Maybe add checks for the sides
  lda ActorPY,x
  add #$0080
  tay
  lda ActorPX,x
  jsl ActorTryVertInteraction
  cmp #$4000
  rol 0

  lda 0
  seta8
  sta ActorOnGround,x
  ; React to touching the ground
  beq :+
    lda #$80
    sta ActorPY,x ; Clear the low byte

    seta16
    stz ActorVY,x
    sec
    rtl
  :
  seta16
  clc
  rtl
.endproc

.export ActorTryVertInteraction
.import BlockRunInteractionActorTopBottom
.proc ActorTryVertInteraction
  jsl GetLevelPtrXY
  tay
  lda [GameDataPointer_BlockFlags],y ; 16-bit read on 8-bit data
  xba ; Put those flags in the high byte
  rtl
.endproc

.export ActorGravity
.proc ActorGravity
  add ActorVY,x
  sta ActorVY,x

  ; Is it too high?
  bmi OK
  cmp #$0060
  bcc OK
  lda #$0060
  sta ActorVY,x
OK:
  jml ActorApplyYVelocity
.endproc

.export BlockChangeType
.proc BlockChangeType
  rtl
.endproc


.proc ScrollTargetActor
TargetX = 0
TargetY = 2
  ; Find the target scroll positions
  lda ActorPX,x
  sub #8*256
  bcs :+
    lda #0
: sta TargetX

  lda ActorPY,x
  sub #8*256  ; Pull back to center vertically
  bcs :+
    lda #0
: cmp #(256+32)*16 ; Limit to two screens of vertical scrolling
  bcc :+
  lda #(256+32)*16
: sta TargetY
  rts
.endproc

.proc ScrollSpeedLimit
  ; Take absolute value
  php
  bpl :+
    eor #$ffff
    inc a
  :
  ; Cap it at 8 pixels
  cmp #$0080
  bcc :+
    lda #$0080
  :
  ; Undo absolute value
  plp
  bpl :+
    eor #$ffff
    inc a
  :
  rts
.endproc

.export ScrollCenterActor
.proc ScrollCenterActor
  jsr ScrollTargetActor
  lda 0
  sta ScrollX
  lda 2
  sta ScrollY
  rtl
.endproc

.export ScrollFollowActor2
.proc ScrollFollowActor2
  jsr ScrollTargetActor

  lda ScrollTargetActor::TargetX
  sub ScrollX
  jsr Shift
  add ScrollX
  sta ScrollX

  lda ScrollTargetActor::TargetY
  sub ScrollY
  jsr Shift
  add ScrollY
  sta ScrollY
  rtl

Shift:
  asr_n 1
  jmp ScrollSpeedLimit
.endproc

.export ScrollFollowActor4
.proc ScrollFollowActor4
  jsr ScrollTargetActor

  lda ScrollTargetActor::TargetX
  sub ScrollX
  jsr Shift
  add ScrollX
  sta ScrollX

  lda ScrollTargetActor::TargetY
  sub ScrollY
  jsr Shift
  add ScrollY
  sta ScrollY
  rtl

Shift:
  asr_n 2
  jmp ScrollSpeedLimit
.endproc

.export ScrollFollowActor8
.proc ScrollFollowActor8
  jsr ScrollTargetActor

  lda ScrollTargetActor::TargetX
  sub ScrollX
  jsr Shift
  add ScrollX
  sta ScrollX

  lda ScrollTargetActor::TargetX
  sub ScrollX
  jsr Shift
  add ScrollX
  sta ScrollX
  rtl

Shift:
  asr_n 3
  jmp ScrollSpeedLimit
.endproc

; Sets LevelBlockPtr to point to a specific coordinate in the level
; input: A (X position in 12.4 format), Y (Y position in 12.4 format)
.export GetLevelPtrXY
.proc GetLevelPtrXY
  ; X position * 128
  lsr
  and #%0011111110000000
  sta LevelBlockPtr
  ; 00xxxxxxx0000000

  ; Y position
  tya
  xba
  and #127
  tsb LevelBlockPtr
  ; 00xxxxxxxyyyyyyy

  lda [LevelBlockPtr]
  and #255
  rtl
.endproc
