MACRO insrc
        inc     apd_src
        bne     incsr1
        inc     apd_src+1
.incsr1
ENDMACRO

MACRO getbyte
        lda     (apd_src), Y
        insrc
ENDMACRO

MACRO putbyte
        sta     (apd_dest), y
        inc     apd_dest
        bne     putbyt
        inc     apd_dest+1
.putbyt
ENDMACRO

MACRO getbit
        asl     apd_bitbuffer
        bne     getbi1
        tax
        getbyte
        rol		a
        sta     apd_bitbuffer
        txa
.getbi1
ENDMACRO

MACRO getbitd
        asl     apd_bitbuffer
        bne     getbi2
        getbyte
        rol a
        sta     apd_bitbuffer
.getbi2
ENDMACRO

.exitdz rts
.dc64f  lda     #$80
        sta     apd_bitbuffer
        ldy     #0
        sty     apd_length+1
.copyby getbyte
        putbyte
.mainlo getbitd
        bcc     copyby
        sty     apd_offset+1
        getbitd
        lda     #1
        bcs     contie
.lenval getbit
        rol		a
        rol     apd_length+1
        getbit
        bcc     lenval
.contie adc     #0
        sta     apd_length
        beq     exitdz
        lda     (apd_src), y
        bpl     toffen
        insrc
        getbit
        rol     apd_offset+1
        getbit
        rol     apd_offset+1
        getbit
        rol     apd_offset+1
        getbit
        bcc     offend
        inc     apd_offset+1
        sbc     #$80
        jmp     offend
.toffen insrc
.offend sec
        sbc     apd_dest
        eor     #%11111111
        sta     apd_source
        lda     apd_offset+1
        sbc     apd_dest+1
        eor     #%11111111
        sta     apd_source+1
        lda     apd_length+1
        beq     skip
.loop1  lda     (apd_source), y
        sta     (apd_dest), y
        iny
        bne     loop1
        inc     apd_source+1
        inc     apd_dest+1
        dec     apd_length+1
        bne     loop1
.skip   ldx     apd_length
        beq     lopend
.loop2  lda     (apd_source), y
        sta     (apd_dest), y
        iny
        dex
        bne     loop2
        tya
        ldy     #0
        adc     apd_dest
        sta     apd_dest
        bcc     lopend
        inc     apd_dest+1
.lopend jmp     mainlo