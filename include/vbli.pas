procedure myVBL(); Assembler; Interrupt;
asm
xitvbl      = $e462
sysvbv      = $e45c
portb       = $d301
vdli				= $0200

    phr

timer1:
		lda moleTime
		beq timer2
		dec moleTime

timer2:
		lda moleFallenTime
		beq timer3
		dec moleFallenTime

timer3:
		lda blocksTime
		beq timer4
		dec blocksTime

timer4:
		lda vanishBreakTime
		beq timer5
		dec vanishBreakTime

timer5:
		lda vanishTime
		ora vanishTime+1
		beq SFXPlayer
		lda vanishTime
		bne @+
		dec vanishTime+1
@:
		dec vanishTime

SFXPlayer:
		lda MAIN.SFX_API.isMIDIDrv
		beq @+

    sec
    jsr $2009

@:
		lda curDLIPtr+1
		sta vdli+1
		lda curDLIPtr
		sta vdli

		jsr MAIN.SFX_API.INIT_SFXEngine.SFX_MAIN_TICK

		lda MAIN.SFX_API.isMIDIDrv
		beq @+

    clc
    jsr $2009

@:
		plr
		jmp xitvbl
end;