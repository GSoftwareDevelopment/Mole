; block definitions

; #0
; width & height
	.by	02 03
; data
	.by	02 00			; X.
	.by	05 04			; XX
	.by	05 00			; X.

; #1
	.by	03 02
	.by	02 04 04	; XXX
	.by	00 05 00	; .X.

; #2
	.by	03 02
	.by	00 02 00	; .X.
	.by	02 03 04	; XXX

; #3
	.by	02 03
	.by	00 02			; .X
	.by	02 03			; XX
	.by	00 05			; .X

; #4
	.by	03 02
	.by	00 02 04	; .XX
	.by	02 03 00	; XX.

; #5
	.by	03 02
	.by	02 04 00	; XX.
	.by	00 05 04	; .XX

; #6
	.by	02 03
	.by	00 02			; .X
	.by	02 03			; XX
	.by	05 00			; X.

; #7
	.by	02 03
	.by	02 00			; X.
	.by	05 04			; XX
	.by	00 05			; .X

; #8
	.by	02 02
	.by	02 04			; XX
	.by	05 03			; XX
	.by	00 00			; ..

; #9
	.by	02 03
	.by	02 04			; XX
	.by	05 00			; X.
	.by	05 00			; X.

; #10
	.by	03 02
	.by	02 04 04	; XXX
	.by	00 00 05	; ..X

; #11
	.by	02 03
	.by	00 02			; .X
	.by	00 05			; .X
	.by	02 03			; XX

; #12
	.by	03 02
	.by	02 00 00	; X..
	.by	05 04 04	; XXX

; #13
	.by	02 03
	.by	02 04			; XX
	.by	00 05			; .X
	.by	00 05			; .X

; #14
	.by	03 02
	.by	00 00 02	; ..X
	.by	02 04 03	; XXX

; #15
	.by	02 03
	.by	02 00			; X.
	.by	05 00			; X.
	.by	05 04			; XX

; #16
	.by	03 02
	.by	02 04 04	; XXX
	.by	05 00 00	; X..

; #17 - coin
	.by 01 01
	.by 27
	.by 00 00 00 00 00
