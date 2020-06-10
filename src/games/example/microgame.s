.include "../../snes.inc"
.include "../../global.inc"
.include "../../memory.inc"
.a16
.i16
.export example_GameData

.segment "GameChr_example"

.proc example_ChrData
  .byt $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
  .byt $00, $00, $00, $00, $00, $00, $03, $00, $04, $03, $04, $03, $08, $07, $00, $0F, $00, $00, $00, $00, $00, $00, $03, $03, $04, $07, $04, $07, $08, $0F, $00, $0F
  .byt $00, $00, $00, $00, $00, $00, $00, $C0, $00, $E0, $00, $E0, $40, $B0, $40, $B0, $00, $00, $00, $00, $00, $00, $00, $80, $00, $C0, $00, $C0, $40, $E0, $40, $E0
  .byt $08, $07, $00, $0F, $00, $0F, $01, $06, $00, $07, $00, $03, $00, $00, $00, $00, $08, $0F, $00, $0F, $00, $07, $01, $07, $00, $03, $00, $00, $00, $00, $00, $00
  .byt $40, $B0, $C0, $30, $C0, $30, $80, $60, $00, $E0, $00, $C0, $00, $00, $00, $00, $40, $E0, $C0, $E0, $C0, $C0, $80, $C0, $00, $80, $00, $00, $00, $00, $00, $00
  .byt $00, $00, $00, $00, $3F, $3F, $20, $3F, $2C, $3F, $2B, $3F, $2B, $3F, $2C, $3F, $FF, $FF, $FF, $FF, $C0, $FF, $DF, $FF, $D3, $F3, $D4, $F4, $D4, $F4, $D3, $F3
  .byt $00, $01, $00, $03, $FC, $FF, $04, $FF, $74, $FF, $B4, $FF, $B4, $FF, $74, $FF, $FF, $FF, $FF, $FF, $03, $FF, $FB, $FF, $8B, $8F, $4B, $4F, $4B, $4F, $8B, $8F
  .byt $2D, $3F, $2C, $3F, $2D, $3F, $2C, $3F, $20, $3F, $3F, $3F, $00, $7F, $00, $FF, $D2, $F2, $D3, $F3, $D2, $F2, $D3, $F3, $DF, $FF, $C0, $FF, $FF, $FF, $FF, $FF
  .byt $F4, $FF, $34, $FF, $F4, $FF, $34, $FF, $04, $FF, $FC, $FF, $00, $FF, $00, $FF, $0B, $0F, $CB, $CF, $0B, $0F, $CB, $CF, $FB, $FF, $03, $FF, $FF, $FF, $FF, $FF
  .byt $00, $FF, $FF, $00, $00, $00, $FF, $FF, $00, $FF, $00, $00, $00, $00, $00, $00, $FF, $FF, $FF, $FF, $FF, $FF, $00, $FF, $FF, $FF, $00, $00, $00, $00, $00, $00
  .byt $00, $FE, $FC, $03, $00, $01, $FC, $FF, $00, $FE, $00, $08, $00, $08, $00, $00, $FE, $FE, $FF, $FF, $FF, $FF, $03, $FF, $FE, $FE, $08, $08, $08, $08, $00, $00
  .byt $FF, $FF, $FF, $FF, $FF, $FF, $BF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FD, $FF, $00, $00, $00, $00, $00, $00, $40, $40, $00, $00, $00, $00, $00, $00, $02, $02
  .byt $FE, $FF, $7E, $FF, $FE, $FF, $FE, $FF, $FA, $FF, $FE, $FF, $FE, $FF, $FE, $FF, $01, $01, $81, $81, $01, $01, $01, $01, $05, $05, $01, $01, $01, $01, $01, $01
  .byt $FF, $FF, $FF, $FF, $FF, $FF, $DF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $00, $00, $00, $00, $00, $00, $20, $20, $00, $00, $00, $00, $00, $00, $00, $00
  .byt $FE, $FF, $FE, $FF, $FE, $FF, $FE, $FF, $FE, $FF, $EE, $FF, $FE, $FF, $FE, $FF, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $11, $11, $01, $01, $01, $01
  .byt $00, $00, $00, $1C, $1C, $3E, $22, $7F, $41, $E3, $41, $E3, $41, $E3, $41, $E3, $00, $00, $1C, $1C, $22, $22, $5D, $5D, $A2, $A2, $A2, $A2, $A2, $A2, $A2, $A2
  .byt $00, $00, $00, $00, $00, $00, $00, $00, $00, $80, $00, $80, $00, $80, $00, $A0, $00, $00, $00, $00, $00, $00, $00, $00, $80, $80, $80, $80, $80, $80, $A0, $A0
  .byt $22, $7F, $1D, $3F, $00, $1D, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $5D, $5D, $22, $22, $1D, $1D, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
  .byt $20, $70, $40, $E0, $80, $C4, $44, $EE, $28, $7C, $10, $38, $00, $10, $00, $00, $50, $50, $A0, $A0, $44, $44, $AA, $AA, $54, $54, $28, $28, $10, $10, $00, $00
  .byt $0C, $00, $F3, $0C, $00, $FF, $0C, $FF, $FF, $FF, $BB, $FF, $FF, $FF, $CF, $FF, $0C, $0C, $FF, $F3, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00
  .byt $30, $00, $CF, $30, $00, $FF, $30, $FF, $F3, $FF, $F3, $FF, $FF, $FF, $DF, $FF, $30, $30, $FF, $CF, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00
  .byt $CF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00
  .byt $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00
  .byt $7F, $FF, $7F, $FF, $7F, $FF, $3F, $FF, $7F, $FF, $7F, $FF, $7F, $FF, $7D, $FF, $80, $80, $80, $80, $80, $80, $C0, $C0, $80, $80, $80, $80, $80, $80, $82, $82
  .byt $FF, $FF, $7F, $FF, $FF, $FF, $FF, $FF, $FB, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $00, $00, $80, $80, $00, $00, $00, $00, $04, $04, $00, $00, $00, $00, $00, $00
  .byt $7F, $FF, $7F, $FF, $7F, $FF, $5F, $FF, $7F, $FF, $7F, $FF, $7F, $FF, $7F, $FF, $80, $80, $80, $80, $80, $80, $A0, $A0, $80, $80, $80, $80, $80, $80, $80, $80
  .byt $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $EF, $FF, $FF, $FF, $FF, $FF, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $10, $10, $00, $00, $00, $00
  .byt $01, $00, $41, $00, $73, $40, $3F, $1F, $1B, $12, $16, $16, $3F, $1F, $FB, $13, $01, $01, $63, $63, $3F, $7F, $20, $3F, $2D, $3F, $29, $3F, $60, $7F, $EC, $FF
  .byt $80, $80, $42, $40, $2E, $22, $F8, $F8, $6C, $4C, $D8, $D8, $FC, $F8, $EF, $C8, $00, $80, $86, $C6, $DC, $FE, $04, $FC, $B0, $FC, $24, $FC, $06, $FE, $37, $FF
  .byt $97, $97, $5F, $5F, $3B, $32, $16, $16, $3F, $1F, $2B, $08, $61, $20, $01, $00, $68, $FF, $20, $7F, $0D, $3F, $29, $3F, $20, $3F, $77, $7F, $43, $63, $01, $01
  .byt $D9, $D9, $FA, $FA, $6C, $4C, $DC, $DC, $F8, $F8, $36, $32, $42, $40, $80, $80, $26, $FF, $04, $FE, $B0, $FC, $20, $FC, $04, $FC, $CC, $FE, $86, $C6, $00, $80
  .byt $00, $FF, $00, $FF, $FF, $00, $FF, $00, $AA, $00, $55, $00, $00, $00, $FF, $FF, $FF, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $FF, $00
  .byt $00, $F0, $00, $FC, $F8, $02, $FC, $01, $A8, $01, $52, $03, $06, $07, $F8, $FF, $F0, $F0, $0C, $FC, $02, $FE, $01, $FF, $01, $FF, $03, $FD, $07, $F9, $FF, $07
  .byt $00, $FF, $FF, $FF, $FF, $FF, $DF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $00, $00, $00, $00, $20, $20, $00, $00, $00, $00, $00, $00, $00, $00
  .byt $06, $FF, $FE, $FF, $FE, $FF, $FE, $FF, $FE, $FF, $EE, $FF, $FE, $FF, $FE, $FF, $F9, $F9, $01, $01, $01, $01, $01, $01, $01, $01, $11, $11, $01, $01, $01, $01
  .byt $3F, $3F, $40, $7F, $9F, $E0, $90, $EF, $A7, $D8, $A8, $D7, $AB, $D4, $AA, $D5, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
  .byt $FC, $FC, $02, $FE, $F9, $07, $0D, $F3, $E5, $1B, $15, $EB, $D5, $2B, $55, $AB, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
  .byt $AA, $D5, $A9, $D6, $AC, $D3, $A7, $D8, $90, $EF, $9F, $E0, $40, $7F, $3F, $3F, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
  .byt $55, $AB, $95, $6B, $15, $EB, $E5, $1B, $0D, $F3, $F1, $0F, $02, $FE, $FC, $FC, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
  .byt $50, $B0, $50, $B0, $5F, $BF, $4F, $B0, $50, $BF, $5F, $BF, $50, $B0, $50, $B0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
  .byt $05, $0B, $05, $0B, $F5, $FB, $F5, $0B, $0D, $FB, $F5, $FB, $05, $0B, $05, $0B, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
  .byt $00, $0F, $00, $3F, $0F, $70, $3F, $C0, $2A, $80, $15, $C0, $00, $80, $3F, $FF, $0F, $0F, $30, $3F, $40, $7F, $80, $FF, $80, $FF, $80, $FF, $80, $FF, $FF, $C0
  .byt $40, $FF, $7F, $FF, $7F, $FF, $5F, $FF, $7F, $FF, $7F, $FF, $7F, $FF, $7F, $FF, $BF, $BF, $80, $80, $80, $80, $A0, $A0, $80, $80, $80, $80, $80, $80, $80, $80
  .byt $00, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $EF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $00, $00, $00, $00, $00, $00, $00, $00, $10, $10, $00, $00, $00, $00
  .byt $00, $00, $00, $00, $01, $0F, $0A, $1F, $05, $1F, $0B, $1F, $1F, $1F, $0F, $0F, $00, $00, $00, $00, $0F, $00, $1F, $00, $1F, $00, $1F, $00, $1F, $00, $0F, $00
  .byt $00, $00, $00, $00, $50, $F0, $A8, $F8, $78, $F8, $F8, $F8, $F8, $F8, $F0, $F0, $00, $00, $00, $00, $F0, $00, $F8, $00, $F8, $00, $F8, $00, $F8, $00, $F0, $00
  .byt $01, $00, $01, $00, $01, $00, $01, $00, $0F, $00, $39, $00, $71, $00, $41, $00, $00, $01, $00, $01, $00, $01, $00, $01, $00, $0F, $00, $3F, $00, $7D, $00, $79
  .byt $00, $00, $1C, $00, $70, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80, $00, $9C, $00, $FE, $00, $FC, $00, $B0, $00, $80, $00, $80, $00, $80
  .byt $00, $FF, $D0, $01, $82, $03, $2E, $2F, $00, $FF, $0D, $10, $28, $30, $E2, $F2, $FF, $FF, $FF, $D1, $FD, $81, $D1, $01, $FF, $FF, $FF, $1D, $DF, $18, $1D, $10
  .byt $00, $00, $03, $00, $03, $00, $0E, $00, $0C, $00, $0C, $01, $0B, $00, $03, $00, $00, $00, $03, $03, $03, $03, $0F, $0F, $0F, $0F, $0E, $0E, $0F, $0F, $03, $03
  .byt $00, $00, $C0, $00, $80, $00, $70, $00, $60, $80, $E0, $00, $C0, $00, $80, $00, $00, $00, $C0, $C0, $C0, $C0, $F0, $F0, $70, $70, $F0, $70, $F0, $F0, $C0, $C0
  .byt $02, $00, $01, $00, $01, $00, $01, $00, $0F, $00, $39, $00, $71, $00, $41, $00, $03, $03, $00, $01, $00, $01, $00, $01, $00, $0F, $00, $3F, $00, $7D, $00, $79
  .byt $00, $00, $1C, $00, $70, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $C0, $C0, $00, $9C, $00, $FE, $00, $FC, $00, $B0, $00, $80, $00, $80, $00, $80
  .byt $FF, $80, $80, $FF, $88, $FF, $FF, $FF, $FF, $80, $80, $FF, $86, $FF, $FF, $FF, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
  .byt $FF, $01, $01, $FF, $19, $FF, $FF, $FF, $FF, $09, $01, $FF, $01, $FF, $FF, $FF, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
  .byt $FF, $90, $80, $FF, $80, $FF, $FF, $FF, $FF, $80, $80, $FF, $84, $FF, $FF, $FF, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
  .byt $FF, $01, $01, $FF, $81, $FF, $FF, $FF, $FF, $01, $01, $FF, $E9, $FF, $FF, $FF, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
  .byt $00, $00, $00, $00, $00, $00, $38, $00, $28, $18, $EF, $18, $80, $7F, $EF, $FF, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
  .byt $00, $00, $00, $00, $00, $00, $1C, $04, $14, $0C, $F7, $0F, $01, $FF, $F7, $FF, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
  .byt $28, $18, $28, $18, $EF, $18, $80, $7F, $EF, $FF, $28, $18, $28, $18, $38, $38, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
  .byt $14, $0C, $14, $0C, $F7, $0F, $01, $FF, $F7, $FF, $14, $0C, $14, $0C, $1C, $1C, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
  .byt $00, $00, $00, $00, $0F, $00, $3C, $03, $73, $0C, $4C, $33, $30, $0F, $00, $0F, $00, $00, $00, $00, $0F, $0F, $3C, $3F, $73, $7F, $4C, $7F, $30, $3C, $00, $00
  .byt $00, $00, $00, $00, $F0, $00, $C0, $3C, $00, $FE, $00, $FE, $00, $FC, $00, $F0, $00, $00, $00, $00, $F0, $F0, $C0, $F0, $00, $CC, $00, $30, $00, $C0, $00, $00
  .byt $00, $FF, $00, $FF, $3F, $C0, $3F, $C0, $3F, $C0, $3F, $C0, $3F, $C0, $3F, $C0, $FF, $FF, $80, $FF, $80, $FF, $80, $FF, $80, $FF, $80, $FF, $80, $FF, $80, $FF
  .byt $00, $FF, $00, $FF, $FC, $01, $FC, $01, $FC, $01, $FC, $01, $FC, $01, $FC, $01, $FF, $FF, $01, $FF, $01, $FF, $01, $FF, $01, $FF, $01, $FF, $01, $FF, $01, $FF
  .byt $3F, $C0, $3F, $C0, $3F, $C0, $3F, $C0, $3F, $C0, $3F, $C0, $00, $C0, $00, $FF, $80, $FF, $80, $FF, $80, $FF, $80, $FF, $80, $FF, $80, $FF, $80, $FF, $FF, $FF
  .byt $FC, $01, $FC, $01, $FC, $01, $FC, $01, $FC, $01, $FC, $01, $00, $01, $00, $FF, $01, $FF, $01, $FF, $01, $FF, $01, $FF, $01, $FF, $01, $FF, $01, $FF, $FF, $FF
  .byt $00, $00, $00, $00, $04, $00, $1A, $00, $15, $00, $10, $00, $10, $10, $0F, $0F, $00, $00, $00, $00, $0C, $04, $1F, $1A, $1F, $15, $1F, $10, $0F, $00, $00, $00
  .byt $00, $00, $00, $00, $58, $08, $A0, $00, $48, $08, $10, $10, $20, $20, $C0, $C0, $00, $00, $00, $00, $F0, $50, $F8, $A0, $F0, $40, $E0, $00, $C0, $00, $00, $00
.endproc
example_EndChrData:

.segment "GameSpriteChr_example"

.proc example_SpriteChrData
  .byt $00, $00, $00, $57, $00, $55, $00, $55, $00, $25, $00, $27, $00, $00, $00, $00, $00, $00, $57, $57, $55, $55, $55, $55, $25, $25, $27, $27, $00, $00, $00, $00
  .byt $00, $00, $00, $50, $00, $50, $00, $50, $00, $54, $00, $74, $00, $04, $00, $18, $00, $00, $50, $50, $50, $50, $50, $50, $54, $54, $74, $74, $04, $04, $18, $18
  .byt $00, $07, $00, $1F, $06, $39, $0C, $73, $18, $67, $30, $CF, $30, $CF, $20, $DF, $07, $07, $1F, $18, $3F, $26, $7F, $4C, $7F, $58, $FF, $B0, $FF, $B0, $FF, $A0
  .byt $00, $E0, $00, $F8, $00, $FC, $00, $FE, $00, $FE, $00, $FF, $00, $FF, $00, $FF, $E0, $E0, $F8, $18, $FC, $04, $FE, $02, $FE, $02, $FF, $01, $FF, $01, $FF, $01
  .byt $00, $07, $00, $1F, $00, $3F, $00, $7F, $02, $7D, $02, $FD, $02, $FD, $00, $FF, $07, $07, $18, $1F, $20, $3F, $4E, $7F, $4E, $7F, $8E, $FF, $8E, $FF, $80, $FF
  .byt $00, $E0, $00, $F8, $00, $FC, $00, $FE, $10, $EE, $10, $EF, $10, $EF, $00, $FF, $E0, $E0, $18, $F8, $04, $FC, $72, $FE, $72, $FE, $71, $FF, $71, $FF, $01, $FF
  .byt $00, $00, $00, $03, $03, $0C, $0F, $30, $3F, $40, $3F, $40, $7F, $80, $7F, $80, $00, $00, $03, $03, $0C, $0C, $30, $30, $44, $44, $40, $40, $90, $90, $82, $82
  .byt $00, $00, $00, $C0, $C0, $30, $F0, $0C, $FC, $02, $FC, $02, $FE, $01, $FE, $01, $00, $00, $C0, $C0, $30, $30, $0C, $0C, $42, $42, $0A, $0A, $01, $01, $21, $21
  .byt $70, $70, $7C, $4C, $FE, $82, $BF, $D3, $FF, $80, $FD, $82, $6F, $50, $7F, $60, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
  .byt $0E, $0E, $3E, $32, $7F, $41, $FB, $C5, $FF, $09, $DF, $21, $FE, $02, $F6, $8E, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
  .byt 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
  .byt 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
  .byt 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
  .byt 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
  .byt 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
  .byt 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
  .byt $00, $00, $00, $00, $00, $01, $00, $09, $00, $05, $00, $03, $00, $01, $00, $00, $00, $00, $00, $00, $01, $01, $09, $09, $05, $05, $03, $03, $01, $01, $00, $00
  .byt $00, $60, $00, $80, $00, $00, $00, $20, $00, $40, $00, $80, $00, $00, $00, $00, $60, $60, $80, $80, $00, $00, $20, $20, $40, $40, $80, $80, $00, $00, $00, $00
  .byt $00, $FF, $00, $FF, $00, $FF, $00, $7F, $00, $7F, $00, $3F, $00, $1F, $00, $07, $FF, $80, $FF, $80, $FF, $80, $7F, $40, $7F, $40, $3F, $20, $1F, $18, $07, $07
  .byt $00, $FF, $04, $FF, $08, $FF, $14, $FE, $28, $FE, $50, $FC, $00, $F8, $00, $E0, $FF, $01, $FF, $01, $FF, $03, $FE, $02, $FE, $02, $FC, $04, $F8, $18, $E0, $E0
  .byt $00, $FF, $00, $FF, $00, $FF, $00, $7F, $00, $7F, $00, $3F, $00, $1F, $00, $07, $80, $FF, $90, $FF, $88, $FF, $47, $7F, $40, $7F, $20, $3F, $18, $1F, $07, $07
  .byt $00, $FF, $00, $FF, $00, $FF, $00, $FE, $00, $FE, $00, $FC, $00, $F8, $00, $E0, $01, $FF, $09, $FF, $11, $FF, $E2, $FE, $02, $FE, $04, $FC, $18, $F8, $E0, $E0
  .byt $0F, $F0, $40, $FF, $78, $FF, $0C, $FF, $70, $8F, $7F, $80, $0F, $70, $00, $0F, $F0, $F0, $8F, $BF, $80, $87, $F0, $F3, $8F, $8F, $80, $80, $70, $70, $0F, $0F
  .byt $F0, $0F, $02, $FF, $1E, $FF, $30, $FF, $0E, $F1, $FE, $01, $F0, $0E, $00, $F0, $0F, $0F, $F1, $FD, $01, $E1, $0F, $CF, $F1, $F1, $01, $01, $0E, $0E, $F0, $F0
  .byt $7D, $42, $7F, $40, $7F, $44, $7D, $42, $5F, $60, $7B, $54, $7F, $40, $7F, $7F, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
  .byt $FE, $02, $FE, $02, $76, $8A, $FE, $22, $FE, $06, $FE, $02, $DE, $A2, $FE, $FE, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.endproc
example_EndSpriteChrData:

.segment "BSS"

Variable_coins: .res 2
Variable_has_key: .res 2
.segment "GameData_example"

.proc example_GameData
.addr example_PalData
.byt ^example_ChrData, ^example_SpriteChrData
.addr example_ChrData
.addr example_BlockTopLeft
.addr example_BlockTopRight
.addr example_BlockBottomLeft
.addr example_BlockBottomRight
.addr example_BlockFlags
.addr example_MapList
.addr example_ActorRun
.addr example_ActorInit
.word 2208
.word 832
.addr example_SpriteChrData
.endproc

.enum example_ActorType
empty
ball
player
bread
youmarker
burger
.endenum

.proc example_PalData
  .word 0
  .word RGB8(248,216,152), RGB8(248,168,48), RGB8(192,72,0), RGB8(248,0,0), RGB8(200,104,232), RGB8(16,192,200), RGB8(40,104,192), RGB8(8,144,80), RGB8(112,208,56), RGB8(248,248,88), RGB8(120,120,120), RGB8(192,192,192), RGB8(248,248,248), RGB8(0,0,0), RGB8(15,15,15)
  .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ; dummy
  .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ; dummy
  .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ; dummy
  .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ; dummy
  .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ; dummy
  .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ; dummy
  .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ; dummy
  .word 0
  .word RGB8(248,216,152), RGB8(248,168,48), RGB8(192,72,0), RGB8(248,0,0), RGB8(200,104,232), RGB8(16,192,200), RGB8(40,104,192), RGB8(8,144,80), RGB8(112,208,56), RGB8(248,248,88), RGB8(120,120,120), RGB8(192,192,192), RGB8(248,248,248), RGB8(0,0,0), RGB8(15,15,15)
.endproc
example_EndPalData:

.proc example_BlockTopLeft
.word 0
.word 1
.word 5
.word 9
.word 11
.word 15
.word 19
.word 16394
.word 23
.word 27
.word 31
.word 35
.word 39
.word 41
.word 44
.word 48
.word 22
.word 49
.word 9
.word 11
.word 53
.word 57
.word 31
.word 61
.word 63
.word 67
.endproc

.proc example_BlockTopRight
.word 0
.word 2
.word 6
.word 10
.word 12
.word 16
.word 20
.word 9
.word 24
.word 28
.word 32
.word 36
.word 40
.word 31
.word 45
.word 48
.word 22
.word 50
.word 9
.word 24
.word 54
.word 58
.word 31
.word 62
.word 64
.word 68
.endproc

.proc example_BlockBottomLeft
.word 0
.word 3
.word 7
.word 0
.word 13
.word 17
.word 21
.word 0
.word 25
.word 29
.word 33
.word 37
.word 39
.word 42
.word 46
.word 48
.word 22
.word 51
.word 0
.word 13
.word 55
.word 59
.word 33
.word 46
.word 65
.word 46
.endproc

.proc example_BlockBottomRight
.word 0
.word 4
.word 8
.word 0
.word 14
.word 18
.word 22
.word 0
.word 26
.word 30
.word 34
.word 38
.word 40
.word 43
.word 47
.word 48
.word 22
.word 52
.word 0
.word 26
.word 56
.word 60
.word 43
.word 47
.word 66
.word 47
.endproc

.proc example_BlockFlags
.byt 0
.byt 0
.byt 192
.byt 64
.byt 192
.byt 0
.byt 0
.byt 64
.byt 192
.byt 192
.byt 192
.byt 192
.byt 0
.byt 192
.byt 0
.byt 0
.byt 0
.byt 0
.byt 64
.byt 192
.byt 192
.byt 0
.byt 192
.byt 0
.byt 192
.byt 0
.endproc

.enum example_Block
empty = 0
coin = 1
red_lock = 2
red_key = 5
spikes = 9
.endenum

.proc example_MapList
.addr example_MapData_map
.endproc

.proc example_MapData_map
.word RGB8(0,170,255)
.addr Actors
.byt 32, 16
.byt 0,0,0,0,0,0,0,1,0,0,0,1,0,22,19,19
.byt 0,0,0,0,0,1,0,0,0,1,0,0,0,22,19,19
.byt 0,0,0,0,0,0,0,1,0,0,0,1,0,22,19,19
.byt 0,0,0,0,0,0,0,0,0,11,11,11,11,22,19,19
.byt 0,0,0,0,0,1,1,1,0,11,20,20,20,22,19,19
.byt 0,0,0,0,0,1,1,1,0,11,20,20,20,22,19,19
.byt 0,0,0,0,0,1,1,1,0,11,20,20,20,22,19,19
.byt 0,0,0,0,0,0,12,12,12,11,11,11,11,22,19,19
.byt 0,0,0,0,0,0,15,0,0,12,12,12,12,22,19,19
.byt 0,0,0,0,0,15,0,0,0,1,0,1,0,22,19,19
.byt 0,0,0,0,15,0,0,0,0,0,1,0,0,22,19,19
.byt 0,0,0,0,15,0,0,0,0,1,0,1,21,22,19,19
.byt 0,0,0,9,15,0,0,0,0,0,1,0,21,10,4,4
.byt 0,0,0,0,15,0,0,0,0,0,0,0,0,0,6,16
.byt 0,0,0,0,15,0,0,0,0,0,0,0,0,0,6,16
.byt 0,0,0,0,15,0,0,0,0,0,21,11,0,0,6,16
.byt 0,0,0,9,15,0,0,0,0,0,21,11,0,0,6,16
.byt 0,0,0,0,15,0,0,1,0,1,25,13,8,8,8,8
.byt 0,0,0,0,15,0,0,0,1,0,14,22,19,19,19,19
.byt 0,0,0,0,7,0,0,1,0,1,23,22,19,19,19,19
.byt 0,0,0,0,18,0,0,0,1,0,17,10,4,4,4,4
.byt 0,0,0,0,3,0,0,0,0,0,0,0,6,16,16,16
.byt 0,0,0,0,0,0,0,0,0,0,0,7,6,16,16,16
.byt 0,0,0,0,0,0,0,0,0,0,0,18,6,16,16,16
.byt 0,0,0,0,7,0,0,0,0,0,0,3,6,16,16,16
.byt 0,0,0,0,18,0,0,0,0,0,0,0,6,16,16,16
.byt 0,0,0,0,3,0,0,0,0,0,21,13,8,8,8,8
.byt 24,24,24,2,24,0,0,0,0,5,21,22,19,19,19,19
.byt 24,1,1,1,24,0,0,0,0,0,21,10,4,4,4,4
.byt 24,1,1,1,24,0,0,0,0,0,0,11,20,20,20,20
.byt 24,1,1,1,24,0,0,0,0,0,0,11,20,20,20,20
.byt 24,24,24,24,24,9,9,9,9,9,9,11,20,20,20,20
Actors:
.byt example_ActorType::player, <4832, >4832, <2928, >2928, 0
.byt example_ActorType::bread, <6944, >6944, <2224, >2224, 0
.byt example_ActorType::bread, <7344, >7344, <1936, >1936, 0
.byt example_ActorType::bread, <7344, >7344, <1936, >1936, 0
.byt example_ActorType::bread, <7344, >7344, <1936, >1936, 0
.byt example_ActorType::bread, <7296, >7296, <2448, >2448, 0
.byt example_ActorType::bread, <7296, >7296, <2448, >2448, 0
.byt example_ActorType::bread, <7296, >7296, <2448, >2448, 0
.byt example_ActorType::bread, <7296, >7296, <2448, >2448, 0
.byt example_ActorType::bread, <7648, >7648, <2288, >2288, 0
.byt example_ActorType::bread, <7616, >7616, <2816, >2816, 0
.byt example_ActorType::ball, <3680, >3680, <640, >640, 0
.byt example_ActorType::youmarker, <4848, >4848, <2576, >2576, 0
.byt example_ActorType::burger, <1184, >1184, <1008, >1008, 0
.byt example_ActorType::ball, <864, >864, <1712, >1712, 0
.byt example_ActorType::ball, <6032, >6032, <2448, >2448, 0
.byt example_ActorType::burger, <6480, >6480, <880, >880, 0
.byt 255
.endproc

.proc example_ActorRun
.addr 0
.addr example_Actor_Run_ball
.addr example_Actor_Run_player
.addr 0
.addr example_Actor_Run_youmarker
.addr example_Actor_Run_burger
.endproc

.proc example_ActorInit
.addr 0
.addr example_Actor_Init_ball
.addr example_Actor_Init_player
.addr example_Actor_Init_bread
.addr example_Actor_Init_youmarker
.addr example_Actor_Init_burger
.endproc

.proc example_Run
Exit:
rts
.endproc

.proc example_Init
Exit:
rts
.endproc

.proc example_Actor_Run_ball
lda #4
jsl ActorFall

lda ActorOnGround,x
jeq lbl_1
lda #.loword(-40)
sta ActorVY,x

lbl_1:

Exit:
rts
.endproc

.proc example_Actor_Init_ball
lda #0;::blueball|0
sta ActorArt,x

Exit:
rts
.endproc

.proc example_Actor_Run_player
lda #768
jsl Actor8WayMovement

lda #4
jsl ActorFall

lda #KeyValue::K_B
and keynew
jeq lbl_3
lda ActorOnGround,x
jeq lbl_3
lda #.loword(-80)
sta ActorVY,x

lbl_3:

lda #example_Block::coin
jsl ActorOverlapBlock
jcc lbl_5
lda #example_Block::empty
jsl BlockChangeType

inc Variable_coins

lbl_5:

lda #example_Block::red_key
jsl ActorOverlapBlock
jcc lbl_7
lda #example_Block::empty
jsl BlockChangeType

inc Variable_has_key

lbl_7:

lda Variable_has_key
jeq lbl_9
lda #example_Block::red_lock
jsl ActorOverlapBlock
jcc lbl_9
lda #example_Block::empty
jsl BlockChangeType

dec Variable_has_key

lbl_9:


Exit:
rts
.endproc

.proc example_Actor_Init_player
lda #32
sta ActorSpeed,x


lda #0;::smiley|0
sta ActorArt,x

Exit:
rts
.endproc

.proc example_Actor_Init_bread
lda #0;::bread|0
sta ActorArt,x

Exit:
rts
.endproc

.proc example_Actor_Run_youmarker
inc ActorVarA,x

lda ActorVarA,x
cmp #30
jne lbl_11
lda #0
sta ActorType,x

lbl_11:

lda #example_ActorType::player
jsl ActorFindType

lda ActorPX,y
add #0
sta ActorPX,x

lda ActorPY,y
sub #256
sta ActorPY,x

Exit:
rts
.endproc

.proc example_Actor_Init_youmarker
lda #0;::youmarker|0
sta ActorArt,x

Exit:
rts
.endproc

.proc example_Actor_Run_burger
jsl ActorBallMovement

Exit:
rts
.endproc

.proc example_Actor_Init_burger
lda #0;::burger|0
sta ActorArt,x

jsl random
and #255
sta ActorDirection,x

lda #32
sta ActorSpeed,x

Exit:
rts
.endproc

