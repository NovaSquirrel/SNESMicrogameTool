.include "snes.inc"
.include "global.inc"
.include "memory.inc"
.smart

.segment "CODE"


.export StartMicrogame
.proc StartMicrogame
  setaxy8
  .import example_GameData
  lda #<example_GameData
  sta GameDataPointer+0
  lda #>example_GameData
  sta GameDataPointer+1
  lda #^example_GameData
  sta GameDataPointer+2
  sta GameDataPointer_BlockUL+2
  sta GameDataPointer_BlockUR+2
  sta GameDataPointer_BlockLL+2
  sta GameDataPointer_BlockLR+2
  sta GameDataPointer_BlockFlags+2
  sta GameDataPointer_ActorInit+2
  sta GameDataPointer_ActorRun+2

  ; Load in the pointers
  seta16
  ldy #5
  lda [GameDataPointer],y
  sta GameDataPointer_BlockUL
  iny
  iny
  lda [GameDataPointer],y
  sta GameDataPointer_BlockUR
  iny
  iny
  lda [GameDataPointer],y
  sta GameDataPointer_BlockLL
  iny
  iny
  lda [GameDataPointer],y
  sta GameDataPointer_BlockLR
  iny
  iny
  lda [GameDataPointer],y
  sta GameDataPointer_BlockFlags
  ldy #16+1
  lda [GameDataPointer],y
  sta GameDataPointer_ActorRun
  iny
  iny
  lda [GameDataPointer],y
  sta GameDataPointer_ActorInit



  ; Palettes
  lda #DMAMODE_CGDATA
  sta DMAMODE
  lda [GameDataPointer]
  sta DMAADDR
  lda #16*2
  sta DMALEN
  seta8
  lda GameDataPointer+2
  sta DMAADDRBANK
  stz CGADDR
  lda #1
  sta COPYSTART

  ; CHR
  seta16
  lda #DMAMODE_PPUDATA
  sta DMAMODE
  ldy #10*2+1
  lda [GameDataPointer],y
  sta DMALEN
  ldy #2+1
  lda [GameDataPointer],y
  sta DMAADDR
  seta8
  ldy #2
  lda [GameDataPointer],y
  sta DMAADDRBANK
  stz PPUADDR
  stz PPUADDR
  lda #1
  sta COPYSTART


  setxy16
  ldx #0
  ldy #128*128
  .import MemClear7F
  jsl MemClear7F

  ; Load map zero
  lda #0
  jsr LoadMicrogameMap

  jmp MicrogameLoop
.endproc

.proc LoadMicrogameMap
Pointer = DecodePointer
MapNum = 3
ActorList = 4 ; Word
ColumnsLeft = 6
RowsLeft = 7
  setaxy8
  sta MapNum

  lda GameDataPointer+2
  sta Pointer+2

  seta16
  ldy #7*2+1 ; Map list
  lda [GameDataPointer],y
  sta Pointer

  ; Select the correct map
  lda MapNum
  and #255
  asl
  tay
  lda [Pointer],y
  sta Pointer

  seta8
  ; Background color
  stz CGADDR
  lda [Pointer]
  sta CGDATA
  ldy #1
  lda [Pointer],y
  sta CGDATA

  ; Get actor list pointer
  iny
  lda [Pointer],y
  sta ActorList+0
  iny
  lda [Pointer],y
  sta ActorList+1

  ; Get width and height
  iny
  lda [Pointer],y
  sta MapWidth
  sta ColumnsLeft
  iny
  lda [Pointer],y
  sta MapHeight
  sta RowsLeft
  setxy16

  lda #^LevelMap
  pha
  plb

  ; Now Y points at the map data itself
  ldx #0
Loop:
  lda [Pointer],y
  iny
  sta LevelMap,x
  inx
  dec RowsLeft
  bne Loop
  ; Next column
  lda MapHeight
  sta RowsLeft
  seta16
  txa
  and #.loword(~127) ; Reset to the first row
  add #128           ; Move down a column
  tax
  seta8
  dec ColumnsLeft
  bne Loop

  ; Clear the actor list
  ldx #ActorStart
: stz 0,x
  inx
  cpx #ActorEnd
  bne :-

  ; Change the data bank to the game's bank
  lda GameDataPointer+2
  pha
  plb

  ; -----------------------------------------------------

  ; Insert all of the actors and run their init routines
  seta16
  lda ActorList
  sta Pointer

  ldx #ActorStart
  .import CallActorInit
ActorLoop:
  lda [Pointer],y
  iny
  and #255
  cmp #255
  beq LastActor
  sta ActorType,x

  lda [Pointer],y
  sta ActorPX,x
  iny
  iny
  lda [Pointer],y
  sta ActorPY,x
  iny
  iny

  ; Attributes, 128 is yflip, 64 is xflip
  lda [Pointer],y
  and #255
  iny

  phy
  stx ThisActor
;  jsl CallActorInit
  ply

  txa
  add #ActorSize
  tax
  bra ActorLoop
LastActor:

  ; Set up PPU registers and stuff
  seta8
  lda #1
  sta BGMODE       ; mode 1

  stz BGCHRADDR+0  ; bg planes 0-1 CHR at $0000
  lda #$e>>1
  sta BGCHRADDR+1  ; bg plane 2 CHR at $e000
  lda #$8000 >> 14
  sta OBSEL      ; sprite CHR at $8000, sprites are 8x8 and 16x16
  lda #1 | ($c000 >> 9)
  sta NTADDR+0   ; plane 0 nametable at $c000, 2 screens wide
  lda #0 | ($d000 >> 9)
  sta NTADDR+1   ; plane 1 nametable at $d000, 1 screen
  lda #0 | ($e000 >> 9)
  sta NTADDR+2   ; plane 2 nametable at $e000, 1 screen

  stz PPURES
  lda #%00000011  ; enable plane 0 and 1
  sta BLENDMAIN
  stz BLENDSUB
  lda #VBLANK_NMI|AUTOREAD  ; but disable htime/vtime IRQ
  sta PPUNMI
  stz CGWSEL
  stz CGADSUB

  ; Render the screen
  lda #$7f
  sta LevelBlockPtr+2
  .import RenderLevelScreens
  jsl RenderLevelScreens

  ldy #0
  ldx #($d000 >> 1)
  jsl ppu_clear_nt
  rts
.endproc

.proc MicrogameLoop
Loop:
  jsl WaitVblank
  seta8
  lda #15
  sta PPUBRIGHT

  lda #$01
padwait:
  bit VBLSTATUS
  bne padwait

  seta16
  lda ScrollX
  lsr
  lsr
  lsr
  lsr
  sta 0

  lda ScrollY
  lsr
  lsr
  lsr
  lsr
  dec a ; SNES displays lines 1-224 so shift it up to 0-223
  sta 2
  seta8

  lda 0
  sta BGSCROLLX
  lda 1
  sta BGSCROLLX
  lda 2
  sta BGSCROLLY
  lda 3
  sta BGSCROLLY

  ; Update keys
  seta16
  lda keydown
  sta keylast
  lda JOY1CUR
  sta keydown
  lda keylast
  eor #$ffff
  and keydown
  sta keynew



  jmp Loop
.endproc

.proc WaitVblank
  php
  seta8
loop1:
  bit VBLSTATUS  ; Wait for leaving previous vblank
  bmi loop1
loop2:
  wai
  bit VBLSTATUS  ; Wait for start of this vblank
  bpl loop2
  plp
  rtl
.endproc
