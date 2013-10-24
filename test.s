;;nintendo "test cart" unrom hack - James Holodnak 2013
;;
;;to use this follow these easy to understand instructions:
;;  . remove the lower 16kb prg from the rom and name it 'test-bank0.bin'
;;  . remove the upper 16kb prg from the rom and name it 'test-bank1.bin'
;;  . remove the chr from the rom and name it 'test.chr'
;;  . run make
;;
;;after make finishes, and if you had wla-6502 and wlalink in your path, you
;;will have a output file called 'test.nes'

.MEMORYMAP
  SLOTSIZE $4000
  DEFAULTSLOT 0
  
  ;;swappable bank
  SLOT 0 $8000

  ;;fixed bank
  SLOT 1 $C000

.ENDME

.ROMBANKMAP
  BANKSTOTAL 4
  BANKSIZE $4000
  BANKS 4
.ENDRO

;;ppu registers
.define PPUCTRL     $2000
.define PPUMASK     $2001
.define PPUSTATUS   $2002
.define OAMADDR     $2003
.define OAMDATA     $2004
.define PPUSCROLL   $2005
.define PPUADDR     $2006
.define PPUDATA     $2007

.BANK 0 SLOT 0
.ORG $0000

;;wait for vblank, missing it sometimes
ppuwait:
  bit PPUSTATUS
  bpl ppuwait
  rts

;;nmi vector
.ORG $0328
  rti

;;start executing original rom
.ORG $036A
start:
  lda #2
  sta $8000

;;reset vector
.ORG $0370

  jsr ppuwait
  jsr ppuwait

  ;;reset ppu toggle
  ldy PPUSTATUS

  ;;set ppu vram address to 0
  lda #0
  sta PPUADDR
  sta PPUADDR

  ;;copy all chrrom
  lda #$A0
  sta $01
  lda #$00
  sta $00
  sta PPUADDR
  sta PPUADDR
  ldy #0
  ldx #32
loop:
  lda ($00),y
  sta PPUDATA
  iny
  bne loop
  inc $01
  dex
  bne loop

  ;;begin real rom
  jmp start

;;chrrom is located here
.ORG $2000
.INCBIN "test.chr"

;;empty bank
.BANK 1 SLOT 0
.ORG $0000
.repeat 4096
  .db $DE,$AD,$BE,$EF,
.endr

;;original lower 16k bank
.BANK 2 SLOT 0
.ORG $0000
.INCBIN "test-bank0.bin"

;;original upper 16k bank
.BANK 3 SLOT 1
.ORG $0000
.INCBIN "test-bank1.bin"
