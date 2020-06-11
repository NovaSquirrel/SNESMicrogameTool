.globalzp keydown
.globalzp keynew
.globalzp keylast
.globalzp seed
.globalzp retraces
.globalzp OamPtr
.globalzp MicrogameTime
.globalzp MicrogameRealFrames
.globalzp MicrogameFrames
.globalzp DecodePointer, LevelBlockPtr
.globalzp ScrollX, ScrollY, TempVal

.globalzp MicrogameDifficulty
.globalzp MicrogameWon
.globalzp MicrogameLost
.globalzp MicrogameJustWon
.globalzp MicrogameJustLost

.globalzp MicrogameGlobals
.globalzp MicrogameTemp

.globalzp MapWidth
.globalzp MapHeight

.globalzp ThisActor
.globalzp OtherActor

.global   ActorStart
.globalzp ActorSize
.global   ActorEnd
.global   INVALID_ACTOR

ActorLen = 20
.globalzp ActorType
.globalzp ActorPX
.globalzp ActorPY
.globalzp ActorVX
.globalzp ActorVY
.globalzp ActorVarA 
.globalzp ActorVarB 
.globalzp ActorVarC
.globalzp ActorVarD
.globalzp ActorVarE
.globalzp ActorVarF
.globalzp ActorDirection
.globalzp ActorArt
.globalzp ActorSpeed
.globalzp ActorOnGround

.globalzp GameDataPointer
.globalzp GameDataPointer_BlockUL
.globalzp GameDataPointer_BlockUR
.globalzp GameDataPointer_BlockLL
.globalzp GameDataPointer_BlockLR
.globalzp GameDataPointer_BlockFlags
.globalzp GameDataPointer_ActorRun
.globalzp GameDataPointer_ActorInit
.globalzp GameDataPointer_Animations


.global OAM
.global OAMHI
OAM_XPOS = OAM+0
OAM_YPOS = OAM+1
OAM_TILE = OAM+2
OAM_ATTR = OAM+3

.global LevelMap

.global ColumnUpdateAddress
.global ColumnUpdateBuffer
.global RowUpdateAddress
.global RowUpdateBuffer

BLOCK_UPDATE_COUNT = 8
.global BlockUpdateAddress
.global BlockUpdateDataTL
.global BlockUpdateDataTR
.global BlockUpdateDataBL
.global BlockUpdateDataBR
