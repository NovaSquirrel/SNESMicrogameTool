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
.proc SpeedAngle2Offset ; A = speed, Y = angle -> 0,1(X) 2,3(Y)
Angle = 4
Speed = 5
  sty Angle
  sta Speed

  lda CosineTable,y
  php
  abs
  ldy Speed
  jsr mul8
  sty 0
  sta 1

  plp
  bpl :+
  neg16 0, 1
:

  ldy Angle
  lda SineTable,y
  php
  abs
  ldy Speed
  jsr mul8
  sty 2
  sta 3
  plp
  bpl :+
  neg16 2, 3
:
  rts
.endproc

; Adds an actor's speed to its position
.proc ActorApplyVelocity
  lda ActorPXL,x
  add ActorVXL,x
  sta ActorPXL,x

  lda ActorPXH,x
  adc ActorVXH,x
  sta ActorPXH,x

  ; ------------

  lda ActorPYL,x
  add ActorVYL,x
  sta ActorPYL,x

  lda ActorPYH,x
  adc ActorVYH,x
  sta ActorPYH,x
  rts
.endproc

.proc ActorBallMovement
  ldy ActorDir,x
  lda ActorSpeed,x
  jsr SpeedAngle2Offset ; A = speed, Y = angle -> 0,1(X) 2,3(Y)
  lda 0
  sta ActorVXL,x
  lda 1
  sta ActorVXH,x
  lda 2
  sta ActorVYL,x
  lda 3
  sta ActorVYH,x
  jmp ActorApplyVelocity
.endproc

; Inputs: A (Allowed directions)
.proc Actor8WayMovement
  and keydown
  sta 0

  and #KEY_LEFT
  beq :+
    lda ActorPXH,x
    sub ActorSpeed,x
    sta ActorPXH,x
  :

  lda 0
  and #KEY_RIGHT
  beq :+
    lda ActorPXH,x
    add ActorSpeed,x
    sta ActorPXH,x
  :

  lda 0
  and #KEY_DOWN
  beq :+
    lda ActorPYH,x
    add ActorSpeed,x
    sta ActorPYH,x
  :

  lda 0
  and #KEY_UP
  beq :+
    lda ActorPYH,x
    sub ActorSpeed,x
    sta ActorPYH,x
  :
  rts
.endproc

; Inputs: A (Actor type to find)
; Outputs: Carry (success), OtherActor (found index)
.proc ActorFindType
  ldy #NUM_ACTORS-1
: cmp ActorType,y
  beq Found
  dey
  bpl :-
Fail:
  ldy #INVALID_ACTOR
  sty OtherActor
  clc
  rts
Found:
  sty OtherActor
  sec
  rts
.endproc

; Finds a free actor slot
; Outputs: OtherActor (index), Carry (success)
.proc ActorFindFree
  ldy #NUM_ACTORS-1
: lda ActorType,y
  beq ActorFindType::Found
  dey
  bpl :-
  bmi ActorFindType::Fail ; unconditional
.endproc

; Inputs: 0(X), 1(Y), A(Type)
; Outputs: OtherActor (index)
.proc ActorCreateAtXY
  sta 2
  jsr ActorFindFree
  bcc Fail
  jsr ActorClearY
  lda 0
  sta ActorPXH,y
  lda 1
  sta ActorPYH,y
  lda 2
  sta ActorType,y

  txa ; Save this actor's index
  pha
    lda OtherActor
    pha
      tya
      tax
      sta ThisActor
      jsr CallActorInit
    pla
    sta OtherActor
  pla ; Restore this actor's index
  tax
  stx ThisActor

  sec
  rts
Fail:
  clc
  rts
.endproc

; Clears most fields of an actor
.proc ActorClearY
  lda #0
  sta ActorType,y
  sta ActorDir,y
  sta ActorPXL,y
  sta ActorPYL,y
  sta ActorVar1,y
  sta ActorVar2,y
  sta ActorVar3,y
  sta ActorVar4,y
Stop:
  sta ActorSpeed,y
  sta ActorVXL,y
  sta ActorVXH,y
  sta ActorVYL,y
  sta ActorVYH,y
  rts
.endproc
ActorStop = ActorClearY::Stop

.proc ActorReverse
  lda ActorDir,x
  eor #16
  sta ActorDir,x

  ; Also negate the velocity
  lda #0
  sub ActorVXL,x
  sta ActorVXL,x
  lda #0
  sbc ActorVXH,x
  sta ActorVXH,x

  lda #0
  sub ActorVYL,x
  sta ActorVYL,x
  lda #0
  sbc ActorVYH,x
  sta ActorVYH,x
  rts
.endproc

; Inputs: A (type of actor to destroy)
.proc ActorDestroyType
  ldy #NUM_ACTORS-1
Loop:
  cmp ActorType,y
  bne :+
    pha
    lda #0
    sta ActorType,y
    pla
  :
  dey
  bpl :-
  rts
.endproc

; Set position to another actor's position
.proc ActorJumpToActor
  ldy OtherActor
  lda ActorPXL,y
  sta ActorPXL,x
  lda ActorPXH,y
  sta ActorPXH,x
  lda ActorPYL,y
  sta ActorPYL,x
  lda ActorPYH,y
  sta ActorPYH,x
  rts
.endproc

; Inputs: A (X), 0 (Y)
.proc ActorJumpToXY
  sta ActorPXH,x
  lda 0
  sta ActorPYH,x
  lda #0
  sta ActorPXL,x
  sta ActorPYL,x
  rts
.endproc

; Swap positions
.proc ActorSwapWithActor
  ldy OtherActor
  swaparray ActorPXL
  swaparray ActorPXH
  swaparray ActorPYL
  swaparray ActorPYH
  rts
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
  sta 1
GotMask:
  ; Now find the number

:  jsr huge_rand
   and 1 ; Mask it to make the range smaller
   cmp 0 ; Too big?
   beq :+
   bcs :-
:  rts
.endproc

; Inputs: A (number the random result has to be greater or equal to)
.proc RandomChance
  sta 0
  jsr huge_rand
  cmp 0
  rts
.endproc

.proc WinGame
  lda #1
  sta MicrogameWon
  rts
.endproc

.proc LoseGame
  lda #1
  sta MicrogameLost
  rts
.endproc

; todo
.proc PlaySoundEffect
  rts
.endproc

; Test if the actor is in the region defined by A (X1), 0 (X2), 1 (Y1), 2 (Y2)
.proc ActorInRegion
  sta 4

  lda ActorPXH,x
  cmp 4
  bcc No
  cmp 0
  bcs No

  lda ActorPYH,x
  cmp 1
  bcc No
  cmp 2
  bcs No

Yes:
  sec
  rts
No:
  clc
  rts
.endproc

; todo
.proc ActorTouchingType
  clc
  rts
.endproc

.proc ActorLookAtActor
  ldy OtherActor
  lda ActorPXH,x
  sta 0
  lda ActorPYH,x
  sta 1
  lda ActorPXH,y
  sta 2
  lda ActorPYH,y
  sta 3

  jsr getAngle
  sta ActorDir,x
  ldy OtherActor
  rts
.endproc

; Look towards a point. A (X) 0 (Y)
.proc ActorLookAtPoint
  sta 2
  lda 0
  sta 3
    lda ActorPXH,x
  sta 0
  lda ActorPYH,x
  sta 1

  jsr getAngle
  sta ActorDir,x
  rts
.endproc
