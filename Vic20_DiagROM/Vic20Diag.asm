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
ZP_SCREEN_SCROLL_FLG  := $000B
ZP_TIME_ELAPSED_LO    := $000C
ZP_TIME_ELAPSED_HI    := $000D
ZP_INT_EXPECTED_FLG   := $000E
ZP_INT_TRIGGERED_FLG  := $000F
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
ZP_PTR_COLOR_RAM_LO:= $001E
ZP_PTR_COLOR_RAM_HI:= $001F
ZP_PTR_SCREEN_RAM_LO:= $0020
ZP_PTR_SCREEN_RAM_HI:= $0021
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
        jsr     UTIL_PRINT_STRING_INVERTED
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
        ; --- TEST SUITE INITIALIZATION ---
        ldx     #$02
        stx     $1C                             ; Set loop index tracker at $1C to 2 (corresponds to Cartridge ROM)

TEST_PHASE_ROM_CHECKSUM:
        ; --- UI TEXT LAYER OUTPUT ---
        ldx     #<STR_ROMCHECK_PTR              ; Load low byte of " ROMCHECK " string descriptor
        ldy     #>STR_ROMCHECK_PTR              ; Load high byte of " ROMCHECK " string descriptor
        jsr     UTIL_PRINT_STRING               ; Display string header on the user terminal screen [1]

        ; --- MEMORY SCAN CONFIGURATION ---
        ldx     $1C                             ; Fetch the active ROM block index identifier [1]
        lda     ROM_START_HI_BYTES,x            ; Look up the starting high memory address byte ($C0, $E0, or $80) [1]
        sta     ZP_PTR_INDIRECT_A_HI            ; Write target block boundary start location into tracking pointer [1]
        lda     ROM_PAGE_COUNT_SIZERS,x         ; Look up number of 256-byte pages to read ($20=8KB, $10=4KB) [1]
        sta     REG_LOOP_IDX                    ; Store block size page count inside tracking counter variable [1]
        lda     #$00
        sta     ZP_PTR_INDIRECT_A_LO            ; Force tracking memory pointer low byte to $00 (page boundary align) [1]

        ; --- CUSTOM ROM HARDWARE BYPASS DETECTOR ---
        cpx     #$01                            ; Are we currently validating the KERNAL ROM space (Index 1)? [1]
        bne     LA3E0                           ; If not validating KERNAL space, skip straight to core accumulator loop [1]
        ldy     $F75D                           ; Read a signature memory byte from deep inside standard KERNAL space [1]
        cpy     #$4C                            ; Does the memory hold $4C (the 6502 absolute JMP instruction opcode)? [1]
        beq     LA3FA                           ; If JMP is found, abort verification and jump to failure handler [1]

        ; --- THE CORE 8-BIT ADDITION CHECKSUM ENGINE ---
LA3E0:  tay                                     ; Initialize Y index tracking register to $00 [1]
        clc                                     ; Clear Carry flag prior to starting accumulation logic [1]
LA3E2:  adc     (ZP_PTR_INDIRECT_A_LO),y        ; Add content of targeted ROM byte to current running total [1]
        iny                                     ; Advance index pointer to next sequential byte location [1]
        bne     LA3E2                           ; Loop back until Y rolls past 255 to $00 (completes full 256-byte page) [1]
        
        inc     ZP_PTR_INDIRECT_A_HI            ; Advance indirect memory address pointer up to next memory page [1]
        dec     REG_LOOP_IDX                    ; Decrement remaining pages variable counter [1]
        bne     LA3E2                           ; Keep computing addition if more pages exist in current block [1]
        
        adc     #$00                            ; Pull in final leftover carry bit state to finalize 8-bit checksum total [1]
        pha                                     ; Push calculated final checksum onto the stack for safe storage [1]
        jsr     UTIL_HEX_TO_ASCII               ; Convert checksum to text characters and display them on screen [1]
        pla                                     ; Retrieve calculated checksum back from stack [1]
        
        cmp     ROM_TARGET_CHECKSUMS,x          ; Compare the calculated total to the official hardcoded target table [1]
        beq     LA400                           ; If value perfectly matches expectations, proceed to next memory block [1]

LA3FA:  jsr     UTIL_FLASH_ERROR_HANDLER        ; Error Route: Checksum mismatched or validation bypass tripped [1]
        jmp     LA3FA                           ; Freeze system inside permanent error trap loop [1]

LA400:  lda     #$0D                            ; Load standard Carriage Return/New Line ASCII code [1]
        jsr     UTIL_PRINT_CHAR                 ; Print carriage return to clear text row for next module [1]
        inc     ZP_DIAG_CHECKPOINT_CTR          ; Advance diagnostic system global milestone progress step counter [1]
        dec     $1C                             ; Decrement ROM target table array selector index pointer [1]
        bpl     TEST_PHASE_ROM_CHECKSUM         ; Loop backward to process next block if index is still positive (>=0) [1]
        jmp     UTIL_CLEAR_SCREEN_CANVAS        ; All 3 ROM blocks passed successfully! Wipe screen and advance [1]

STR_ROMCHECK_PTR:
        .byte   " ROMCHECK "
        .byte   $00

ROM_START_HI_BYTES:
        ; Addresses: Index 0 = $C000 (BASIC), Index 1 = $E000 (KERNAL), Index 2 = $8000 (Cartridge Base) [1]
        .byte   $C0,$E0,$80

ROM_PAGE_COUNT_SIZERS:
        ; Page sizes: $20 pages = 8,192 bytes, $10 pages = 4,096 bytes [1]
        .byte   $20,$20,$10

ROM_TARGET_CHECKSUMS:
        ; Hardcoded reference values representing the exact expected arithmetic total for each block [1]
        .byte   $C0,$E0,$FF

TEST_PHASE_KEYBOARD:
        ; --- UI DISPLAY PHASE ---
        ldx     #<STR_KEYBOARD_TEST_PTR         ; Load low byte of " KEYBOARD TEST  " string pointer
        ldy     #>STR_KEYBOARD_TEST_PTR         ; Load high byte of " KEYBOARD TEST  " string pointer
        jsr     UTIL_PRINT_STRING               ; Output the string to the monitor screen
        
        ; --- PHASE 1 INITIALIZATION: DDR & PORT CYCLE TIMING ---
        ldy     #$01
        sty     REG_LOOP_IDX                    ; Initialize loop tracker to 1 (will test Port B, then Port A via offset table)
LA42E:  ldx     REG_LOOP_IDX                    ; Fetch current loop index position
        ldy     VIA_PORT_OFFSET_TABLE,x         ; Look up register offset (typically maps to Port A/B data direction registers)
        ldx     #$00
        stx     VIA2_DDR_A                      ; Force VIA2 Port A completely to inputs
        stx     VIA2_DDR_B                      ; Force VIA2 Port B completely to inputs

        ; --- THE 256-BYTE VALUE TRACE LOOP ---
        ; This inner loop tests every possible bit pattern (0-255) to ensure the 6522 silicon
        ; latches and mirrors data lines reliably without dropping bits.
LA43C:  txa                                     ; Transfer the loop sequence value (0-255) to Accumulator
        sta     VIA2_DDR_B,y                    ; Write pattern directly into the targeted Data Direction Register
        eor     #$FF                            ; Invert the pattern bits
        sta     VIA2_PORT_B,y                   ; Write inverted pattern directly to the matching Port Data register
        cmp     VIA2_PORT_B,y                   ; Read it back and verify if it matches what was written
        bne     LA440                           ; Catch Fault: Silicon failure or pin short. Go to trap.
        inx                                     ; Increment testing pattern byte
        bne     LA43C                           ; Continue looping until X rolls over to 00
        
        dec     REG_LOOP_IDX                    ; Decrement the outer register loop index
        bpl     LA42E                           ; Repeat the 256-value stress test for the next port up

        ; --- PHASE 2: STATIC FLOATING PIN ANALYSIS ---
        ldx     #$FF
        stx     VIA2_DDR_B                      ; Reconfigure VIA2 Port B fully as Outputs
        inx                                     ; Increment X to $00
        stx     VIA2_DDR_A                      ; Reconfigure VIA2 Port A fully as Inputs
        stx     VIA2_PORT_B                     ; Drive all Port B output lines Low ($00)
        
        cpx     VIA2_PORT_A                     ; Read Port A inputs and compare to 00
        beq     LA473                           ; If Port A reads 00, lines are pulled low (external harness present)
        
        ; --- HARNESS SELECTION AUTODETECT ---
        ldx     VIA2_PORT_A                     ; Re-read Port A inputs to verify harness type
        cpx     #$FF                            ; If $FF, the lines are floating High (No test harness connected)
        bne     LA490                           ; Catch Fault: Lines are mismatched (Partial short or bad board)
        
        ; NO JIG DETECTED MODE: Safely bypass the physical matrix check
        inc     ZP_DIAG_CHECKPOINT_CTR          ; Increment diagnostic stage tracker
        lda     #$FF
        sta     $1C                             ; Store flag $FF at address $1C (Flags timing check loop to skip early stages)
        jmp     UTIL_PRINT_PASS_STATUS          ; Print PASS/OK for the VIA chip test itself, then exit

        ; --- PHASE 3: THE WALKING-BIT MATRIX MATRIX LOOP (JIG CONTEXT) ---
        ; Executes if the external test jig actively tied the lines low.
LA473:  lda     #$FE                            ; Binary %11111110 (Isolates Bit 0 with a low bit)
        sta     VIA2_PORT_B                     ; Send walking low bit out to the matrix rows via Port B
LA478:  lda     VIA2_PORT_A                     ; Read back response from columns via Port A
        cmp     VIA2_PORT_B                     ; Check if the low bit successfully crossed over into Port A
        bne     LA490                           ; Catch Fault: Bit missed or cross-talk shorted another pin
        sec                                     ; Set Carry flag for rotation
        rol     VIA2_PORT_B                     ; Rotate bit pattern left (e.g. %11111110 becomes %11111101)
        bcs     LA478                           ; Keep looping and checking until the low zero-bit shifts out completely
        
        ; JIG VALIDATION MODE SUCCESS
        jsr     UTIL_PRINT_PASS_STATUS          ; Matrix loop cleanly verified. Print "OK" status.
        inc     ZP_DIAG_CHECKPOINT_CTR          ; Increment diagnostic test stage tracking counter
        lda     #$00
        sta     $1C                             ; Store flag $00 at address $1C (Informs timing suite to run full tests)
        rts                                     ; Return from Subroutine

        ; --- TRAP ARCHITECTURE LOCKUP ---
LA490:  jsr     UTIL_FLASH_ERROR_HANDLER        ; Call global warning routine to flash the screen matrix borders
        jmp     LA490                           ; Permanent infinite loop to completely stop execution

TEST_VIA_EDGE_IRQ_SETUP:
        ; --- CRITICAL SECTION ENTRY ---
        sei                                     ; Set Interrupt Disable (Inhibits standard maskable IRQs)
                                                ; Prevents an IRQ from firing mid-setup while vectors are half-written.

        ; --- PATCH HARDWARE IRQ VECTOR ---
        lda     #<VIA_EDGE_IRQ_HANDLER          ; Extract low byte of the Edge IRQ Handler address
        sta     RAM_IRQ_VECTOR_LO               ; Inject into the low-byte RAM destination ($0314)
        lda     #>VIA_EDGE_IRQ_HANDLER          ; Extract high byte of the Edge IRQ Handler address
        sta     RAM_IRQ_VECTOR_HI               ; Inject into the high-byte RAM destination ($0315)

        ; --- PATCH HARDWARE NMI VECTOR ---
        lda     #<VIA_EDGE_NMI_HANDLER          ; Extract low byte of the Edge NMI Handler address
        sta     RAM_NMI_VECTOR_LO               ; Inject into the low-byte RAM destination ($0318)
        lda     #>VIA_EDGE_NMI_HANDLER          ; Extract high byte of the Edge NMI Handler address
        sta     RAM_NMI_VECTOR_HI               ; Inject into the high-byte RAM destination ($0319)
        
        ; --- EXIT AND RETURN ---       
        rts                                     ; Return from Subroutine (leaves IRQs disabled for caller control)

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
        ; --- UI TEXT LAYER OUTPUT ---
        ldx     #<STR_SOUND_TEST_PTR            ; Load low byte of the "\n SOUND TEST:\n" string descriptor
        ldy     #>STR_SOUND_TEST_PTR            ; Load high byte of the string descriptor
        jsr     UTIL_PRINT_STRING               ; Display string header on the user terminal screen

        ; --- PHASE 1: AUDIO MIXER INITIALIZATION ---
        lda     #$0F                            ; Set volume to 15 (Maximum volume allowed by the 6560 VIC)
        sta     VIC_REG_AUDIO_VOL               ; Update audio volume register ($900E)
        ldy     #$03                            ; Initialize voice loop index to 3 (Steps downward: Noise, Soprano, Tenor, Bass)

        ; --- MASTER VOICE AUDIO PITCH SWEEP LOOP ---
LA815:  ldx     #$80                            ; Set starting audio frequency byte to $80 (turns the voice ON)
LA817:  txa                                     ; Move frequency byte value to Accumulator
        sta     VIC_REG_AUDIO_BASS,y            ; Write pitch data to the targeted VIC audio register ($900A + Y)
        
        tya
        pha                             ; Preserve active voice register index onto the stack
        ldy     #$FA                            ; Load specific timing scalar parameter into Y
        jsr     LAAD5                           ; Call inner loop of UTIL_HARDWARE_DELAY (creates an audible sliding chirp)
        pla
        tay                             ; Restore active voice register index back from the stack
        
        inx                             ; Increment audio tone frequency bit pattern step
        cpx     #$01                            ; Has frequency wrapped around from $FF back down past 0 to $01?
        bne     LA817                           ; Continue tone generation sweep until the individual channel phase finishes
        dey                             ; Shift left to target the next analog sound voice register
        bpl     LA815                           ; Repeat pitch sweeps across all 4 internal audio generators

        ; --- PHASE 2: DISPLAY MATRIX STRESS PREPARATION ---
        lda     #$00
        sta     REG_AUDIO_STATUS_FLG            ; Clear the system audio state tracking flag (0 = background operations active)
        jsr     LA8E7                           ; Call screen setup utility to prepare screen/color RAM pointers

        ; --- FILL SCREEN RAM AND COLOR RAM WITH GRID CHARACTERS ---
        ldx     #$02                            ; Set outer vertical rows block counter to 2
LA836:  ldy     #$FF                            ; Set horizontal character counter to 255
LA838:  lda     #$A0                            ; Load character code $A0 (Graphics symbol block / space variant)
        sta     (ZP_PTR_SCREEN_RAM_LO),y        ; Write graphic block code directly to Screen RAM via indirect pointer
        lda     #$06                            ; Load color code 6 (Blue text)
        sta     (ZP_PTR_COLOR_RAM_LO),y         ; Write color code directly to matching Color RAM position
        dey                             ; Decrement column position counter by 2 to jump alternate cells
        dey                             ; ...
        cpy     #$FF                            ; Have we finished filling this block?
        bne     LA838                           ; Loop back if more screen coordinates remain
        
        inc     ZP_PTR_SCREEN_RAM_HI            ; Advance screen RAM pointer high byte to next 256-byte page boundary
        inc     ZP_PTR_COLOR_RAM_HI             ; Advance color RAM pointer high byte to next 256-byte page boundary
        dex                             ; Decrement row block loop tracker
        bne     LA836                           ; Continue loop until the dual-page fill routine completes

        ; --- HOLD DISPLAY FOR AUDIT PUSH 1 ---
        ldx     #$07                            ; Set frame loop counter to 7
LA84F:  jsr     UTIL_HARDWARE_DELAY             ; Freeze execution briefly to show the geometric grid on screen
        dex
        bpl     LA84F                           ; Loop until display pause interval completes
        
        jsr     LA8E7                           ; Re-initialize base screen/color memory register tracking pointers
        lda     #$00
        sta     ZP_AUDIO_FREQ_LO                ; Clear low byte of audio frequency array variable
        sta     ZP_AUDIO_FREQ_HI                ; Clear high byte of audio frequency array variable

        ; --- DYNAMIC FREQUENCY MODULATION GRID RENDER LOOP ---
LA85E:  jsr     LA8D3                           ; Call video generator helper to update specific screen bytes
        lda     ZP_AUDIO_FREQ_HI                ; Read high byte tracking variable
        cmp     #$10                            ; Check if frequency sweep boundary upper ceiling is reached
        beq     LA86F                           ; Branch out if frequency limits match expectations
        clc
        ror     a                               ; Shift bits rightward to test edge parity state
        bcs     LA85E                           ; Branch back to cycle again if bit state matches condition
        inc     ZP_AUDIO_FREQ_LO                ; Increment audio frequency low byte tracking parameter
        bne     LA85E                           ; Loop until low byte rolls over

        ; --- ADVANCE AND DOUBLE BUFFER THE CHARACTER WRITES ---
LA86F:  inc     ZP_PTR_SCREEN_RAM_HI            ; Shift active screen pointer high byte up by 1 page
        inc     ZP_PTR_COLOR_RAM_HI             ; Shift active color pointer high byte up by 1 page
        ldy     #$00                            ; Initialize pointer offset index to 0
LA875:  lda     #$A0                            ; Load character matrix code $A0
        sta     (ZP_PTR_SCREEN_RAM_LO),y        ; Write code directly to active screen address page
        lda     ZP_AUDIO_FREQ_LO                ; Fetch current low byte frequency tracking state
        sta     (ZP_PTR_COLOR_RAM_LO),y         ; Overwrite color parameter data dynamically using frequency value
        iny                             ; Increment target index
        cpy     #$02                            ; Have we updated 2 structural bytes?
        bne     LA875                           ; Repeat if cells remain

        lda     #$00
        sta     ZP_AUDIO_FREQ_LO                ; Reset audio low byte frequency state back to $00
        lda     #$08
        sta     ZP_AUDIO_FREQ_HI                ; Set high byte parameter index reference value to 8

        ; --- PHASE 3: INTERLEAVED DELAY AND SCREEN MODULATION ---
LA88A:  jsr     LA8D3                           ; Call text grid update module
        lda     ZP_AUDIO_FREQ_HI                ; Fetch current high frequency state byte
        cmp     #$18                            ; Check if sweep limit boundary index matches 24
        beq     LA89B                           ; Break out if limits match
        clc
        ror     a                               ; Rotate bits to alter timing profiles
        bcs     LA88A                           ; Loop if condition is met
        inc     ZP_AUDIO_FREQ_LO                ; Advance tracking value
        bne     LA88A                           ; Continue looping sequence

        ; --- HOLD DISPLAY FOR AUDIT PUSH 2 ---
LA89B:  ldx     #$07                            ; Set loop counter to 7
LA89D:  jsr     UTIL_HARDWARE_DELAY             ; Freeze execution to display current grid updates
        dex
        bpl     LA89D                           ; Continue delay loop
        
        ; --- BORDER FLASH AND VIDEO FEEDBACK EXERCISE ---
        lda     #$18                            ; Load color bitmask for background/border matrix configuration
        sta     VIC_REG_BG_BORDER_CLR           ; Write to VIC register ($900F) to flip screen background elements
        ldx     #$07                            ; Re-initialize delay counter
LA8AA:  jsr     UTIL_HARDWARE_DELAY             ; Hold color state visually on display monitor
        dex
        bpl     LA8AA                           ; Continue delay loop
        
        lda     #$1B                            ; Load alternative baseline screen/border background colors
        sta     VIC_REG_BG_BORDER_CLR           ; Restore primary display screen color values
        jsr     LA8E7                           ; Re-initialize base screen/color structural tracking pointers

        ; --- FINAL ENVIRONMENT CANVAS WIPE ---
        ldy     #$00                            ; Set index counter to 0
LA8BA:  lda     #$06                            ; Load color code 6 (Blue foreground text)
        sta     COLOR_RAM_PAGE_1,y              ; Flood first page of Color RAM ($9600)
        sta     COLOR_RAM_PAGE_2,y              ; Flood second page of Color RAM ($9700)
        lda     #$20                            ; Load character code $20 (The standard blank space character)
        sta     VIDEO_RAM_PAGE_1,x              ; Clear first page of Screen RAM ($1E00) (Note: X index is persistent here)
        sta     VIDEO_RAM_PAGE_2,x              ; Clear second page of Screen RAM ($1F00)
        iny
        bne     LA8BA                           ; Continue wiping memory blocks until Y index rolls over back to 00
        
        lda     #$FF
        sta     REG_AUDIO_STATUS_FLG            ; Set system audio tracking flag to $FF (Signals audio phase complete/muted)
        rts                                     ; Return from sound test routine

LA8D3:  
        ; --- LOCAL UTILITY: GRAPHIC STRIP / PATTERN GENERATOR ---
        ; Draws custom data columns by stepping downwards line-by-line.
        ldy     ZP_AUDIO_FREQ_HI                ; Fetch current high tracking value to use as our vertical index offset
        
LA8D5:  lda     #$A0                            ; Load character code $A0 (The solid graphics block symbol)
        sta     (ZP_PTR_SCREEN_RAM_LO),y        ; Write block symbol directly to the screen memory address cell
        lda     ZP_AUDIO_FREQ_LO                ; Fetch current low tracking value (stores active pitch data metrics)
        sta     (ZP_PTR_COLOR_RAM_LO),y         ; Inject directly into corresponding Color RAM to dynamically shift character patterns
        
        ; --- THE 22-COLUMN VERTICAL ROW JUMP ---
        tya                                     ; Move current column index offset position to Accumulator
        clc                                     ; Clear Carry flag before addition
        adc     #$16                            ; Add decimal 22 (The physical character width of one VIC-20 screen row)
        tay                                     ; Move updated offset value back to Y to target the same column on the next line down
        bcc     LA8D5                           ; Loop back to paint block symbol on next row until page boundary limits overflow ($FF)
        
        inc     ZP_AUDIO_FREQ_HI                ; Increment frequency high tracking index parameter
        rts                                     ; Return from dynamic strip printing loop

LA8E7:  
        ; --- LOCAL UTILITY: DISPLAY MATRIX RE-INITIALIZATION ENGINE ---
        ; Forces both Screen RAM and Color RAM pointers back to pristine starting positions.
        lda     #$00
        sta     ZP_PTR_SCREEN_RAM_LO            ; Clear low byte of Screen RAM tracking register pointer
        lda     #$1E
        sta     ZP_PTR_SCREEN_RAM_HI            ; Set high byte to $1E (Base address of default VIC-20 Screen RAM: $1E00)
        
        lda     #$00
        sta     ZP_PTR_COLOR_RAM_LO             ; Clear low byte of Color RAM tracking register pointer
        lda     #$96
        sta     ZP_PTR_COLOR_RAM_HI             ; Set high byte to $96 (Base address of default VIC-20 Color RAM: $9600)
        
        ldx     #$02                            ; Set outer block loop page counter to 2 (to cover 512 bytes of RAM)
        
LA8F9:  ldy     #$00                            ; Initialize inner page byte index tracker to 0
        
LA8FB:  lda     #$20                            ; Load character code $20 (The standard blank space character)
        sta     (ZP_PTR_SCREEN_RAM_LO),y        ; Overwrite active screen coordinate cell to clear any stray glyph data
        lda     #$01                            ; Load color code 1 (White foreground text formatting color)
        sta     (ZP_PTR_COLOR_RAM_LO),y         ; Overwrite active color matrix cell with white text properties
        iny                                     ; Step forward to next byte index position
        bne     LA8FB                           ; Loop across full 256-byte page boundaries until complete
        
        inc     ZP_PTR_SCREEN_RAM_HI            ; Advance Screen RAM pointer up to cover secondary memory page ($1F00)
        inc     ZP_PTR_COLOR_RAM_HI             ; Advance Color RAM pointer up to cover secondary memory page ($9700)
        dex                                     ; Decrement remaining blocks tracking loop counter
        bne     LA8F9                           ; Continue block clear passes until all target ranges are wiped clean
        
        ; --- POINTER MATRIX REBALANCING ---
        ; Decrement high bytes twice to shift pointers backwards by 512 bytes, 
        ; restoring them precisely to the core matrix origin addresses ($1E00 / $9600).
        dec     ZP_PTR_SCREEN_RAM_HI            
        dec     ZP_PTR_SCREEN_RAM_HI
        dec     ZP_PTR_COLOR_RAM_HI
        dec     ZP_PTR_COLOR_RAM_HI
        rts                                     ; Return from layout calibration subroutine

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
        ; --- PHASE 1: CLEAR ALL 16 REGISTERS ON VIA1 ---
        ldx     #$0F                            ; Initialize X register with 15 (covers registers 0 to 15)
        lda     #$00                            ; Clear Accumulator to zero out the registers
LA9CB:  sta     VIA1_PORT_B,x                   ; Write $00 to VIA1 register (Base Address + X offset)
        dex                                     ; Decrement the register index tracking pointer
        bpl     LA9CB                           ; Loop backward until X rolls past zero to $FF (Negative)

        ; --- PHASE 2: DISABLE ALL INTERRUPTS ON VIA1 ---
        lda     #$7F                            ; Binary %01111111 (Clear bits 0-6 to disable all interrupt types)
        sta     VIA1_INT_ENABLE                 ; Update VIA1 Interrupt Enable Register ($911E)

        ; --- PHASE 3: CLEAR ALL 16 REGISTERS ON VIA2 ---
        ldx     #$0F                            ; Re-initialize index tracker back to 15
        lda     #$00                            ; Ensure Accumulator remains completely cleared
LA9DA:  sta     VIA2_PORT_B,x                   ; Write $00 to VIA2 register (Base Address + X offset)
        dex                                     ; Decrement the register index tracking pointer
        bpl     LA9DA                           ; Loop backward until all 16 registers are zeroed out

        ; --- PHASE 4: THE VIA2 INTERRUPT ENABLING BUG ---
        ; The destination address should be 'VIA2_INT_ENABLE' ($912E).
        ; Writing to 'VIA1_INT_ENABLE' ($911E) a second time leaves VIA2's 
        ; interrupts in whatever unpredictable state the prior test suite left them in.
        lda     #$7F                            ; Load bitmask to clear interrupts
        sta     VIA1_INT_ENABLE                 ; Typo: Re-disables VIA1 instead of disabling VIA2!

        rts                                     ; Return from peripheral wipe subroutine

INIT_HOOK_SYSTEM_IRQ:
        ; --- RESTORE RUNTIME IRQ VECTOR ---
        sei                                     ; Disable interrupts while rewriting the system vector
        lda     #<IRQ_HANDLER                   ; Load low byte of the runtime system IRQ handler
        sta     RAM_IRQ_VECTOR_LO               ; Direct KERNAL vector to the new handler ($0314)
        lda     #>IRQ_HANDLER                   ; Load high byte of the runtime system IRQ handler
        sta     RAM_IRQ_VECTOR_HI               ; Direct KERNAL vector to the new handler ($0315)

        ; --- CONFIGURE VIA2 TIMER 1 FOR CONTINUOUS INTERRUPTS ---
        lda     #$40                            ; Binary %01000000: Set Timer 1 to continuous interrupts (Bit 6)
        sta     VIA2_AUX_CTRL                   ; Update VIA2 Auxiliary Control Register ($912B)
        lda     #$C0                            ; Binary %11000000: Enable Timer 1 Interrupt (Set Bit 7 Enable + Bit 6 T1)
        sta     VIA2_INT_ENABLE                 ; Update VIA2 Interrupt Enable Register ($912E)

        ; --- START HEARTBEAT CLOCK COUNTDOWN ---
        ; Sets a latched 16-bit countdown value of $4289 (17,033 clock cycles)
        ; At 1.02 MHz (PAL) / 1.01 MHz (NTSC), this generates an IRQ roughly every 1/60th of a second.
        lda     #$89
        sta     VIA2_T1_CTR_LO                  ; Write low byte of latch/counter ($9124)
        lda     #$42    
        sta     VIA2_T1_CTR_HI                  ; Write high byte of counter ($9125) and active-start the timer

        cli                                     ; Safely re-enable interrupts to start the heartbeat clock
        rts                                     ; Return from setup block

IRQ_HANDLER:
        ; --- MASTER SYSTEM RASTER / SIGNAL POLLING LOOP ---
        lda     $9C00                           ; Check an I/O or state tracking register address
        and     #$01                            ; Isolate bit 0
        bne     IRQ_HANDLER                     ; Spin-wait here if bit 0 is high (awaits custom sync condition)

        ; --- VISUAL FLASH TIMER / PULSE ACCUMULATOR ---
        dec     $0410                           ; Decrement the flash/tick timer variable at $0410
        bpl     LAA23                           ; If the counter is still positive (>= 0), branch past flash toggle

        ; --- TOGGLE BACKGROUND/BORDER FLIPPERS ---
        lda     #$08
        sta     $0410                           ; Reset flash tick counter back to 8 frames
        lda     #$C0                            ; Load bitmask value
        eor     $0411                           ; XOR with current state tracking register at $0411 to flip bits
        sta     $9800                           ; Write updated value directly to video/system memory location $9800
        sta     $0411                           ; Store updated tracking bit back into $0411

        ; --- TICK TIME ENGINE ---
LAA23:  jsr     INIT_STEP_BCD_CLOCK             ; Advance real-time clock array bytes using 6502 decimal mode (`sed`)
        jsr     INIT_REFRESH_CLOCK_BANNER       ; Redraw the flashing clock text data dynamically onto the VIC screen
        
        ; --- ACKNOWLEDGE HARDWARE TIMERS ---
        lda     VIA2_INT_FLAGS                  ; Read the current VIA2 Interrupt Flags
        sta     VIA2_INT_FLAGS                  ; Write 1s back to clear Timer 1 interrupt latch, resetting the hardware pin

        ; --- CLEAN STACK RESTORATION ---

        pla                                     ; Pull saved Y register value from the Stack

        tay                                     ; Restore original Index Register Y
        pla                                     ; Pull saved X register value from the Stack
        tax                                     ; Restore original Index Register X
        pla                                     ; Pull saved Accumulator value from the Stack
        rti                                     ; Return From Interrupt (Restores Processor Flags and Program Counter)

INIT_STEP_BCD_CLOCK:
        sed                                     ; Set Decimal Mode (forces ADC/SBC to treat hex as base-10 math)
        dec     $0418                           ; Decrement the fractional jiffy sub-second counter at $0418
        bpl     LAA44                           ; If counter is still positive (>= 0), branch down to skip ticking a full second

        lda     #$5F                            ; Reset fractional jiffy counter back to 95 ticks ($5F)
        sta     $0418                           ; (96 ticks at 60Hz creates a rough 1.6-second loop, or a custom timing step)
        lda     $0417                           ; Load the base tick value to add into the array accumulator
        
        ; LAA44 defines an offset pointing precisely inside the next instruction's opcode byte.
        ; If the 'bpl' above branches here, it lands on 'bit $A9' (using $A9 as an absolute address).
        ; If execution falls through instead, it reads 'lda $0417' then 'lda #$00' (since $A9 is the opcode for LDA #imm).
        ; This skips the 'lda #$00' initialization without spending cycles on a traditional 'jmp' or 'bne'.
LAA44           := * + 1                        ; Assembler directive forcing label to point at the byte AFTER the opcode
        bit     $01A9                           ; Triggers a BIT operation if branched to; hides an LDA #imm if falling through
        lda     #$00                            ; Clear accumulator to 0 (means 0 seconds added if sub-second counter hasn't rolled)

        ldx     #$00                            ; Initialize X register
        ldy     #$04                            ; Initialize loop register Y to point to the end of the time array (Seconds byte)

        ; --- BCD TIME ARRAY TICK & CASCADE CARRY LOOP ---
        ; Handles cascading carries across 5 array bytes: [Years, Days, Hours, Minutes, Seconds]
LAA4A:  clc                                     ; Clear Carry flag before addition
        adc     $0412,y                         ; Add current time value to the accumulator
        sta     $0412,y                         ; Store updated BCD value back into the array slot
        cmp     CLOCK_BCD_CARRY_THRESHOLDS,y    ; Check if value matches or exceeds maximum threshold for this slot
        bcc     LAA61                           ; If accumulator is less than threshold, time update is cleanly complete
        sbc     CLOCK_BCD_CARRY_THRESHOLDS,y    ; Subtract threshold limit to manually handle the BCD wrap-around
        sta     $0412,y                         ; Save the wrapped value (usually resets to 00)
        lda     #$01                            ; Put a carry value of 1 into Accumulator for the next array slot up
        dey                                     ; Move pointer leftward to previous array slot (e.g. seconds -> minutes)
        bpl     LAA4A                           ; Repeat loop to ripple-carry the time value upward
LAA61:  cld                                     ; Clear Decimal Mode (restores standard hexadecimal CPU math)
        rts                                     ; Return from clock tick subroutine

CLOCK_BCD_CARRY_THRESHOLDS:
        ; Max limits allowed per time index slot:
        ; Years Max=$99, Days Max=24 ($24), Hours Max=60 ($60), Minutes Max=60 ($60), Seconds Max=60 ($60)
        .byte   $99,$24,$60,$60,$60

INIT_REFRESH_CLOCK_BANNER:
        lda     REG_AUDIO_STATUS_FLG            ; Check if system audio generation is currently busy
        bne     LAAA6                           ; If audio flag is active, abort screen printing to save video bus cycles
        lda     VIDEO_RAM_PAGE_1                ; Check current active video memory page status register
LAA70:  cmp     #$FF                            ; Check if display page state is invalid or unready
        beq     LAAA6                           ; Abort if page is missing/blank

        ; --- PHASE 1: DRAW STATIC TEXT FRAME TEMPLATE ---
        ldx     #$15                            ; Set counter for 22 characters (length of the banner row)
        ldy     #$02                            ; Text color code (Red = 2)
LAA78:  lda     CLOCK_BANNER_TEXT_TEMPLATE,x    ; Load raw text character from your master layout array
        sta     $1FE4,x                         ; Inject character directly into screen memory row ($1FE4)
        lda     #$02                    
        sta     $97E4,x                         ; Inject color code 2 directly into corresponding Color RAM ($97E4)
        dex                                     ; Decrement index counter
        bpl     LAA78                           ; Loop until full banner framework template is rendered

        ; --- PHASE 2: CONVERT PACKED BCD BYTES TO DISPLAY CHARACTERS ---
        ldx     #$03                            ; Target last 4 slots of array (Days, Hours, Minutes, Seconds)
        stx     $0419                           ; Store loop pointer index at zero-page location $0419
LAA8B:  ldx     $0419                           ; Fetch current array index
        lda     $0412,x                         ; Load packed BCD byte from time storage array (e.g., $59)
        jsr     UTIL_SPLIT_BYTE_TO_SCREEN_CODES ; Call utility to split byte: splits high/low nibble into separate ASCII values
        pha                                     ; Push Low digit character code onto stack for safekeeping
        lda     CLOCK_BANNER_COLUMN_OFFSETS,x   ; Look up targeted screen column column offset for this time unit
        tax                                     ; Transfer calculated screen layout index directly to X register
        tya                                     ; Transfer High digit character value (returned in Y) to Accumulator
        sta     $1FE4,x                         ; Write High numerical digit directly onto the screen
        pla                                     ; Pull Low digit character code back off stack
        sta     $1FE5,x                         ; Write Low numerical digit adjacent to High digit
        dec     $0419                           ; Decrement the active time unit array index
        bpl     LAA8B                           ; Loop until all clock metrics are overlaid into banner row
LAAA6:  rts                                     ; Return from banner refresh routine

CLOCK_BANNER_COLUMN_OFFSETS:
        .byte   $01,$0E,$11,$14
CLOCK_BANNER_TEXT_TEMPLATE:
        .byte   $A0,$A0,$A0,$A0,$84,$81,$99,$93
        .byte   $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
        .byte   $BA,$00,$00,$BA,$A0,$A0

UTIL_SPLIT_BYTE_TO_SCREEN_CODES:
        ; --- HIGH NIBBLE EXTRACTION (TENS DIGIT) ---
        pha                                     ; Push the original packed BCD byte (e.g., $59) onto the stack
        lsr     a                               ; Shift right 4 times to isolate the upper 4 bits (high nibble)
        lsr     a                               ; ...
        lsr     a                               ; ...
        lsr     a                               ; Accumulator now holds the raw numeric digit (e.g., $05)
        ora     #$B0                            ; Convert raw digit to VIC-20 reverse-video screen code numbers ($B0-$B9)
        tay                                     ; Transfer the High digit character screen code to the Y register
        
        ; --- LOW NIBBLE EXTRACTION (ONES DIGIT) ---
        pla                                     ; Pull the original packed BCD byte back off the stack
        and     #$04                            ; NOTE: This bitmask looks like an assembly typo in the original ROM!
                                                ; Standard nibble isolation requires 'and #$0F'. 
                                                ; Masking with '#$04' will break digit decoding for values other than 4!
        ora     #$B0                            ; Convert the resulting value to a reverse-video screen code number
        rts                                     ; Return (High digit screen code in Y, Low digit in A)

UTIL_WRITE_INDIRECT_CHAR:
        ; --- INDIRECT STORAGE ACCELERATOR ---
        sta     (ZP_PTR_INDIRECT_A_LO),y ; Write Accumulator to the address stored at zero-page pointer plus Y index
        ; NOTE: There is no 'rts' here! Execution falls directly into the delay routine below.

UTIL_HARDWARE_DELAY:
        ; --- PRECISION CYCLE DELAY LOOP ---
        lda     #$00                            ; Clear the Accumulator accumulator loop counter
        tay                                     ; Clear the Y index loop counter
        clc                                     ; Clear the Carry flag to ensure 'adc' does not add phantom values
        
        ; Inner loop: Increments A 256 times per Y iteration until it rolls over to 00
LAAD5:  adc     #$01                            ; Add 1 to Accumulator (using ADC without SEC/CLC causes safe hex addition here)
        bne     LAAD5                           ; Loop until Accumulator hits $00 (Takes 256 iterations)
        
        ; Outer loop: Increments Y 256 times until it rolls over to 00
        iny                                     ; Increment outer loop tracking index
        bne     LAAD5                           ; Jump back to execute another 256 inner loop iterations if Y != 0
        rts                                     ; Delay complete. Return to caller. (Total delay = ~196,000 CPU cycles)

UTIL_VALIDATE_HARDWARE_TIMING:
        ; --- PHASE 1: INITIALISE TIMING STATE STORAGE ---
        lda     #$00
        sta     ZP_TIME_ELAPSED_HI              ; Clear high byte of the actual elapsed time counter
        sta     ZP_TIME_ELAPSED_LO              ; Clear low byte of the actual elapsed time counter
        sta     ZP_INT_TRIGGERED_FLG            ; Clear interrupt-fired notification flag (0 = has not fired)
        lda     #$FF
        sta     ZP_INT_EXPECTED_FLG             ; Set expected-interrupt guard flag ($FF = arming the handler)

        ; --- PHASE 2: LOOKUP TARGET VIA REGISTER VIA VECTOR TABLES ---
        ldx     ZP_STRING_SELECT_IDX            ; Fetch active test index (0-9 for edge/timer tests)
        lda     VIC_TABLE_REG_OFFSETS,x         ; Look up target register offset for this test (e.g. PCR, IER)
        clc
        adc     ZP_VIC_REG_PTR_LO               ; Add to low byte of base VIA pointer ($9110 or $9120)
        sta     ZP_PTR_INDIRECT_A_LO            ; Store calculated target register address low byte
        lda     #$00
        adc     ZP_VIC_REG_PTR_HI               ; Propagate 16-bit carry to base VIA pointer high byte
        sta     ZP_PTR_INDIRECT_A_HI            ; Store calculated target register address high byte

        ; --- PHASE 3: STIMULATE HARDWARE AND WAIT FOR EVENT ---
        lda     VIC_TABLE_NTSC_GEOMETRY,x       ; Look up hardware stimulation bitmask pattern for this test
        ldy     #$00
        jsr     UTIL_WRITE_INDIRECT_CHAR        ; Write bitmask to the VIA register via indirect pointer (Triggers Edge/Timer)
        
        ; --- TIMING TRAP WINDOW ---
        lda     ZP_INT_TRIGGERED_FLG            ; Read the interrupt tracking register updated by the IRQ/NMI handler
        bne     LAB0B                           ; If non-zero, interrupt fired successfully. Advance to evaluation.
LAB05:  jsr     UTIL_FLASH_ERROR_HANDLER        ; Fail Route: Interrupt never tripped at all (stuck line / dead timer)
        jmp     LAB05                           ; Permanent lockup loop on catastrophic hardware freeze

        ; --- PHASE 4: 16-BIT REAL-TIME VARIANCE CALCULATION ---
LAB0B:  ldy     #$00
        sty     ZP_INT_EXPECTED_FLG             ; Disarm interrupt handler (0 = unexpected interrupt guard active)
        ldy     ZP_STRING_SELECT_IDX            ; Refresh active test ID index into Y
        stx     ZP_TEMP_STRING_LEN              ; Back up X index register into temporary variable
        
        ; Compute Absolute Variance: (Expected Cycles) - (Actual Elapsed Cycles)
        lda     VIC_TABLE_ROW_SPACERS_A,y       ; Load Low Byte of targeted expected timing value from table
        sec
        sbc     ZP_TIME_ELAPSED_LO              ; Subtract Low Byte of actual elapsed time captured by handler
        sta     ZP_TEMP_CHAR_DATA               ; Store intermediate result in temporary byte
        lda     VIC_TABLE_ROW_SPACERS_B,y       ; Load High Byte of targeted expected timing value from table
        sbc     ZP_TIME_ELAPSED_HI              ; Subtract High Byte of actual elapsed time captured by handler
        bpl     LAB32                           ; If result is positive (>=0), expected time was greater. Skip inversion.

        ; --- 16-BIT NEGATIVE VALUE INVERSION (2'S COMPLEMENT TO ABSOLUTE VALUE) ---
        eor     #$FF                            ; Invert High Byte bits
        tax                                     ; Keep inverted High Byte in X register
        lda     ZP_TEMP_CHAR_DATA               ; Reload Low Byte result
        eor     #$FF                            ; Invert Low Byte bits
        clc
        adc     #$01                            ; Add 1 to finalize absolute 2's complement conversion
        sta     ZP_TEMP_CHAR_DATA               ; Store final absolute low byte delta value
        bcc     LAB31                           ; If no carry, skip incrementing high byte
        inx                                     ; Increment inverted High Byte to handle carry
LAB31:  txa                                     ; Move absolute high byte delta value to Accumulator
LAB32:  bne     LAB3F                           ; Fail Route: If High Byte delta != 0, timing variance is way too large

        ; --- TIMING THRESHOLD MARGIN CHECK ---
        lda     ZP_TEMP_CHAR_DATA               ; Load absolute Low Byte delta value
        and     #$F8                            ; Mask out bits 0-2 (Checks if variance is >= 8 cycles)
        bne     LAB3F                           ; Fail Route: Variance is 8 clock cycles or greater. Reject.
        ldx     ZP_TEMP_STRING_LEN              ; Restore original text string offset index to X register
        jmp     UTIL_PRINT_PASS_STATUS          ; Success Route: Timing is precision accurate! Print "OK" and exit.

        ; --- TIMING VARIANCE EXCEEDED ---
LAB3F:  ldx     ZP_TEMP_STRING_LEN              ; Restore text string index for the UI handler
        jsr     UTIL_FLASH_ERROR_HANDLER        ; Trigger visual screen flash error indicator
        jmp     UTIL_VALIDATE_HARDWARE_TIMING   ; Retry/loop test continuously so tech can inspect with scope

        rts                                     ; Unreachable safety return statement

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
        lda     ZP_INT_EXPECTED_FLG             ; Check expected interrupt flag condition variable
        beq     ERR_HANDLER_CATASTROPHIC_IRQ    ; If 0, an interrupt fired when it shouldn't have (Catastrophic Fault)
        sta     ZP_INT_TRIGGERED_FLG            ; Log/mirror the triggered interrupt status byte into storage
        
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
        sty     ZP_TIME_ELAPSED_HI              ; Back up Y to a temporary zero-page tracking variable for debugging
        pla                                     ; Pull saved X register value from the Stack
        tax                                     ; Restore original Index Register X
        pla                                     ; Pull saved Accumulator value from the Stack
        sta     ZP_TIME_ELAPSED_LO              ; Back up A to a temporary zero-page tracking variable
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
        ; --- REVERSE VIDEO CHARACTER ENTRY POINT ---
        ldy     #$80                            ; Bit 7 high ($80) acts as the reverse video flag on Commodore platforms
        sty     ZP_SCREEN_BUF_POS               ; Store flag in zero page to mask onto incoming characters
        jsr     UTIL_PRINT_CHAR                 ; Call standard print engine to draw the character
        txa                                     ; Transfer X register to Accumulator (balancing state or setting up argument)

UTIL_PRINT_CHAR:
        ; --- STANDARD CHARACTER ENTRY POINT ---
        sta     ZP_TEMP_CHAR_DATA               ; Back up raw character value to a zero-page temporary variable
        and     #$7F                            ; Mask out bit 7 to isolate the core character data
        cmp     #$0D                            ; Is this character an ASCII Carriage Return (New Line)?
        beq     UTIL_CLEAR_SCREEN_CANVAS        ; If it's a Carriage Return, jump directly down to shift the screen canvas

        stx     ZP_TEMP_STRING_LEN              ; Back up active text pointer register X into temporary variable
        ldx     ZP_PORT_LINE_OFFSET             ; Fetch the current horizontal cursor column index offset
        and     #$3F                            ; Mask with %00111111 to convert ASCII to Commodore Screen RAM Matrix Codes
        ora     ZP_SCREEN_BUF_POS               ; Merge character code with active reverse-video bitmask status flag
        sta     $1FB8,x                         ; Inject character directly into screen memory row offset $1FB8

        inx                                     ; Advance cursor horizontally to next character column position
        stx     ZP_PORT_LINE_OFFSET             ; Save updated cursor tracking coordinate position
        bne     LAC02                           ; Unconditional branch skip past canvas logic (cursor offset never hits 0)

UTIL_CLEAR_SCREEN_CANVAS:
        ; --- SCREEN TEXT ROW SHIFTING / SCROLL ENGINE ---
        stx     ZP_TEMP_STRING_LEN              ; Back up current string length index tracking register
        sty     ZP_SCREEN_SCROLL_FLG            ; Back up current Y pointer register context state flag
        ldx     #$00                            ; Initialize vertical screen row counter loop to index 0

LABD0:  ; --- ROW BLITTING LOOP (COPIES CHARACTER ROWS UPWARD) ---
        lda     SCR_ROW_ADDR_LO_BASE,x          ; Load low byte destination address of current screen row
        sta     $00                             ; Inject into zero page indirect destination pointer low slot ($0000)
        lda     SCR_ROW_ADDR_HI_BASE,x          ; Load high byte destination address of current screen row
        sta     $01                             ; Inject into zero page indirect destination pointer high slot ($0001)
        
        lda     SCR_ROW_ADDR_LO_OFFSETS,x       ; Load low byte source address of the row directly underneath it
        sta     ZP_PTR_INDIRECT_A_LO            ; Inject into zero page indirect source pointer low slot
        lda     SCR_ROW_ADDR_HI_OFFSETS,x       ; Load high byte source address of the row directly underneath it
        sta     ZP_PTR_INDIRECT_A_HI            ; Inject into zero page indirect source pointer high slot
        
        ldy     #$15                            ; Set horizontal character column counter loop to 21 (22 columns total)
LABE6:  lda     (ZP_PTR_INDIRECT_A_LO),y        ; Read character from the source screen row underneath
        sta     ($00),y                         ; Write character directly onto current target row line (shifts text up)
        dey                                     ; Step leftward to previous column cell position
        bpl     LABE6                           ; Continue row copy operations until column index drops negative ($FF)

        inx                                     ; Advance row index down to next display line
        cpx     #$15                            ; Have we blitted through 21 lines? (Leaves bottom line clear)
        bcc     LABD0                           ; Continue shifting rows up until target boundary limit is completed

        ; --- WIPE THE MAIN DISPLAY ROW CANVAS LINE ---
        ldy     #$15                            ; Set loop counter for 22 character columns
        lda     #$20                            ; Load $20 (The standard Commodore Screen Code for a blank Space)
LABF6:  sta     (ZP_PTR_INDIRECT_A_LO),y        ; Overwrite target canvas row column cells with blank white spaces
        dey                                     ; Step leftward to previous column coordinate
        bpl     LABF6                           ; Continue writing blank spaces until row line is fully wiped clean
        
        ; --- REBALANCING INTERNAL RUNTIME ENGINE STATE ---
        iny                                     ; Increment Y from $FF back up to $00
        sty     ZP_SCREEN_BUF_POS               ; Reset reverse-video bitmask flag state back to 0 (normal text)
        sty     ZP_PORT_LINE_OFFSET             ; Reset cursor position index tracker back to column 0 (home line left)
        ldy     ZP_SCREEN_SCROLL_FLG            ; Restore original Index Register Y state back from backup storage

LAC02:  ; --- BALANCED EXIT BLOCK ---
        ldx     #$00                            ; Manual alignment reset of X index register context
        lda     ZP_TEMP_CHAR_DATA               ; Restore original unparsed character byte back to Accumulator
        rts                                     ; Return from character print / scroll engine subroutine

UTIL_HEX_TO_ASCII:
        ; --- ACCUMULATOR CHARACTER PARSING ---
        pha                                     ; Push original packed byte to stack
        lsr     a                               ; Shift right 4 times to isolate the high nibble
        lsr     a                               ; ...
        lsr     a                               ; ...
        lsr     a                               ; ...
        jsr     LAC12                           ; Call translation math to print the high nibble character
        pla                                     ; Retrieve original packed byte from stack
        and     #$0F                            ; Mask out high bits to isolate the low nibble

LAC12:  ; --- BINARY TO ASCII CORRECTION MATH ---
        clc                                     ; Clear carry flag before addition
        adc     #$F6                            ; Add correction offset for decimal digits 0-9
        bcc     LAC19                           ; If no carry, the value is a number (0-9). Skip letter shift.
        adc     #$06                            ; Apply secondary offset to shift value into hex letters (A-F)
LAC19:  adc     #$3A                            ; Add baseline character value to finalize standard ASCII range
        
        ; --- THE UNCONDITIONAL SHORT-CIRCUIT ---
        bne     UTIL_PRINT_CHAR                 ; Branch if result != 0. Since ASCII codes 0-9 and A-F are never zero, 
                                                ; this branch ALWAYS triggers, routing directly to the print engine.

        ; =========================================================================
        ; --- ORPHANED COMPLIATION GHOST ZONE (DEAD ROM CODE BUG) ---
        ; These instructions are permanently trapped behind the 'bne' short-circuit.
        ; They physically occupy bytes inside the ROM but can never be executed.
        ; =========================================================================
        jsr     UTIL_HEX_TO_ASCII               ; Unreachable recursive call (would trigger stack overflow)
        txa                                     ; Unreachable register transfer
        jsr     UTIL_PRINT_CHAR                 ; Unreachable character print
        rts                                     ; Unreachable return

UTIL_FLASH_ERROR_HANDLER:
        ; --- ACTIVE AUDIO/VISUAL WARNING SUITE ---
        lda     ZP_DIAG_CHECKPOINT_CTR          ; Load the global stage tracking counter (determines error signature)
LAC27:  sei                                     ; Block all standard interrupts to take absolute control of timing
        ldx     ZP_MATRIX_SCAN_CTR              ; Load the current matrix flash execution loop index
        bne     LAC3E                           ; If index isn't zero, skip background color flip frame

        ; --- BORDER FLASHING GENERATOR ---
        ldx     #$FF                    
        stx     ZP_MATRIX_SCAN_CTR              ; Reset flash speed frame delay counter back to 255
        stx     ZP_PTR_INDIRECT_A_LO            ; Clear low tracking parameters
        eor     #$FF                            ; Invert the milestone signature bits to generate a contrasting pattern
        sta     $9800                           ; Write bitmask directly to memory address $9800 to flash background colors

        ldx     #$B1                            ; Load low byte of failure string index marker
        ldy     #$AC                            ; Load high byte of failure string index marker
        jsr     UTIL_PRINT_STRING               ; Print explicit hardware error code directly to monitor text rows

        ; --- SCREEN TEXT INVERSION ENGINE (XOR MASK CYCLE) ---
LAC3E:  jsr     UTIL_HARDWARE_DELAY             ; Pause execution briefly to make the flash rate human-readable
        ldx     #$15                            ; Set outer loop index to step through 22 rows of video screen memory
LAC43:  lda     SCR_ROW_ADDR_LO_BASE,x          ; Look up the target display line memory address low byte
        sta     $11                             ; Store in zero page indirect memory pointer low slot ($0011)
        lda     SCR_ROW_ADDR_HI_BASE,x          ; Look up the target display line memory address high byte
        sta     $12                             ; Store in zero page indirect memory pointer high slot ($0012)
        ldy     #$15                            ; Set inner loop index to cover 22 column characters per row
        
LAC4F:  lda     ($11),y                         ; Read the exact character currently rendered at this screen position
        eor     #$80                            ; Exclusive-OR bit 7 (instantly flips character between Normal and Reverse text)
        sta     ($11),y                         ; Write the inverted character directly back into active screen RAM
        dey                                     ; Step leftward to previous column character cell
        bpl     LAC4F                           ; Continue inverting characters across the row until Y drops negative ($FF)

        dex                                     ; Advance upward to the previous vertical screen row
        bpl     LAC43                           ; Continue row processing until the entire display grid is inverted
        rts                                     ; Return to active trap caller loop to cycle colors again

UTIL_PRINT_STRING:
        ; --- MAIN ZERO-TERMINATED STRING PRINT ENGINE ---
        stx     ZP_STRING_TEMP_LO               ; Store string pointer low byte into Zero Page
        sty     ZP_STRING_TEMP_HI               ; Store string pointer high byte into Zero Page
        ldy     #$00                            ; Initialize string character index pointer to 0

LAC62:  lda     (ZP_STRING_TEMP_LO),y           ; Read character from memory via indirect indexed addressing
        beq     UTIL_PRINT_STRING_EXIT          ; Success Route: If byte is $00 (Null Terminator), string is finished
        jsr     UTIL_PRINT_CHAR                 ; Call core character engine to render digit onto the screen row
        iny                                     ; Move index to the next sequential character byte
        bne     LAC62                           ; Loop back to process next character (safeguards against 256-byte overflow)
UTIL_PRINT_STRING_EXIT: 
        rts                                     ; Return from string print subroutine

UTIL_PRINT_STRING_INVERTED:
        ; --- REVERSE VIDEO STRING WRAPPER ---
        ; Forces all subsequent character updates into highlighted blocks
        lda     #$80                    
        sta     ZP_SCREEN_BUF_POS               ; Turn Reverse-Video Mode ON (Sets Bit 7 mask active)
        jsr     UTIL_PRINT_STRING               ; Call standard string routine to print the inverted data
        lda     #$00                            
        sta     ZP_SCREEN_BUF_POS               ; Turn Reverse-Video Mode OFF (Clears mask back to normal text)
        rts                                     ; Return from reverse wrapper

UTIL_PRINT_PASS_STATUS:
        ; --- SYSTEM SUCCESS INDICATOR DRIVER ---
        ldx     #$81                            ; Load low byte of the success text string address
        ldy     #$AC                            ; Load high byte of the success text string address ($AC81)
        jsr     UTIL_PRINT_STRING               ; Call main string engine to draw the confirmation status
        rts                                     ; Return to active test module loop

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
