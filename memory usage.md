```$R RCASM   $7000..$79FB 'song/mole.asm'
$R RCASM   $7000..$79FB 'sonf/mole.asm'
$R RCASM   $7A00..$7AFF 'song/mole_midi.asm'

$R RCASM   $7B00..$7B1B 'asm/dlist-title.asm'
$R RCASM   $7B20..$7B39 'asm/dlist-game.asm'
$R RCASM   $7B40..$7B55 'asm/dlist-ready.asm'
$R RCASM   $7B60..$7B74 'asm/dlist-gameover.asm'
$R RCASM   $7BA0..$7BB7 'asm/dlist-history.asm'
$R RCASM   $7BF0..$7BFF 'asm/rainbow-data.asm'

$R RCDATA  $7C00..$7E07 'pics/title.scr'
$R RCDATA  $7E08..$7E57 'data/game-footer.scr'

;CZ
$R RCASM   $7E58..$7FB8 'data/scroll-cz.asm'
$R RCASM   $8000..$81?? 'data/strings-cz.asm'

;PL
$R RCASM   $7E58..$7FBC 'data/scroll-pl.asm'
$R RCASM   $8000..$81?? 'data/strings-pl.asm'

;EN
$R RCASM   $7E58..$7F9A 'data/scroll-en.asm'
$R RCASM   $8000..$81EF 'data/strings-en.asm'

// $81F0..$83FF

$R RCDATA  $8400..$8CCF 'pics/title.fnt'

$R RCASM   $8D00..$8F6A 'asm/block.asm'				// $8CD0..$8FFF

PMG		   $9000..$97FF
$R RCDATA  $9800..$997F 'pics/start_gameover.scr'
$R RCASM   $9980..$9998 'pics/start_gameover.pmg'
$R RCDATA  $9998..$9AD7 'pics/title.pmg'
$R RCDATA  $9B00..$9D0F 'data/sprites.obj'
$R RCDATA  $9D10..$9D4F 'data/sprites-logos.obj'
// $9D50..$9DFF
$R RCASM   $9E00..$9E8F 'data/blocks-def.asm'		// block.asm
BLOCKS_LIST_ADDR	$9F00..$9FFF;					 // block.asm

$R RCDATA  $A000..$A3FF 'data/title-b-cz.fnt'
$R RCDATA  $A400..$A7FF 'data/letters-cz.fnt'
$R RCDATA  $A800..$A9FF 'data/kret-chars.fnt'
$R RCDATA  $AC00..$AFFF 'pics/start_gameover.fnt'

SCREEN_BUFFER_ADDR		= $B700;
SCREEN_ADDR				= $B900;

ZPAGE: 				$0080..$00D3
RTBUF: 				$0400..$04FF
RTLIB: 				$2260..$26A8
SYSTEM: 			$26E7..$279E
SFX_API: 			$279F..$2C12
SIO: 				$2C13..$2C14
HSC_UTIL: 			$2C15..$2C16
CODE: 				$2180..$56C1
DATA: 				$56FF..$5B93
```