.globalzp keydown
.globalzp keynew
.globalzp keylast
.globalzp seed
.globalzp retraces
.globalzp OamPtr
.globalzp MicrogameTime
.globalzp MicrogameRealFrames
.globalzp MicrogameFrames

.globalzp MicrogameDifficulty
.globalzp MicrogameWon
.globalzp MicrogameLost
.globalzp MicrogameJustWon
.globalzp MicrogameJustLost

.globalzp MicrogameGlobals
.globalzp MicrogameTemp

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


.global OAM
.global OAMHI
OAM_XPOS = OAM+0
OAM_YPOS = OAM+1
OAM_TILE = OAM+2
OAM_ATTR = OAM+3
