; da65 V2.19 - Git cc3c40c
; Created:    2026-07-11 02:58:46
; Input file: vc-20-diag.324173-01_blk5.bin
; Page:       1


        .setcpu "6502"

ZP_PTR_INDIRECT_A_LO:= $0002
ZP_PTR_INDIRECT_A_HI:= $0003
ZP_PTR_INDIRECT_B_LO:= $0006
ZP_PTR_INDIRECT_B_HI:= $0007
ZP_TEMP_CHAR_DATA:= $0008
ZP_TEMP_STRING_LEN:= $0009
ZP_SCREEN_SCROLL_FLG:= $000B
ZP_SAVED_REG_C  := $000C
ZP_SAVED_REG_D  := $000D
ZP_SAVED_REG_E  := $000E
ZP_SAVED_REG_F  := $000F
ZP_SCREEN_BUF_POS:= $0010
ZP_STRING_TEMP_LO:= $0013
ZP_STRING_TEMP_HI:= $0014
ZP_PORT_LINE_OFFSET:= $0015
ZP_STRING_SELECT_IDX:= $0016
ZP_MATRIX_SCAN_CTR:= $0017
ZP_DIAG_CHECKPOINT_CTR:= $0018
ZP_LOOP_LIMIT_CTR:= $0019
ZP_VIC_REG_PTR_LO:= $001A
ZP_VIC_REG_PTR_HI:= $001B
ZP_DIAG_SYSTEM_FLG:= $001D
ZP_RAM_SIZE_PTR_A_LO:= $001E
ZP_RAM_SIZE_PTR_A_HI:= $001F
ZP_RAM_SIZE_PTR_B_LO:= $0020
ZP_RAM_SIZE_PTR_B_HI:= $0021
ZP_AUDIO_FREQ_LO:= $0022
ZP_AUDIO_FREQ_HI:= $0023
ZP_LOOP_PASS_CTR:= $0025
RAM_IRQ_VECTOR_LO:= $0314
RAM_IRQ_VECTOR_HI:= $0315
RAM_NMI_VECTOR_LO:= $0318
RAM_NMI_VECTOR_HI:= $0319
RAM_CYCLE_CLOCK_BUFFER:= $0407
REG_AUDIO_STATUS_FLG:= $041A
REG_LOOP_IDX    := $041B
VIDEO_RAM_PAGE_1:= $1E00
VIDEO_RAM_PAGE_2:= $1F00
VIC_REG_SCREEN_X:= $9000
VIC_REG_SCREEN_Y:= $9001
VIC_REG_COLS_NUM:= $9002
VIC_REG_ROWS_NUM:= $9003
VIC_REG_RASTER_LINE:= $9004
VIC_REG_CHAR_MAP_PTR:= $9005
VIC_REG_LIGHT_PEN_X:= $9006
VIC_REG_LIGHT_PEN_Y:= $9007
VIC_REG_AUDIO_BASS:= $900A
VIC_REG_AUDIO_ALTO:= $900B
VIC_REG_AUDIO_TENOR:= $900C
VIC_REG_AUDIO_NOISE:= $900D
VIC_REG_AUDIO_VOL:= $900E
VIC_REG_BG_BORDER_CLR:= $900F
VIA1_PORT_B     := $9110
VIA1_PORT_A     := $9111
VIA1_DDR_B      := $9112
VIA1_DDR_A      := $9113
VIA1_T1_CTR_LO  := $9114
VIA1_T1_CTR_HI  := $9115
VIA1_T1_LAT_LO  := $9116
VIA1_T1_LAT_HI  := $9117
VIA1_T2_CTR_LO  := $9118
VIA1_T2_CTR_HI  := $9119
VIA1_SHIFT_REG  := $911A
VIA1_AUX_CTRL   := $911B
VIA1_PER_CTRL   := $911C
VIA1_INT_FLAGS  := $911D
VIA1_INT_ENABLE := $911E
VIA1_PORT_A_NH  := $911F
VIA2_PORT_B     := $9120
VIA2_PORT_A     := $9121
VIA2_DDR_B      := $9122
VIA2_DDR_A      := $9123
VIA2_T1_CTR_LO  := $9124
VIA2_T1_CTR_HI  := $9125
VIA2_T1_LAT_LO  := $9126
VIA2_T1_LAT_HI  := $9127
VIA2_T2_CTR_LO  := $9128
VIA2_T2_CTR_HI  := $9129
VIA2_SHIFT_REG  := $912A
VIA2_AUX_CTRL   := $912B
VIA2_PER_CTRL   := $912C
VIA2_INT_FLAGS  := $912D
VIA2_INT_ENABLE := $912E
VIA2_PORT_A_NH  := $912F
COLOR_RAM_PAGE_1:= $9600
COLOR_RAM_PAGE_2:= $9700
LF2AE           := $F2AE
        .addr   BOOT_HARDWARE_INIT
        .addr   BOOT_HARDWARE_INIT
        .byte   $41,$30,$C3,$C2
VIC_INIT_REG_MATRIX:
        .byte   $CD,$0C,$19,$96,$2E,$00,$F0,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $1B
BOOT_HARDWARE_INIT:
        sei
        ldx     #$FF
        txs
        cld
        ldx     #$10
LA020:  lda     VIC_INIT_REG_MATRIX,x
        sta     $8FFF,x
        dex
        bpl     LA020
        lda     #$7F
        sta     $9800
        sta     $0411
        ldx     #$0E
LA033:  lda     LA27A,x
        sta     $0400,x
        dex
        bpl     LA033
        lda     #$00
        ldx     #$05
LA040:  sta     $0411,x
        dex
        bne     LA040
        inx
        stx     $0418
        ldx     #$15
        stx     $0417
TEST_LOOP_RECYCLE:
        ldx     #$00
        stx     REG_AUDIO_STATUS_FLG
LA054:  lda     #$06
        sta     COLOR_RAM_PAGE_1,x
        sta     COLOR_RAM_PAGE_2,x
        lda     #$20
        sta     VIDEO_RAM_PAGE_2,x
        sta     VIDEO_RAM_PAGE_1,x
        inx
        bne     LA054
        ldx     #$13
LA069:  lda     LA19B,x
        sta     $1EDD,x
        dex
        bne     LA069
        jsr     UTIL_INCREMENT_CYCLE_CLOCK
        ldx     #$0A
LA077:  lda     STR_SPLASH_ZERO_PAGE,x
        sta     $1F4B,x
        dex
        bpl     LA077
        ldy     #$00
TEST_PHASE_RAM:
        tya
        sta     $00,y
        iny
        bne     TEST_PHASE_RAM
        ldy     #$00
LA08B:  tya
        eor     $00,y
        bne     LA0B0
        tax
LA092:  txa
        sta     $00,y
        eor     $00,y
        bne     LA0D5
        inx
        bne     LA092
        iny
        bne     LA08B
        ldx     #$01
        lda     #$0F
        sta     $1F57
        lda     #$0B
        sta     $1F58
        jmp     LA108

LA0B0:  lda     #$FF
        eor     $00,y
        bne     LA0D5
        sta     $00,y
        eor     $00,y
        bne     LA0D5
        ldx     #$0A
LA0C1:  lda     STR_SPLASH_STACK_OK,x
        sta     $1E19,x
        dex
        bne     LA0C1
        lda     #$FD
        sta     $9800
LA0CF:  inc     $00,x
        inx
        jmp     LA0CF

LA0D5:  ldx     #$00
        ldy     #$FE
        and     #$0F
        bne     LA0E1
        ldy     #$FD
        ldx     #$02
LA0E1:  lda     #$95
        sta     VIDEO_RAM_PAGE_1
        lda     #$83
        sta     $1E01
        lda     #$A0
        sta     $1E02
        lda     LA1F0,x
        sta     $1E03
        lda     LA1F1,x
        sta     $1E04
        sty     $9800
LA0FF:  clc
        adc     #$01
        sta     $00,y
        jmp     LA0FF

LA108:  ldx     #$0B
LA10A:  lda     STR_SPLASH_STACK_PAGE,x
        sta     $1F61,x
        dex
        bpl     LA10A
        ldy     #$00
LA115:  tya
        sta     $0100,y
        iny
        bne     LA115
        ldy     #$00
LA11E:  tya
        eor     $0100,y
        bne     BOOT_STACK_RAM_CHECK
        tax
LA125:  txa
        sta     $0100,y
        eor     $0100,y
        bne     BOOT_ERR_STACK_RAM_FAIL
        inx
        bne     LA125
        iny
        bne     LA11E
        ldx     #$01
        lda     #$0F
        sta     $1F6D
        lda     #$0B
        sta     $1F6E
        jmp     TEST_PHASE_MANAGER

BOOT_STACK_RAM_CHECK:
        lda     #$FF
        eor     $0100,y
        bne     BOOT_ERR_STACK_RAM_FAIL
        sta     $0100,y
        eor     $0100,y
        bne     BOOT_ERR_STACK_RAM_FAIL
        ldx     #$0A
LA154:  lda     STR_SPLASH_STACK_OK,x
        sta     $1E19,x
        dex
        bne     LA154
        lda     #$FB
        sta     $9800
LA162:  inc     $0100,x
        inx
        jmp     LA162

BOOT_ERR_STACK_RAM_FAIL:
        ldx     #$04
        ldy     #$FC
        and     #$0F
        bne     LA175
        ldx     #$06
        ldy     #$FB
LA175:  lda     #$95
        sta     VIDEO_RAM_PAGE_1
        lda     #$83
        sta     $1E01
        lda     #$A0
        sta     $1E02
        lda     LA1F0,x
        sta     $1E03
        lda     LA1F1,x
        sta     $1E04
        sty     $9800
LA193:  clc
        adc     #$01
        sta     $0100,y
LA19B           := * + 2
        jmp     LA193

        .byte   $16,$03,$2D,$32,$30,$20,$20,$20
        .byte   $04,$09,$01,$07,$0E,$0F,$13,$14
        .byte   $09,$03,$20,$20,$16,$31,$2E,$32
        .byte   $89,$AD,$92,$81,$8D,$A0,$82,$81
        .byte   $84,$1A,$2D,$10,$01,$07,$05,$20
        .byte   $0F
STR_SPLASH_STACK_OK:
        .byte   $0B,$81,$B8,$AD,$81,$84,$92,$A0
        .byte   $82,$81,$84,$20,$13,$14,$01,$03
        .byte   $0B,$20,$0F,$0B
STR_SPLASH_ZERO_PAGE:
        .byte   $1A,$05,$12,$0F,$20,$10,$01,$07
        .byte   $05,$3A,$20
STR_SPLASH_STACK_PAGE:
        .byte   $13,$14,$01,$03,$0B,$20,$10,$01
        .byte   $07,$05,$3A,$20
LA1F0:  .byte   $B0
LA1F1:  .byte   $B0,$B0,$B1
TEST_PHASE_MANAGER:
        jsr     INIT_STEP_BCD_CLOCK
        jsr     INIT_REFRESH_CLOCK_BANNER
        lda     #$00
        sta     ZP_SCREEN_BUF_POS
        sta     ZP_PORT_LINE_OFFSET
        sta     ZP_MATRIX_SCAN_CTR
        sta     ZP_DIAG_SYSTEM_FLG
        lda     #$07
        sta     ZP_DIAG_CHECKPOINT_CTR
        jsr     INIT_MAP_MEMORY_BOUNDS
        jsr     INIT_HOOK_SYSTEM_IRQ
        lda     #$0A
        sta     ZP_DIAG_CHECKPOINT_CTR
        sei
        jsr     INIT_MAP_EXPANSION_BOUNDS
        cli
        jsr     UTIL_HARDWARE_DELAY
        jsr     UTIL_HARDWARE_DELAY
        lda     #$00
        sta     ZP_PTR_INDIRECT_B_LO
        lda     #$94
        sta     ZP_PTR_INDIRECT_B_HI
        lda     #$03
        sta     ZP_DIAG_SYSTEM_FLG
        jsr     UTIL_RECYCLE_RESET
        ldx     #$5E
        ldy     #$A3
        jsr     UTIL_PRINT_STRING
        jsr     UTIL_PRINT_PASS_STATUS
        jsr     UTIL_TEST_MEM_NYBBLE_BLOCK
        lda     #$24
        sta     ZP_DIAG_CHECKPOINT_CTR
        jsr     TEST_ROM_CHECKSUM_INIT
        jsr     TEST_PHASE_KEYBOARD
        jsr     TEST_PORT_IEC_SERIAL
        jsr     TEST_VIA_EDGE_IRQ_SETUP
        jsr     TEST_PHASE_VIA_EDGE_CHECKS
        jsr     UTIL_HARDWARE_DELAY
        jsr     UTIL_HARDWARE_DELAY
        jsr     TEST_PHASE_VIC_SOUND
        jsr     UTIL_RECYCLE_RESET
        sei
        jmp     TEST_LOOP_RECYCLE

UTIL_INCREMENT_CYCLE_CLOCK:
        ldx     #$05
LA25E:  inc     RAM_CYCLE_CLOCK_BUFFER,x
        lda     RAM_CYCLE_CLOCK_BUFFER,x
        cmp     #$3A
        bcc     LA272
        lda     #$30
        sta     RAM_CYCLE_CLOCK_BUFFER,x
        dex
        bpl     LA25E
        bmi     UTIL_INCREMENT_CYCLE_CLOCK
LA272:  ldx     #$00
        ldy     #$04
        jsr     LAC6D
        rts

LA27A:  .byte   " CYCLE 000000"

        .byte   $0D,$00
INIT_MAP_MEMORY_BOUNDS:
        lda     #$01
        pha
        ldx     #$00
        ldy     #$02
        lda     #$01
        bne     LA29D
INIT_MAP_EXPANSION_BOUNDS:
        lda     #$02
        pha
        ldx     #$00
        ldy     #$10
        lda     #$0F
LA29D:  stx     ZP_PTR_INDIRECT_B_LO
        sty     ZP_PTR_INDIRECT_B_HI
        sta     ZP_DIAG_SYSTEM_FLG
        lda     #$04
        sta     ZP_LOOP_PASS_CTR
        ldx     #$5E
        ldy     #$A3
        jsr     UTIL_PRINT_STRING
        lda     #$20
        jsr     UTIL_PRINT_CHAR
        pla
        jsr     UTIL_HEX_TO_ASCII
        lda     #$20
        jsr     UTIL_PRINT_CHAR
LA2BC:  ldy     #$00
LA2BE:  tya
        sta     (ZP_PTR_INDIRECT_B_LO),y
        iny
        bne     LA2BE
        ldy     #$00
LA2C6:  tya
        eor     (ZP_PTR_INDIRECT_B_LO),y
        bne     LA304
        sta     (ZP_PTR_INDIRECT_B_LO),y
        eor     (ZP_PTR_INDIRECT_B_LO),y
        bne     LA330
        lda     #$AA
        sta     (ZP_PTR_INDIRECT_B_LO),y
        eor     (ZP_PTR_INDIRECT_B_LO),y
        bne     LA330
        lda     #$55
        sta     (ZP_PTR_INDIRECT_B_LO),y
        eor     (ZP_PTR_INDIRECT_B_LO),y
        bne     LA330
        lda     #$FF
        sta     (ZP_PTR_INDIRECT_B_LO),y
        eor     (ZP_PTR_INDIRECT_B_LO),y
        bne     LA330
        iny
        bne     LA2C6
        inc     ZP_PTR_INDIRECT_B_HI
        dec     ZP_LOOP_PASS_CTR
        bne     LA2FD
        lda     #$04
        sta     ZP_LOOP_PASS_CTR
        clc
        lda     ZP_DIAG_CHECKPOINT_CTR
        adc     #$03
        sta     ZP_DIAG_CHECKPOINT_CTR
LA2FD:  dec     ZP_DIAG_SYSTEM_FLG
        bpl     LA2BC
        jmp     UTIL_PRINT_PASS_STATUS

LA304:  lda     #$FF
        eor     (ZP_PTR_INDIRECT_B_LO),y
        bne     LA330
        sta     (ZP_PTR_INDIRECT_B_LO),y
        eor     (ZP_PTR_INDIRECT_B_LO),y
        bne     LA330
        ldx     #$0A
LA312:  lda     STR_SPLASH_STACK_OK,x
        sta     $1E19,x
        dex
        bne     LA312
        lda     ZP_DIAG_CHECKPOINT_CTR
        clc
        adc     #$02
        eor     #$FF
        sta     $9800
LA325:  lda     (ZP_PTR_INDIRECT_B_LO),y
        tax
        inx
        txa
        sta     (ZP_PTR_INDIRECT_B_LO),y
        iny
        jmp     LA325

LA330:  ldx     #$00
        and     #$0F
        bne     LA338
        ldx     #$01
LA338:  stx     $1C
        lda     #$95
        jsr     UTIL_PRINT_CHAR
        lda     #$83
        jsr     UTIL_PRINT_CHAR
        lda     #$A0
        jsr     UTIL_PRINT_CHAR
        lda     ZP_DIAG_CHECKPOINT_CTR
        clc
        adc     $1C
        pha
        jsr     UTIL_HEX_TO_ASCII
        pla
        jsr     LAC27
LA356:  clc
        adc     #$01
        sta     (ZP_PTR_INDIRECT_B_LO),y
        jmp     LA356

STR_RAM_TEST_PTR:
        .byte   " RAM TEST "

        .byte   $00
UTIL_TEST_MEM_NYBBLE_BLOCK:
        ldx     #$A7
        ldy     #$A3
        jsr     UTIL_PRINT_STRING
        ldy     #$00
LA372:  lda     (ZP_PTR_INDIRECT_B_LO),y
        sta     $00
        ldx     #$0F
LA378:  txa
        sta     (ZP_PTR_INDIRECT_B_LO),y
        pha
        lda     (ZP_PTR_INDIRECT_B_LO),y
        and     #$0F
        sta     $1C
        pla
        eor     $1C
        bne     TEST_PHASE_COLOR_RAM
        dex
        bpl     LA378
        lda     $00
        sta     (ZP_PTR_INDIRECT_B_LO),y
        iny
        bne     LA372
        inc     ZP_PTR_INDIRECT_A_HI
        dec     ZP_DIAG_SYSTEM_FLG
        bpl     LA372
        jmp     UTIL_PRINT_PASS_STATUS

TEST_PHASE_COLOR_RAM:
        lda     #$22
        jsr     LAC27
LA39F:  clc
        adc     #$01
        sta     (ZP_PTR_INDIRECT_B_LO),y
        jmp     LA39F

STR_COLOR_RAM_TEST_PTR:
        .byte   " COLOR RAM TEST: "


        .byte   $00
TEST_ROM_CHECKSUM_INIT:
        ldx     #$02
        stx     $1C
TEST_PHASE_ROM_CHECKSUM:
        ldx     #$0E
        ldy     #$A4
        jsr     UTIL_PRINT_STRING
        ldx     $1C
        lda     ROM_START_HI_BYTES,x
        sta     ZP_PTR_INDIRECT_A_HI
        lda     ROM_PAGE_COUNT_SIZERS,x
        sta     REG_LOOP_IDX
        lda     #$00
        sta     ZP_PTR_INDIRECT_A_LO
        cpx     #$01
        bne     LA3E0
        ldy     $F75D
        cpy     #$4C
        beq     LA3FA
LA3E0:  tay
        clc
LA3E2:  adc     (ZP_PTR_INDIRECT_A_LO),y
        iny
        bne     LA3E2
        inc     ZP_PTR_INDIRECT_A_HI
        dec     REG_LOOP_IDX
        bne     LA3E2
        adc     #$00
        pha
        jsr     UTIL_HEX_TO_ASCII
        pla
        cmp     ROM_TARGET_CHECKSUMS,x
        beq     LA400
LA3FA:  jsr     UTIL_FLASH_ERROR_HANDLER
        jmp     LA3FA

LA400:  lda     #$0D
        jsr     UTIL_PRINT_CHAR
        inc     ZP_DIAG_CHECKPOINT_CTR
        dec     $1C
        bpl     TEST_PHASE_ROM_CHECKSUM
        jmp     UTIL_CLEAR_SCREEN_CANVAS

STR_ROMCHECK_PTR:
        .byte   " ROMCHECK "

        .byte   $00
ROM_START_HI_BYTES:
        .byte   $C0,$E0,$80
ROM_PAGE_COUNT_SIZERS:
        .byte   $20,$20,$10
ROM_TARGET_CHECKSUMS:
        .byte   $C0,$E0,$FF
TEST_PHASE_KEYBOARD:
        ldx     #$AC
        ldy     #$A4
        jsr     UTIL_PRINT_STRING
        ldy     #$01
        sty     REG_LOOP_IDX
LA42E:  ldx     REG_LOOP_IDX
        ldy     VIA_PORT_OFFSET_TABLE,x
        ldx     #$00
        stx     VIA2_DDR_A
        stx     VIA2_DDR_B
LA43C:  txa
        sta     VIA2_DDR_B,y
        eor     #$FF
        sta     VIA2_PORT_B,y
        cmp     VIA2_PORT_B,y
        bne     LA490
        inx
        bne     LA43C
        dec     REG_LOOP_IDX
        bpl     LA42E
        ldx     #$FF
        stx     VIA2_DDR_B
        inx
        stx     VIA2_DDR_A
        stx     VIA2_PORT_B
        cpx     VIA2_PORT_A
        beq     LA473
        ldx     VIA2_PORT_A
        cpx     #$FF
        bne     LA490
        inc     ZP_DIAG_CHECKPOINT_CTR
        lda     #$FF
        sta     $1C
        jmp     UTIL_PRINT_PASS_STATUS

LA473:  lda     #$FE
        sta     VIA2_PORT_B
LA478:  lda     VIA2_PORT_A
        cmp     VIA2_PORT_B
        bne     LA490
        sec
        rol     VIA2_PORT_B
        bcs     LA478
        jsr     UTIL_PRINT_PASS_STATUS
        inc     ZP_DIAG_CHECKPOINT_CTR
        lda     #$00
        sta     $1C
        rts

LA490:  jsr     UTIL_FLASH_ERROR_HANDLER
        jmp     LA490

TEST_VIA_EDGE_IRQ_SETUP:
        ; --- CRITICAL SECTION ENTRY ---
        sei                             ; Set Interrupt Disable (Inhibits standard maskable IRQs)
                                        ; Prevents an IRQ from firing mid-setup while vectors are half-written.

        ; --- PATCH HARDWARE IRQ VECTOR ---
        lda     #<VIA_EDGE_IRQ_HANDLER  ; Extract low byte of the Edge IRQ Handler address
        sta     RAM_IRQ_VECTOR_LO       ; Inject into the low-byte RAM destination ($0314)
        lda     #>VIA_EDGE_IRQ_HANDLER  ; Extract high byte of the Edge IRQ Handler address
        sta     RAM_IRQ_VECTOR_HI       ; Inject into the high-byte RAM destination ($0315)

        ; --- PATCH HARDWARE NMI VECTOR ---
        lda     #<VIA_EDGE_NMI_HANDLER  ; Extract low byte of the Edge NMI Handler address
        sta     RAM_NMI_VECTOR_LO       ; Inject into the low-byte RAM destination ($0318)
        lda     #>VIA_EDGE_NMI_HANDLER  ; Extract high byte of the Edge NMI Handler address
        sta     RAM_NMI_VECTOR_HI       ; Inject into the high-byte RAM destination ($0319)

        ; --- EXIT AND RETURN ---
        rts                             ; Return from Subroutine (leaves IRQs disabled for caller control)

STR_KEYBOARD_TEST_PTR:
        .byte   " KEYBOARD TEST: "

        .byte   $00
STR_SKIP_PTR:
        .byte   "SKIP"
        .byte   $0D,$00
VIA_PORT_OFFSET_TABLE:
        .byte   $00,$01
STR_USER_PORT_PTR:
        .byte   " USER PORT      "

        .byte   $00
STR_SERIAL_BUS_PTR:
        .byte   " SERIAL BUS     "

        .byte   $00
STR_CASSETTE_PORT_PTR:
        .byte   " CASSETTE PORT  "

        .byte   $00
STR_JOYSTICK_PORT_PTR:
        .byte   " JOYSTICK PORT  "

        .byte   $00
TEST_PORT_IEC_SERIAL:
        lda     #$7F
        sta     VIA1_INT_ENABLE                 ; Disable All Interrupts
        sta     VIA2_INT_ENABLE                 ; For Both VIA's
        lda     #$80
        sta     VIA1_DDR_A                      ; User Port VIA Port A Bit 7 To Output
        lda     #$CC
        sta     VIA2_PER_CTRL                   ; Keyboard VIA CA2 & CB2 Output LOW
        lda     #$EE
        sta     VIA1_PER_CTRL                   ; User Port VIA CA2 & CB2 Output HIGH
        lda     #$00
        sta     VIA1_PORT_A_NH                  ; User Port VIA Port A Bit 7 Low / Rest Inputs

        ldx     #<STR_SERIAL_BUS_PTR            ; Write The String "SERIAL BUS"
        ldy     #>STR_SERIAL_BUS_PTR
        inc     ZP_DIAG_CHECKPOINT_CTR          ; Advance diagnostic stage counter
        jsr     UTIL_PRINT_STRING               ; Display current test on screen

        lda     VIA1_PORT_A_NH                  ; Read serial bus lines via VIA1 Port A
        lsr     a                               ; Shift Bit 0 into Carry flag
        bcc     ERR_TRAP_IEC_SERIAL_FAIL_B      ; Fail if Bit 0 is clear (low)
        lsr     a                               ; Shift Bit 1 into Carry flag
        bcc     ERR_TRAP_IEC_SERIAL_FAIL_A      ; Fail if Bit 1 is clear (low)
        
        lda     #$EC
        sta     VIA2_PER_CTRL                   ; Keyboard VIA: Set CB2 High, CA2 Low
        lda     VIA1_PORT_A_NH                  ; Re-read serial bus input state
        lsr     a                               ; Shift Bit 0 into Carry flag
        bcc     ERR_TRAP_IEC_SERIAL_FAIL_B      ; Fail if Bit 0 is clear (low)
        lsr     a                               ; Shift Bit 1 into Carry flag
        bcs     ERR_TRAP_IEC_SERIAL_FAIL_A      ; Fail if Bit 1 is set (high)
        
        lda     #$CE
        sta     VIA2_PER_CTRL                   ; Keyboard VIA: Set CB2 Low, CA2 High
        lda     VIA1_PORT_A_NH                  ; Re-read serial bus input state
        lsr     a                               ; Shift Bit 0 into Carry flag
        bcs     ERR_TRAP_IEC_SERIAL_FAIL_B      ; Fail if Bit 0 is set (high)
        lsr     a                               ; Shift Bit 1 into Carry flag
        bcc     ERR_TRAP_IEC_SERIAL_FAIL_A      ; Fail if Bit 1 is clear (low)
        
        lda     VIA2_INT_FLAGS
        sta     VIA2_INT_FLAGS                  ; Clear VIA2 interrupt flags by writing back
        lda     #$CC
        sta     VIA2_PER_CTRL                   ; Keyboard VIA: Reset CA2 & CB2 to Low
        lda     #$80
        sta     VIA1_PORT_A_NH                  ; Pull User Port Bit 7 High
        lda     VIA2_INT_FLAGS                  ; Read VIA2 Interrupt Flag Register
        and     #$10                            ; Mask for Bit 4 (CB1 Active Edge flag)
        beq     ERR_TRAP_IEC_SERIAL_FAIL_C      ; Fail if CB1 transition was not detected
        
        lda     VIA2_INT_FLAGS
        sta     VIA2_INT_FLAGS                  ; Clear VIA2 interrupt flags again
        lda     #$DC
        sta     VIA2_PER_CTRL                   ; Keyboard VIA: Set CB2 High, CA2 Low (Alternative configuration)
        lda     #$00
        sta     VIA1_PORT_A_NH                  ; Pull User Port Bit 7 Low
        lda     VIA2_INT_FLAGS                  ; Re-read VIA2 Interrupt Flag Register
        and     #$10                            ; Mask for Bit 4 (CB1 Active Edge flag)
        beq     ERR_TRAP_IEC_SERIAL_FAIL_C      ; Fail if CB1 transition failed to trigger
        
        jsr     UTIL_PRINT_PASS_STATUS          ; Print "OK" or green status message
        jmp     TEST_PORT_CASSETTE              ; Proceed to the next test

ERR_TRAP_IEC_SERIAL_FAIL_A:
        jsr     UTIL_FLASH_ERROR_HANDLER        ; Trigger visual error signal (e.g., screen flash)
        lda     #$EC
        sta     VIA2_PER_CTRL                   ; Toggle control lines to keep signal active
        lda     #$CC
        sta     VIA2_PER_CTRL                   ; Reset control lines
        jmp     ERR_TRAP_IEC_SERIAL_FAIL_A      ; Infinite trap loop for failure type A

ERR_TRAP_IEC_SERIAL_FAIL_B:
        jsr     UTIL_FLASH_ERROR_HANDLER        ; Trigger visual error signal
        lda     #$CE
        sta     VIA2_PER_CTRL                   ; Toggle control lines differently for fault B
        lda     #$CC
        sta     VIA2_PER_CTRL                   ; Reset control lines
        jmp     ERR_TRAP_IEC_SERIAL_FAIL_B      ; Infinite trap loop for failure type B

ERR_TRAP_IEC_SERIAL_FAIL_C:
        jsr     UTIL_FLASH_ERROR_HANDLER        ; Trigger visual error signal
        lda     #$80
        sta     VIA1_PORT_A_NH                  ; Toggle output line High for fault C monitoring
        lda     #$00
        sta     VIA1_PORT_A_NH                  ; Reset output line Low
        jmp     ERR_TRAP_IEC_SERIAL_FAIL_C      ; Infinite trap loop for failure type C

TEST_PORT_CASSETTE:
        ; --- HARDWARE INITIALIZATION PHASE ---
        lda     #$FF
        sta     VIA2_PORT_B                     ; Drive all Keyboard VIA Port B pins HIGH (resets lines)
        lda     #$CC
        sta     VIA2_PER_CTRL                   ; Keyboard VIA PCR: Set CA2 & CB2 Outputs LOW
        lda     #$CE
        sta     VIA1_PER_CTRL                   ; User Port VIA PCR: Set CB2 Low, CA2 High
        lda     #$80
        sta     VIA1_PORT_A_NH                  ; User Port VIA Port A (No Handshake): Set Bit 7 High, rest Low

        ; --- UI DISPLAY PHASE ---
        ldx     #<STR_CASSETTE_PORT_PTR         ; Load low byte of the " CASSETTE PORT  " string address
        ldy     #>STR_CASSETTE_PORT_PTR         ; Load high byte of the " CASSETTE PORT  " string address
        inc     ZP_DIAG_CHECKPOINT_CTR          ; Advance diagnostic stage tracker for cartridge
        jsr     UTIL_PRINT_STRING               ; Print test label to screen

        ; --- PHASE 1: TEST CASSETTE SWITCH SENSE (MOTOR OFF) ---
        lda     VIA2_INT_FLAGS
        sta     VIA2_INT_FLAGS                  ; Clear VIA2 interrupt flags by writing 1s back to them
        lda     VIA1_PORT_A_NH                  ; Read current status of VIA1 Port A
        and     #$40                            ; Mask for Bit 6 (Cassette Switch Sense / Pin 6)
        bne     ERR_TRAP_CASSETTE_FAIL_A        ; Catch Fault: If Bit 6 is High, Switch circuit is open/broken

        ; --- PHASE 2: TEST MOTOR CONTROL TOGGLE ---
        lda     #$CC
        sta     VIA1_PER_CTRL                   ; User Port VIA PCR: Toggle CA2/CB2 Low (Turns Cassette Motor ON)
        jsr     UTIL_HARDWARE_DELAY             ; Wait for voltage/relay to physically stabilize
        lda     VIA1_PORT_A_NH                  ; Re-read VIA1 Port A status
        and     #$40                            ; Mask for Bit 6 (Cassette Switch Sense)
        beq     ERR_TRAP_CASSETTE_FAIL_A        ; Catch Fault: If Bit 6 stayed Low, Motor control line failed to switch

        ; --- PHASE 3: WRITE-TO-READ LOOPBACK INTERRUPT TEST ---
        lda     #$00
        sta     VIA2_PORT_B                     ; Pull VIA2 Port B Low to pulse the Cassette Write line (Pin 5)
        lda     VIA2_INT_FLAGS                  ; Read Keyboard VIA Interrupt Flag Register
        and     #$02                            ; Mask for Bit 1 (CA1 Interrupt Flag / Cassette Read line)
        beq     ERR_TRAP_CASSETTE_FAIL_B        ; Catch Fault: If 0, pulse failed to loop back into Cassette Read (Pin 4)

        ; --- TEST PASSED ---
        jsr     UTIL_PRINT_PASS_STATUS          ; Print "OK" or green status message
        jmp     TEST_PORT_JOYSTICK              ; Exit test and advance to the Joystick module

        ; --- TRAP ARCHITECTURE / ERROR HANDLING ---
ERR_TRAP_CASSETTE_FAIL_A:
        jsr     UTIL_FLASH_ERROR_HANDLER        ; Trigger visual error signal (flashes borders/VIC chip)
        lda     #$CE
        sta     VIA1_PER_CTRL                   ; Actively toggle Cassette Motor control line (CB2/CA2)
        lda     #$CC
        sta     VIA1_PER_CTRL                   ; Generates a square wave on the Motor line for oscilloscope tracing
        jmp     ERR_TRAP_CASSETTE_FAIL_A        ; Permanent trap loop for Failure A (Switch Sense / Motor Logic Fault)

ERR_TRAP_CASSETTE_FAIL_B:
        jsr     UTIL_FLASH_ERROR_HANDLER        ; Trigger visual error signal
        lda     #$00
        sta     VIA2_PORT_B                     ; Actively pull Cassette Write line low
        lda     #$FF
        sta     VIA2_PORT_B                     ; Actively pull Cassette Write line high (cycles pulse for scope test)
        jmp     ERR_TRAP_CASSETTE_FAIL_B        ; Permanent trap loop for Failure B (Write-to-Read Loopback Fault)

TEST_PORT_JOYSTICK:
        ; --- PHASE 1 INITIALIZATION: SET BITS 7, 4, 2 TO OUTPUTS ---
        lda     #$94                            ; Binary %10010100 (Bits 7, 4, and 2 as Outputs)
        sta     VIA1_DDR_A                      ; Update VIA1 Data Direction Register A
        lda     #$FF
        sta     VIA1_PORT_A_NH                  ; Set all output pins HIGH

        ; --- UI DISPLAY PHASE ---
        ldx     #<STR_JOYSTICK_PORT_PTR         ; Load low byte of " JOYSTICK PORT  " string address
        ldy     #>STR_JOYSTICK_PORT_PTR         ; Load high byte of " JOYSTICK PORT  " string address
        inc     ZP_DIAG_CHECKPOINT_CTR          ; Advance diagnostic stage tracker for cartridge
        jsr     UTIL_PRINT_STRING               ; Print test label to screen

        ; --- TEST 1A: STATIC HIGH TEST (BITS 3 & 5) ---
        lda     VIA1_PORT_A_NH                  ; Read current status of VIA1 Port A input pins
        tax                                     ; Preserve original read value in X register
        and     #$08                            ; Mask Bit 3 (Joystick Switch / Loopback line)
        beq     ERR_TRAP_JOYSTICK_FAIL          ; Catch Fault: If Bit 3 is Low, it's grounded/shorted
        txa                                     ; Restore original read value to Accumulator
        and     #$20                            ; Mask Bit 5 (Joystick Switch / Loopback line)
        beq     ERR_TRAP_JOYSTICK_FAIL          ; Catch Fault: If Bit 5 is Low, it's grounded/shorted

        ; --- TEST 1B: STATIC LOW TEST (BITS 3 & 5) ---
        lda     #$00
        sta     VIA1_PORT_A_NH                  ; Pull all driven output pins LOW
        lda     VIA1_PORT_A_NH                  ; Re-read VIA1 Port A input pins
        tax                                     ; Preserve read value in X register
        and     #$08                            ; Mask Bit 3
        bne     ERR_TRAP_JOYSTICK_FAIL          ; Catch Fault: If Bit 3 stayed High, it's stuck or broken
        txa                                     ; Restore read value
        and     #$20                            ; Mask Bit 5
        bne     ERR_TRAP_JOYSTICK_FAIL          ; Catch Fault: If Bit 5 stayed High, it's stuck or broken

        ; --- PHASE 2 INITIALIZATION: ALTERNATE CHANNELS (SET BITS 4 & 2 TO OUTPUTS) ---
        lda     #$14                            ; Binary %00010100 (Bits 4 and 2 as Outputs, Bit 7 drops to Input)
        sta     VIA1_DDR_A                      ; Reconfigure VIA1 Data Direction Register A
        lda     #$FF
        sta     VIA1_PORT_A_NH                  ; Pull driven output lines HIGH
        
        ; --- TEST 2A: STATIC HIGH TEST (BITS 2 & 4 AS CROSS-TALK INPUTS) ---
        lda     VIA1_PORT_A_NH                  ; Re-read VIA1 Port A inputs
        tax                                     ; Preserve read value in X register
        and     #$04                            ; Mask Bit 2
        beq     ERR_TRAP_JOYSTICK_FAIL          ; Catch Fault: If Bit 2 is Low, loopback pin dropped unexpectedly
        txa                                     ; Restore read value
        and     #$10                            ; Mask Bit 4
        beq     ERR_TRAP_JOYSTICK_FAIL          ; Catch Fault: If Bit 4 is Low, loopback pin dropped unexpectedly

        ; --- TEST 2B: STATIC LOW TEST (BITS 2 & 4 AS CROSS-TALK INPUTS) ---
        lda     #$00
        sta     VIA1_PORT_A_NH                  ; Pull driven lines LOW
        lda     VIA1_PORT_A_NH                  ; Re-read VIA1 Port A inputs
        tax                                     ; Preserve read value in X register
        and     #$04                            ; Mask Bit 2
        bne     ERR_TRAP_JOYSTICK_FAIL          ; Catch Fault: If Bit 2 stayed High, pin failed to cycle Low
        txa                                     ; Restore read value
        and     #$10                            ; Mask Bit 4
        bne     ERR_TRAP_JOYSTICK_FAIL          ; Catch Fault: If Bit 4 stayed High, pin failed to cycle Low

        ; --- TEST PASSED ---
        jsr     UTIL_PRINT_PASS_STATUS          ; Print "OK" or green status message
        jmp     TEST_PORT_USER_PORT             ; Exit test and advance to the User Port module

        ; --- TRAP ARCHITECTURE / ERROR HANDLING ---
ERR_TRAP_JOYSTICK_FAIL:
        jsr     UTIL_FLASH_ERROR_HANDLER        ; Trigger visual error signal (flashes borders/VIC chip)
        lda     #$FF
        sta     VIA1_PORT_A_NH                  ; Rapidly cycle output lines HIGH...
        lda     #$00
        sta     VIA1_PORT_A_NH                  ; ...and LOW to output a trace signal for diagnostic hardware
        jmp     ERR_TRAP_JOYSTICK_FAIL          ; Permanent trap loop for joystick input failures

TEST_PORT_USER_PORT:
        ; --- PHASE 1: INITIALISE ALTERNATING BIT REVERSE PATTERN ---
        lda     #$AA                            ; Binary %10101010 (Even bits = Outputs, Odd bits = Inputs)
        sta     VIA1_DDR_B                      ; Configure User Port Data Direction Register B
        sta     VIA1_PORT_B                     ; Drive the active Output pins High

        ; --- UI DISPLAY PHASE ---
        ldx     #<STR_USER_PORT_PTR             ; Load low byte of " USER PORT      " string pointer
        ldy     #>STR_USER_PORT_PTR             ; Load high byte of " USER PORT      " string pointer
        inc     ZP_DIAG_CHECKPOINT_CTR          ; Advance diagnostic stage tracking state
        jsr     UTIL_PRINT_STRING               ; Print test label to screen

        ; --- TEST 1A: CHECK PINS FLOATING OR LINKED HIGH ---
        lda     VIA1_PORT_B                     ; Read back the Port B lines
        cmp     #$FF                            ; Expected $FF (%11111111) due to loopback wiring
        bne     ERR_TRAP_USER_PORT_FAIL         ; Catch Fault: Jump to error loop if any bit is missing
        
        ; --- TEST 1B: CHECK DRIVEN LOW STATES ---
        lda     #$00
        sta     VIA1_PORT_B                     ; Drive active output pins Low
        lda     VIA1_PORT_B                     ; Read back Port B lines again
        bne     ERR_TRAP_USER_PORT_FAIL         ; Catch Fault: If result is not zero, a pin is stuck High

        ; --- PHASE 2: INVERT BIT PATTERN (CHECKERBOARD FLIP) ---
        lda     #$55                            ; Binary %01010101 (Even bits = Inputs, Odd bits = Outputs)
        sta     VIA1_DDR_B                      ; Swap all pin directions on User Port B
        sta     VIA1_PORT_B                     ; Drive newly assigned Output pins High
        
        ; --- TEST 2A: CHECK INVERTED HIGH STATES ---
        lda     VIA1_PORT_B                     ; Read back the shifted configuration
        cmp     #$FF                            ; Expected $FF due to loopback crossing
        bne     ERR_TRAP_USER_PORT_FAIL         ; Catch Fault: Jump to error loop if any bit failed to cross
        
        ; --- TEST 2B: CHECK INVERTED LOW STATES ---
        lda     #$00
        sta     VIA1_PORT_B                     ; Drive inverted output pins Low
        lda     VIA1_PORT_B                     ; Final read verification of the lines
        bne     ERR_TRAP_USER_PORT_FAIL         ; Catch Fault: Non-zero means a line is shorted/stuck

        ; --- TEST PASSED ---
        jsr     UTIL_PRINT_PASS_STATUS          ; Execution clean. Print "OK" or green pass indicator
        rts                                     ; Return from Subroutine (ends this specific suite of tests)

        ; --- TRAP ARCHITECTURE / ERROR HANDLING ---
ERR_TRAP_USER_PORT_FAIL:
        jsr     UTIL_FLASH_ERROR_HANDLER        ; Call global warning routine to flash screen/border
        lda     #$FF
        sta     VIA1_PORT_B                     ; Drive lines High...
        lda     #$00
        sta     VIA1_PORT_B                     ; ...then Low to generate a clear square wave on faulty bits
        jmp     ERR_TRAP_USER_PORT_FAIL         ; Permanent trap loop for User Port hardware failure

TEST_PHASE_VIA_EDGE_CHECKS:
        ; --- PHASE 1 INITIALIZATION: POINTER TO VIA1 REGISTERS ---
        lda     #$10
        sta     ZP_VIC_REG_PTR_LO               ; Low Byte of pointer = $10
        lda     #$91
        sta     ZP_VIC_REG_PTR_HI               ; High Byte of pointer = $91 (Base Address of VIA1: $9110)
        lda     #$80
        sta     VIA1_DDR_A                      ; Set User Port VIA Port A Bit 7 as Output, Bits 0-6 as Inputs
        
        ; --- STEP 2: MODE SELECTION VIA VALUE AT ADDR $1C ---
        ldy     #$08                            ; Default Loop Limit Counter = 8 test passes
        lda     #$00                            ; Default Start Index = 0 (Points to "POS EDGE CA1:")
        ldx     $1C                             ; Read Hardware/Mode flag configuration byte at $001C
        beq     LA6FB                           ; If value at $1C is 0, keep defaults and execute full test suite
        lda     #$02                            ; Alternate Mode: Advance Start Index to 2 (Points to "POS EDGE CB1:")
        ldy     #$06                            ; Alternate Mode: Reduce Loop Limit Counter to 6 test passes
LA6FB:  sta     ZP_STRING_SELECT_IDX            ; Store calculated starting text index
        sty     ZP_LOOP_LIMIT_CTR               ; Store loop pass limit counter

        ; --- LOOP 1: PROCESS NON-INTERRUPT CHANNELS (POLLED TIMING) ---
LA6FF:  lda     ZP_STRING_SELECT_IDX            ; Fetch current test ID index
        asl     a                               ; Multiply index by 2 (Left shift) to convert into 16-bit address offset
        tax                                     ; Transfer pointer offset index to X register
        ldy     LA749+1,x                       ; Fetch High Byte of string memory address from vector table
        lda     LA749,x                         ; Fetch Low Byte of string memory address from vector table
        tax                                     ; Move Low Byte to X (UTIL_PRINT_STRING expects address in X/Y or Y/A)
        jsr     UTIL_PRINT_STRING               ; Display current edge/timer test label on the monitor screen
        jsr     UTIL_REFRESH_VIC_COLOR_BARS     ; Force a render cycle refresh to prevent display screen flickering
        jsr     UTIL_VALIDATE_HARDWARE_TIMING   ; Execute the actual real-time edge/timer verification hardware loop
        inc     ZP_STRING_SELECT_IDX            ; Move pointer index to next test string entry
        dec     ZP_LOOP_LIMIT_CTR               ; Decrement remaining loop pass counter
        bne     LA6FF                           ; Branch back if more tests remain in the polled phase

        ; --- PHASE 3: CONFIGURE POINTER FOR VIA2 REGISTERS (INTERRUPT DRIVEN) ---
        lda     #$20
        sta     ZP_VIC_REG_PTR_LO               ; Low Byte of pointer = $20
        lda     #$91
        sta     ZP_VIC_REG_PTR_HI               ; High Byte of pointer = $91 (Base Address of VIA2: $9120)
        lda     #$02
        sta     ZP_LOOP_LIMIT_CTR               ; Set final execution sequence counter to run 2 final tests
        jsr     UTIL_RESET_VIA_PERIPHERALS      ; Initialise/Clear peripheral control states on VIA chips

        ; --- LOOP 2: PROCESS INTERRUPT CHANNELS (TIMER DEV2 REVISIONS) ---
LA728:  lda     ZP_STRING_SELECT_IDX            ; Fetch remaining test ID index (Starts at Index 8 after Loop 1)
        asl     a                               ; Multiply index by 2 for word-aligned table lookup
        tax                                     ; Move offset to X register
        lda     LA749,x                         ; Extract Low Byte of string memory address
        ldy     LA749+1,x                       ; Extract High Byte of string memory address
        tax                                     ; Format address argument for print routine
        jsr     UTIL_PRINT_STRING               ; Display the text block (e.g., " TIMER 1 DEV2:  ")
        jsr     UTIL_REFRESH_VIC_COLOR_BARS     ; Keep system video registers synced during test execution
        cli                                     ; Clear Interrupt Disable Flag (ALLOW 6502 hardware IRQs to trigger)
        jsr     UTIL_VALIDATE_HARDWARE_TIMING   ; Test the countdown/interrupt precision of the VIA internal timers
        inc     ZP_STRING_SELECT_IDX            ; Increment string index tracker
        dec     ZP_LOOP_LIMIT_CTR               ; Decrement loop safety iteration counter
        bne     LA728                           ; Keep going until the remaining 2 timer tests pass or fail
        
        jsr     UTIL_RESET_VIA_PERIPHERALS      ; Safe reset of hardware peripheral states to pristine values
        jmp     INIT_HOOK_SYSTEM_IRQ            ; Exit diagnostics, wire custom IRQ handler vector, and pass control

; --- STRING VECTOR LOOKUP TABLE (16-BIT ADDRESSES) ---
LA749:  .addr   LA75D                           ; Index 0: POS EDGE CA1
        .addr   LA76E                           ; Index 1: NEG EDGE CA1
        .addr   LA77F                           ; Index 2: POS EDGE CB1
        .addr   LA790                           ; Index 3: NEG EDGE CB1
        .addr   LA7A1                           ; Index 4: POS EDGE CB2
        .addr   LA7B2                           ; Index 5: NEG EDGE CB2
        .addr   LA7C3                           ; Index 6: TIMER 1 DEV1
        .addr   LA7D4                           ; Index 7: TIMER 2 DEV1
        .addr   LA7E5                           ; Index 8: TIMER 1 DEV2
        .addr   LA7F6                           ; Index 9: TIMER 2 DEV2

; --- PLAIN TEXT DISPLAY DATA TERMINATED BY REVERSE-VIDEO NULL MARKERS ---
LA75D:  .byte   " POS EDGE CA1:  "
        .byte   $00
LA76E:  .byte   " NEG EDGE CA1:  "
        .byte   $00
LA77F:  .byte   " POS EDGE CB1:  "
        .byte   $00
LA790:  .byte   " NEG EDGE CB1:  "
        .byte   $00
LA7A1:  .byte   " POS EDGE CB2:  "
        .byte   $00
LA7B2:  .byte   " NEG EDGE CB2:  "
        .byte   $00
LA7C3:  .byte   " TIMER 1 DEV1:  "
        .byte   $00
LA7D4:  .byte   " TIMER 2 DEV1:  "
        .byte   $00
LA7E5:  .byte   " TIMER 1 DEV2:  "
        .byte   $00
LA7F6:  .byte   " TIMER 2 DEV2:  "
        .byte   $00

TEST_PHASE_VIC_SOUND:
        ldx     #$16
        ldy     #$A9
        jsr     UTIL_PRINT_STRING
        lda     #$0F
        sta     VIC_REG_AUDIO_VOL
        ldy     #$03
LA815:  ldx     #$80
LA817:  txa
        sta     VIC_REG_AUDIO_BASS,y
        tya
        pha
        ldy     #$FA
        jsr     LAAD5
        pla
        tay
        inx
        cpx     #$01
        bne     LA817
        dey
        bpl     LA815
        lda     #$00
        sta     REG_AUDIO_STATUS_FLG
        jsr     LA8E7
        ldx     #$02
LA836:  ldy     #$FF
LA838:  lda     #$A0
        sta     (ZP_RAM_SIZE_PTR_B_LO),y
        lda     #$06
        sta     (ZP_RAM_SIZE_PTR_A_LO),y
        dey
        dey
        cpy     #$FF
        bne     LA838
        inc     ZP_RAM_SIZE_PTR_B_HI
        inc     ZP_RAM_SIZE_PTR_A_HI
        dex
        bne     LA836
        ldx     #$07
LA84F:  jsr     UTIL_HARDWARE_DELAY
        dex
        bpl     LA84F
        jsr     LA8E7
        lda     #$00
        sta     ZP_AUDIO_FREQ_LO
        sta     ZP_AUDIO_FREQ_HI
LA85E:  jsr     LA8D3
        lda     ZP_AUDIO_FREQ_HI
        cmp     #$10
        beq     LA86F
        clc
        ror     a
        bcs     LA85E
        inc     ZP_AUDIO_FREQ_LO
        bne     LA85E
LA86F:  inc     ZP_RAM_SIZE_PTR_B_HI
        inc     ZP_RAM_SIZE_PTR_A_HI
        ldy     #$00
LA875:  lda     #$A0
        sta     (ZP_RAM_SIZE_PTR_B_LO),y
        lda     ZP_AUDIO_FREQ_LO
        sta     (ZP_RAM_SIZE_PTR_A_LO),y
        iny
        cpy     #$02
        bne     LA875
        lda     #$00
        sta     ZP_AUDIO_FREQ_LO
        lda     #$08
        sta     ZP_AUDIO_FREQ_HI
LA88A:  jsr     LA8D3
        lda     ZP_AUDIO_FREQ_HI
        cmp     #$18
        beq     LA89B
        clc
        ror     a
        bcs     LA88A
        inc     ZP_AUDIO_FREQ_LO
        bne     LA88A
LA89B:  ldx     #$07
LA89D:  jsr     UTIL_HARDWARE_DELAY
        dex
        bpl     LA89D
        lda     #$18
        sta     VIC_REG_BG_BORDER_CLR
        ldx     #$07
LA8AA:  jsr     UTIL_HARDWARE_DELAY
        dex
        bpl     LA8AA
        lda     #$1B
        sta     VIC_REG_BG_BORDER_CLR
        jsr     LA8E7
        ldy     #$00
LA8BA:  lda     #$06
        sta     COLOR_RAM_PAGE_1,y
        sta     COLOR_RAM_PAGE_2,y
        lda     #$20
        sta     VIDEO_RAM_PAGE_1,x
        sta     VIDEO_RAM_PAGE_2,x
        iny
        bne     LA8BA
        lda     #$FF
        sta     REG_AUDIO_STATUS_FLG
        rts

LA8D3:  ldy     ZP_AUDIO_FREQ_HI
LA8D5:  lda     #$A0
        sta     (ZP_RAM_SIZE_PTR_B_LO),y
        lda     ZP_AUDIO_FREQ_LO
        sta     (ZP_RAM_SIZE_PTR_A_LO),y
        tya
        clc
        adc     #$16
        tay
        bcc     LA8D5
        inc     ZP_AUDIO_FREQ_HI
        rts

LA8E7:  lda     #$00
        sta     ZP_RAM_SIZE_PTR_B_LO
        lda     #$1E
        sta     ZP_RAM_SIZE_PTR_B_HI
        lda     #$00
        sta     ZP_RAM_SIZE_PTR_A_LO
        lda     #$96
        sta     ZP_RAM_SIZE_PTR_A_HI
        ldx     #$02
LA8F9:  ldy     #$00
LA8FB:  lda     #$20
        sta     (ZP_RAM_SIZE_PTR_B_LO),y
        lda     #$01
        sta     (ZP_RAM_SIZE_PTR_A_LO),y
        iny
        bne     LA8FB
        inc     ZP_RAM_SIZE_PTR_B_HI
        inc     ZP_RAM_SIZE_PTR_A_HI
        dex
        bne     LA8F9
        dec     ZP_RAM_SIZE_PTR_B_HI
        dec     ZP_RAM_SIZE_PTR_B_HI
        dec     ZP_RAM_SIZE_PTR_A_HI
        dec     ZP_RAM_SIZE_PTR_A_HI
        rts

STR_SOUND_TEST_PTR:
        .byte   $0D
        .byte   " SOUND TEST:"

        .byte   $0D,$00
UTIL_REFRESH_VIC_COLOR_BARS:
        inc     ZP_DIAG_CHECKPOINT_CTR
        lda     #$7F
        ldy     #$0E
        sta     (ZP_VIC_REG_PTR_LO),y
        ldy     #$0D
        lda     (ZP_VIC_REG_PTR_LO),y
        sta     (ZP_VIC_REG_PTR_LO),y
        ldx     ZP_STRING_SELECT_IDX
        ldy     VIC_TABLE_REG_OFFSETS,x
        lda     VIC_TABLE_PAL_GEOMETRY,x
        sta     (ZP_VIC_REG_PTR_LO),y
        lda     VIC_TABLE_SCREEN_COLS,x
        ldy     #$0C
        sta     (ZP_VIC_REG_PTR_LO),y
        lda     #$00
        ldy     #$0B
        sta     (ZP_VIC_REG_PTR_LO),y
        lda     #$FF
        ldy     #$04
        sta     (ZP_VIC_REG_PTR_LO),y
        lda     #$FF
        ldy     #$05
        sta     (ZP_VIC_REG_PTR_LO),y
        lda     #$FF
        ldy     #$08
        sta     (ZP_VIC_REG_PTR_LO),y
        lda     #$FF
        ldy     #$09
        sta     (ZP_VIC_REG_PTR_LO),y
        ldy     #$0B
        lda     VIC_TABLE_SYNC_MARKERS,x
        sta     (ZP_VIC_REG_PTR_LO),y
        ldy     #$0D
        lda     (ZP_VIC_REG_PTR_LO),y
        sta     (ZP_VIC_REG_PTR_LO),y
        ldy     #$0E
        lda     VIC_TABLE_AUDIO_VOICES,x
        sta     (ZP_VIC_REG_PTR_LO),y
        rts

VIC_TABLE_NTSC_GEOMETRY:
        .byte   $00,$80,$C0,$E0,$0C,$C0,$FF,$FF
        .byte   $FF,$FF
VIC_TABLE_PAL_GEOMETRY:
        .byte   $80,$00,$E0,$C0,$0E,$0C,$FF,$FF
        .byte   $FF,$FF
VIC_TABLE_SCREEN_COLS:
        .byte   $01,$00,$10,$00,$40,$20,$00,$00
        .byte   $00,$00
VIC_TABLE_AUDIO_VOICES:
        .byte   $82,$82,$90,$90,$88,$88,$C0,$A0
        .byte   $C0,$A0
VIC_TABLE_REG_OFFSETS:
        .byte   $0F,$0F,$1C,$1C,$1C,$1C,$05,$09
        .byte   $05,$09
VIC_TABLE_SYNC_MARKERS:
        .byte   $00,$00,$00,$00,$00,$00,$FF,$00
        .byte   $FF,$00
VIC_TABLE_ROW_SPACERS_A:
        .byte   $00,$00,$00,$00,$00,$00,$3A,$3A
        .byte   $3A,$3A
VIC_TABLE_ROW_SPACERS_B:
        .byte   $00,$00,$00,$00,$00,$00,$33,$33
        .byte   $33,$33
UTIL_RESET_VIA_PERIPHERALS:
        ldx     #$0F
        lda     #$00
LA9CB:  sta     VIA1_PORT_B,x
        dex
        bpl     LA9CB
        lda     #$7F
        sta     VIA1_INT_ENABLE
        ldx     #$0F
        lda     #$00
LA9DA:  sta     VIA2_PORT_B,x
        dex
        bpl     LA9DA
        lda     #$7F
        sta     VIA1_INT_ENABLE
        rts

INIT_HOOK_SYSTEM_IRQ:
        ; --- RESTORE RUNTIME IRQ VECTOR ---
        sei                             ; Disable interrupts while rewriting the system vector
        lda     #<IRQ_HANDLER           ; Load low byte of the runtime system IRQ handler
        sta     RAM_IRQ_VECTOR_LO       ; Direct KERNAL vector to the new handler ($0314)
        lda     #>IRQ_HANDLER           ; Load high byte of the runtime system IRQ handler
        sta     RAM_IRQ_VECTOR_HI       ; Direct KERNAL vector to the new handler ($0315)

        ; --- CONFIGURE VIA2 TIMER 1 FOR CONTINUOUS INTERRUPTS ---
        lda     #$40                    ; Binary %01000000: Set Timer 1 to continuous interrupts (Bit 6)
        sta     VIA2_AUX_CTRL           ; Update VIA2 Auxiliary Control Register ($912B)
        lda     #$C0                    ; Binary %11000000: Enable Timer 1 Interrupt (Set Bit 7 Enable + Bit 6 T1)
        sta     VIA2_INT_ENABLE         ; Update VIA2 Interrupt Enable Register ($912E)

        ; --- START HEARTBEAT CLOCK COUNTDOWN ---
        ; Sets a latched 16-bit countdown value of $4289 (17,033 clock cycles)
        ; At 1.02 MHz (PAL) / 1.01 MHz (NTSC), this generates an IRQ roughly every 1/60th of a second.
        lda     #$89
        sta     VIA2_T1_CTR_LO          ; Write low byte of latch/counter ($9124)
        lda     #$42
        sta     VIA2_T1_CTR_HI          ; Write high byte of counter ($9125) and active-start the timer

        cli                             ; Safely re-enable interrupts to start the heartbeat clock
        rts                             ; Return from setup block

IRQ_HANDLER:
        ; --- MASTER SYSTEM RASTER / SIGNAL POLLING LOOP ---
        lda     $9C00                   ; Check an I/O or state tracking register address
        and     #$01                    ; Isolate bit 0
        bne     IRQ_HANDLER             ; Spin-wait here if bit 0 is high (awaits custom sync condition)

        ; --- VISUAL FLASH TIMER / PULSE ACCUMULATOR ---
        dec     $0410                   ; Decrement the flash/tick timer variable at $0410
        bpl     LAA23                   ; If the counter is still positive (>= 0), branch past flash toggle

        ; --- TOGGLE BACKGROUND/BORDER FLIPPERS ---
        lda     #$08
        sta     $0410                   ; Reset flash tick counter back to 8 frames
        lda     #$C0                    ; Load bitmask value
        eor     $0411                   ; XOR with current state tracking register at $0411 to flip bits
        sta     $9800                   ; Write updated value directly to video/system memory location $9800
        sta     $0411                   ; Store updated tracking bit back into $0411

        ; --- TICK TIME ENGINE ---
LAA23:  jsr     INIT_STEP_BCD_CLOCK     ; Advance real-time clock array bytes using 6502 decimal mode (`sed`)
        jsr     INIT_REFRESH_CLOCK_BANNER ; Redraw the flashing clock text data dynamically onto the VIC screen
        
        ; --- ACKNOWLEDGE HARDWARE TIMERS ---
        lda     VIA2_INT_FLAGS          ; Read the current VIA2 Interrupt Flags
        sta     VIA2_INT_FLAGS          ; Write 1s back to clear Timer 1 interrupt latch, resetting the hardware pin
        
        ; --- CLEAN STACK RESTORATION ---
        pla                             ; Pull saved Y register value from the Stack
        tay                             ; Restore original Index Register Y
        pla                             ; Pull saved X register value from the Stack
        tax                             ; Restore original Index Register X
        pla                             ; Pull saved Accumulator value from the Stack
        rti                             ; Return From Interrupt (Restores Processor Flags and Program Counter)

INIT_STEP_BCD_CLOCK:
        sed
        dec     $0418
        bpl     LAA44
        lda     #$5F
        sta     $0418
        lda     $0417
LAA44           := * + 1
        bit     $01A9
        ldx     #$00
        ldy     #$04
LAA4A:  clc
        adc     $0412,y
        sta     $0412,y
        cmp     CLOCK_BCD_CARRY_THRESHOLDS,y
        bcc     LAA61
        sbc     CLOCK_BCD_CARRY_THRESHOLDS,y
        sta     $0412,y
        lda     #$01
        dey
        bpl     LAA4A
LAA61:  cld
        rts

CLOCK_BCD_CARRY_THRESHOLDS:
        .byte   $99,$24,$60,$60,$60
INIT_REFRESH_CLOCK_BANNER:
        lda     REG_AUDIO_STATUS_FLG
        bne     LAAA6
        lda     VIDEO_RAM_PAGE_1
LAA70:  cmp     #$FF
        beq     LAAA6
        ldx     #$15
        ldy     #$02
LAA78:  lda     CLOCK_BANNER_TEXT_TEMPLATE,x
        sta     $1FE4,x
        lda     #$02
        sta     $97E4,x
        dex
        bpl     LAA78
        ldx     #$03
        stx     $0419
LAA8B:  ldx     $0419
        lda     $0412,x
        jsr     UTIL_SPLIT_BYTE_TO_SCREEN_CODES
        pha
        lda     CLOCK_BANNER_COLUMN_OFFSETS,x
        tax
        tya
        sta     $1FE4,x
        pla
        sta     $1FE5,x
        dec     $0419
        bpl     LAA8B
LAAA6:  rts

CLOCK_BANNER_COLUMN_OFFSETS:
        .byte   $01,$0E,$11,$14
CLOCK_BANNER_TEXT_TEMPLATE:
        .byte   $A0,$A0,$A0,$A0,$84,$81,$99,$93
        .byte   $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
        .byte   $BA,$00,$00,$BA,$A0,$A0
UTIL_SPLIT_BYTE_TO_SCREEN_CODES:
        pha
        lsr     a
        lsr     a
        lsr     a
        lsr     a
        ora     #$B0
        tay
        pla
        and     #$0F
        ora     #$B0
        rts

UTIL_WRITE_INDIRECT_CHAR:
        sta     (ZP_PTR_INDIRECT_A_LO),y
UTIL_HARDWARE_DELAY:
        lda     #$00
        tay
        clc
LAAD5:  adc     #$01
        bne     LAAD5
        iny
        bne     LAAD5
        rts

UTIL_VALIDATE_HARDWARE_TIMING:
        lda     #$00
        sta     ZP_SAVED_REG_D
        sta     ZP_SAVED_REG_C
        sta     ZP_SAVED_REG_F
        lda     #$FF
        sta     ZP_SAVED_REG_E
        ldx     ZP_STRING_SELECT_IDX
        lda     VIC_TABLE_REG_OFFSETS,x
        clc
        adc     ZP_VIC_REG_PTR_LO
        sta     ZP_PTR_INDIRECT_A_LO
        lda     #$00
        adc     ZP_VIC_REG_PTR_HI
        sta     ZP_PTR_INDIRECT_A_HI
        lda     VIC_TABLE_NTSC_GEOMETRY,x
        ldy     #$00
        jsr     UTIL_WRITE_INDIRECT_CHAR
        lda     ZP_SAVED_REG_F
        bne     LAB0B
LAB05:  jsr     UTIL_FLASH_ERROR_HANDLER
        jmp     LAB05

LAB0B:  ldy     #$00
        sty     ZP_SAVED_REG_E
        ldy     ZP_STRING_SELECT_IDX
        stx     ZP_TEMP_STRING_LEN
        lda     VIC_TABLE_ROW_SPACERS_A,y
        sec
        sbc     ZP_SAVED_REG_C
        sta     ZP_TEMP_CHAR_DATA
        lda     VIC_TABLE_ROW_SPACERS_B,y
        sbc     ZP_SAVED_REG_D
        bpl     LAB32
        eor     #$FF
        tax
        lda     ZP_TEMP_CHAR_DATA
        eor     #$FF
        clc
        adc     #$01
        sta     ZP_TEMP_CHAR_DATA
        bcc     LAB31
        inx
LAB31:  txa
LAB32:  bne     LAB3F
        lda     ZP_TEMP_CHAR_DATA
        and     #$F8
        bne     LAB3F
        ldx     ZP_TEMP_STRING_LEN
        jmp     UTIL_PRINT_PASS_STATUS

LAB3F:  ldx     ZP_TEMP_STRING_LEN
        jsr     UTIL_FLASH_ERROR_HANDLER
        jmp     UTIL_VALIDATE_HARDWARE_TIMING

        rts

VIA_EDGE_NMI_HANDLER:
        ; --- NMI REGISTER PRESERVATION PHASE ---
        pha                                     ; Push Accumulator (A) onto the Stack
        txa                                     ; Transfer Index Register X to Accumulator
        pha                                     ; Push original X onto the Stack
        tya                                     ; Transfer Index Register Y to Accumulator
        pha                                     ; Push original Y onto the Stack
        ; Note: Execution falls directly into the IRQ handler to reuse the verification logic.

VIA_EDGE_IRQ_HANDLER:
        ; --- INTERRUPT VALIDATION PHASE ---
        lda     ZP_SAVED_REG_E                  ; Check expected interrupt flag condition variable
        beq     ERR_HANDLER_CATASTROPHIC_IRQ    ; If 0, an interrupt fired when it shouldn't have (Catastrophic Fault)
        sta     ZP_SAVED_REG_F                  ; Log/mirror the triggered interrupt status byte into storage
        
        ; --- HARDWARE FLAG VERIFICATION ---
        ldy     ZP_STRING_SELECT_IDX            ; Fetch the active test index (0-9 from the prior edge test block)
        lda     VIC_TABLE_AUDIO_VOICES,y        ; Look up the expected bitmask for this specific edge/timer test
        and     #$7F                            ; Mask out the highest bit to isolate the targeted interrupt bit
        ldy     #$0D                            ; Offset $0D on a 6522 VIA is the Interrupt Flag Register (IFR)
        and     (ZP_VIC_REG_PTR_LO),y           ; Read VIA IFR (via the pointer set in prior phase) and mask with expected bit
        beq     ERR_HANDLER_CATASTROPHIC_IRQ    ; If masked bit is 0, the expected hardware flag never actually tripped!

        ; --- ACKNOWLEDGE / CLEAR HARDWARE INTERRUPTS ---
        lda     (ZP_VIC_REG_PTR_LO),y           ; Re-read the VIA Interrupt Flag Register state
        sta     (ZP_VIC_REG_PTR_LO),y           ; Write the value back to the IFR (6522 mechanism: writing a 1 clears that flag)
        lda     #$7F                            ; Load bitmask to clear interrupt enable states
        ldy     #$0E                            ; Offset $0E on a 6522 VIA is the Interrupt Enable Register (IER)
        sta     (ZP_VIC_REG_PTR_LO),y           ; Write to IER to safely disable further interrupts from this source

        ; --- STACK RESTORATION & RETURN ---
        pla                                     ; Pull saved Y register value from the Stack
        tay                                     ; Restore original Index Register Y
        sty     ZP_SAVED_REG_D                  ; Back up Y to a temporary zero-page tracking variable for debugging
        pla                                     ; Pull saved X register value from the Stack
        tax                                     ; Restore original Index Register X
        pla                                     ; Pull saved Accumulator value from the Stack
        sta     ZP_SAVED_REG_C                  ; Back up A to a temporary zero-page tracking variable
        rti                                     ; Return From Interrupt (Restores Processor Flags and Program Counter)

ERR_HANDLER_CATASTROPHIC_IRQ:
        ; --- CLEAN UP THE OFFENDING HARDWARE FLAG ---
        ; Y register contains $0D (offset for the 6522 VIA Interrupt Flag Register)
        ; transferred directly from the active verification check inside the handler.
        lda     (ZP_VIC_REG_PTR_LO),y           ; Read the current contents of the VIA Interrupt Flag Register (IFR)
        sta     (ZP_VIC_REG_PTR_LO),y           ; Write the value back to the IFR to clear the latching bits (Write-1-to-Clear)

        ; --- UI ERROR PRINT PHASE ---
        ldx     #<STR_WRONG_INTERRUPT_PTR       ; Load low byte of the catastrophic error string address
        ldy     #>STR_WRONG_INTERRUPT_PTR       ; Load high byte of the catastrophic error string address
        jsr     UTIL_PRINT_STRING               ; Display the diagnostic error message/code on the monitor

        ; --- TRAP ARCHITECTURE LOCKUP ---
LAB7F:  jsr     UTIL_FLASH_ERROR_HANDLER        ; Call the global video register routine to flash the screen border
        jmp     LAB7F                           ; Permanent infinite loop to completely stop execution

UTIL_HEX_CONVERT_AND_CLEAN:
        jsr     UTIL_HEX_TO_ASCII
        pla
        rts

UTIL_HEX_CONVERT_PRESERVE_REG:
        pha
        tya
        jsr     UTIL_HEX_TO_ASCII
        tay
        pla
        rts

STR_WRONG_INTERRUPT_PTR:
        .byte   "WRONG INTERUPT"

        .byte   $00
UTIL_RECYCLE_RESET:
        ldx     #$19
LABA3:  jsr     UTIL_CLEAR_SCREEN_CANVAS
        dex
        bne     LABA3
        rts

UTIL_PRINT_CHAR_REVERSE_MODE:
        ldy     #$80
        sty     ZP_SCREEN_BUF_POS
        jsr     UTIL_PRINT_CHAR
        txa
UTIL_PRINT_CHAR:
        sta     ZP_TEMP_CHAR_DATA
        and     #$7F
        cmp     #$0D
        beq     UTIL_CLEAR_SCREEN_CANVAS
        stx     ZP_TEMP_STRING_LEN
        ldx     ZP_PORT_LINE_OFFSET
        and     #$3F
        ora     ZP_SCREEN_BUF_POS
        sta     $1FB8,x
        inx
        stx     ZP_PORT_LINE_OFFSET
        bne     LAC02
UTIL_CLEAR_SCREEN_CANVAS:
        stx     ZP_TEMP_STRING_LEN
        sty     ZP_SCREEN_SCROLL_FLG
        ldx     #$00
LABD0:  lda     SCR_ROW_ADDR_LO_BASE,x
        sta     $00
        lda     SCR_ROW_ADDR_HI_BASE,x
        sta     $01
        lda     SCR_ROW_ADDR_LO_OFFSETS,x
        sta     ZP_PTR_INDIRECT_A_LO
        lda     SCR_ROW_ADDR_HI_OFFSETS,x
        sta     ZP_PTR_INDIRECT_A_HI
        ldy     #$15
LABE6:  lda     (ZP_PTR_INDIRECT_A_LO),y
        sta     ($00),y
        dey
        bpl     LABE6
        inx
        cpx     #$15
        bcc     LABD0
        ldy     #$15
        lda     #$20
LABF6:  sta     (ZP_PTR_INDIRECT_A_LO),y
        dey
        bpl     LABF6
        iny
        sty     ZP_SCREEN_BUF_POS
        sty     ZP_PORT_LINE_OFFSET
        ldy     ZP_SCREEN_SCROLL_FLG
LAC02:  ldx     ZP_TEMP_STRING_LEN
        lda     ZP_TEMP_CHAR_DATA
        rts

UTIL_HEX_TO_ASCII:
        pha
        lsr     a
        lsr     a
        lsr     a
        lsr     a
        jsr     LAC12
        pla
        and     #$0F
LAC12:  clc
        adc     #$F6
        bcc     LAC19
        adc     #$06
LAC19:  adc     #$3A
        bne     UTIL_PRINT_CHAR
        jsr     UTIL_HEX_TO_ASCII
        txa
        jsr     UTIL_PRINT_CHAR
        rts

UTIL_FLASH_ERROR_HANDLER:
        lda     ZP_DIAG_CHECKPOINT_CTR
LAC27:  sei
        ldx     ZP_MATRIX_SCAN_CTR
        bne     LAC3E
        ldx     #$FF
        stx     ZP_MATRIX_SCAN_CTR
        stx     ZP_PTR_INDIRECT_A_LO
        eor     #$FF
        sta     $9800
        ldx     #$B1
        ldy     #$AC
        jsr     UTIL_PRINT_STRING
LAC3E:  jsr     UTIL_HARDWARE_DELAY
        ldx     #$15
LAC43:  lda     SCR_ROW_ADDR_LO_BASE,x
        sta     $11
        lda     SCR_ROW_ADDR_HI_BASE,x
        sta     $12
        ldy     #$15
LAC4F:  lda     ($11),y
        eor     #$80
        sta     ($11),y
        dey
        bpl     LAC4F
        dex
        bpl     LAC43
        rts

UTIL_PRINT_STRING:
        stx     ZP_STRING_TEMP_LO
        sty     ZP_STRING_TEMP_HI
        ldy     #$00
LAC62:  lda     (ZP_STRING_TEMP_LO),y
        beq     LAC6C
        jsr     UTIL_PRINT_CHAR
        iny
        bne     LAC62
LAC6C:  rts

LAC6D:  lda     #$80
        sta     ZP_SCREEN_BUF_POS
        jsr     UTIL_PRINT_STRING
        lda     #$00
        sta     ZP_SCREEN_BUF_POS
        rts

UTIL_PRINT_PASS_STATUS:
        ldx     #$81
        ldy     #$AC
        jsr     UTIL_PRINT_STRING
        rts

STR_OK_PTR:
        .byte   "OK"
        .byte   $0D,$00
SCR_ROW_ADDR_LO_BASE:
        .byte   $00
SCR_ROW_ADDR_LO_OFFSETS:
        .byte   $16,$2C,$42,$58,$6E,$84,$9A,$B0
        .byte   $C6,$DC,$F2,$08,$1E,$34,$4A,$60
        .byte   $76,$8C,$A2,$B8,$CE
SCR_ROW_ADDR_HI_BASE:
        .byte   $1E
SCR_ROW_ADDR_HI_OFFSETS:
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E
        .byte   $1E,$1E,$1E,$1F,$1F,$1F,$1F,$1F
        .byte   $1F,$1F,$1F,$1F
        .byte   $1F
STR_DICTIONARY_PTR:
        .byte   "BAD"
        .byte   $00
        .byte   "E"
        .byte   $AA,$AB
        .byte   "TIMTEM"
        .byte   $04,$19
        .byte   "TINIT "
        .byte   $A0,$40
        .byte   "TK105 "
        .byte   $A4,$78
        .byte   "TKEY10"
        .byte   $A4,$73
        .byte   "TKEYS "
        .byte   $A4,$22
        .byte   "TRGVAL"
        .byte   $A9,$77
        .byte   "TRIGER"
        .byte   $AA,$DD
        .byte   "TSTNUM"
        .byte   $00,$18
        .byte   "TVIC  "
        .byte   $A0,$09
        .byte   "TWOBYT"
        .byte   $AA,$C1
        .byte   "UNTRG "
        .byte   $A9,$81
        .byte   "UPTIME"
        .byte   $AA,$44
        .byte   "USRMS "
        .byte   $A4,$C5
        .byte   "USRTST"
        .byte   $A6,$93
        .byte   "VIC50 "
        .byte   $A0,$20
        .byte   "VICCOL"
        .byte   $96,$00
        .byte   "VICREG"
        .byte   $90,$00
        .byte   "VICSCN"
        .byte   $1E,$00
        .byte   "WA100 "
        .byte   $AA,$D5
        .byte   "WA400 "
        .byte   $AB,$0B
        .byte   "WA600 "
        .byte   $AB,$31
        .byte   "WA700 "
        .byte   $AB,$32
        .byte   "WAIT  "
        .byte   $AA,$D1
        .byte   "WAITZ "
        .byte   $AA,$FE
        .byte   "WBAD  "
        .byte   $AB,$3F
        .byte   "WHITE "
        .byte   $00,$01
        .byte   "WR400 "
        .byte   $AC,$12
        .byte   "WR500 "
        .byte   $AC,$19
        .byte   "WROB  "
        .byte   $AC,$07
        .byte   "WRONG "
        .byte   $AB,$74
        .byte   "WTLP1 "
        .byte   $A8,$4F
        .byte   "WTLP4 "
        .byte   $A8,$9B
        .byte   "WTLP41"
        .byte   $A8,$9D
        .byte   "WTLP5 "
        .byte   $A8,$AA
        .byte   "ZLOOP "
        .byte   $A0,$82
        .byte   "ZMSG1 "
        .byte   $A0,$77
        .byte   "ZP100 "
        .byte   $A0,$80
        .byte   "ZP120 "
        .byte   $A0,$A3
        .byte   "ZP140 "
        .byte   $A0,$CF
        .byte   "ZP200 "
        .byte   $A0,$8B
        .byte   "ZPADR "
        .byte   $A0,$C1
        .byte   "ZPALT "
        .byte   $A0,$B0
        .byte   "ZPB30 "
        .byte   $A0,$E1
        .byte   "ZPB50 "
        .byte   $A0,$FF
        .byte   "ZPBAD "
        .byte   $A0,$D5
        .byte   "ZPMSG "
        .byte   $A1,$D9
        .byte   "ZPST10"
        .byte   $A0,$92,$00,$24,$F5
        jmp     LF2AE

        jmp     LAA70

        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA
