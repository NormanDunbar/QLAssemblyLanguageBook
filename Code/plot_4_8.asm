*-------------------------------------------------------------------------------
* PLOT_4 and PLOT_8
*
* Mode 4 and mode 8 plot routines which give direct access to the screen memory.
* NOTE : Must call plot_init at least once before using PLOT_4 and PLOT_8 or 
* seriously unpredictable results will occur. Additionally, there are no check
* to ensure that x and v values are in range.
*
*    D1.W = x (across)
*    D2.W = y (down)
*    D3.W = colour (0 to 7)
*-------------------------------------------------------------------------------
* Copyringht Norman Dunbar, March 2000. 
*-------------------------------------------------------------------------------


*-------------------------------------------------------------------------------
* In D3 bit 2 is green and bit 1 is red, we don't need any other bits, so get
* rid of them now. Then shift the Green bit into bit 15 of D4 and the red into
* bit 7 of D3 ...
*-------------------------------------------------------------------------------
start       bra     plot_init       ; Call here (start + 4) to initialise things
            bra     plot_4          ; Call start + 4 to plot in mode 4
            bra     plot_8          ; Call start + 8 to plot in mode 8

plot_4      bsr.s   calc            ; Get A1 = screen address
            andi.w  #6,d3           ; D3 = 00000000 00000GR0 (showing all bits)
            lsl.w   #6,d3           ; D3 = 0000000G R0000000
            move.w  d3,d4           ; D4 = 0000000G R0000000
            lsl.w   #7,d4           ; D4 = GR000000 00000000
            or.w    d4,d3           ; D3 = GR00000G R0000000
            andi.w  #$8080,d3       ; D3 = G0000000 R0000000 (keep both bits 7)

*-------------------------------------------------------------------------------
* D3.W is now set to a colour mask for pixel 0. This is where we want to start.
* Now we need to build a mask to clear out pixel 0 as well. This is easy - use the
* value from the table above. Then we can start rotating them into the correct
* position as detailed above.
*-------------------------------------------------------------------------------
            move.w  #$7f7f,d2       ; AND mask = 10000000 10000000
            andi.w  #7,d1           ; (x AND 7) in d1
            ror.w   d1,d2           ; Build correct AND mask
            ror.w   d1,d3           ; Build correct OR mask (colour)
            and.w   d2,(a1)         ; AND out the changing pixel
            or.w    d3,(a1)         ; OR in the (new) colour
            moveq   #0,d0           ; No errors
            rts                     ; All done

*-------------------------------------------------------------------------------
* Calculate the screen address for the x and y values passed in D1 and D2.
* Trashes A1, D4 and D5.
* The routine plot_init must have been called to initialise the screen addresses
* and scan line widths BEFORE calling this routine.
*-------------------------------------------------------------------------------
calc        lea     scr_base,a1     ; Where we hold the screen base address
            move.l  (a1)+,d0        ; Fetch the screen base address
            move.w  (a1),d6         ; And the scan line size
            movea.l d0,a1           ; Get the screen base where we want it

*-------------------------------------------------------------------------------
* D1.W = x across value
* D2.W = y down value
* D3.W = ink colour required
* D6.W = scan line size
* A1.L = screen base address
*-------------------------------------------------------------------------------
            move.w  d2,d5           ; Copy y value (down)
            ext.l   d5              ; We get a long result next ...
            mulu    d6,d5           ; Multiply by scan_line size
            adda.l  d5,a1           ; A1 = correct scan line address

            move.w  d1,d4           ; Copy x value
            lsr.w   #2,d4           ; D4 = INT(x / 4)
            bclr    #0,d4           ; Make even = green byte in scan_line
            adda.w  d4,a1           ; A1 = correct screen word address
            rts                     ; Done

*-------------------------------------------------------------------------------
* This routine must be called once before using the above plot routines. It
* initialises the screen base address and scan line width from the channel
* definition block for SuperBasic channel #0.
*-------------------------------------------------------------------------------
plot_init   suba.l  a0,a0           ; Channel id for #0 is always 0
            lea     scr_base,a1     ; Parameter passed to extop routine
            lea     extop,a2        ; Actual routine to call
            moveq   #sd_extop,d0    ; Trap code
            moveq   #-1,d3          ; Timout
            trap    #3              ; Do it
            tst.l   d0              ; OK ?
            bne.s   done            ; No, bale out D1 = A1 = garbage

got_them    move.w  d1,-(a7)        ; Need to check qdos, save scan_line
            moveq   #mt_inf,d0      ; Trap to get qdos version (preseves A1)
            trap    #1              ; Get it (no errors)
            move.w  (a7)+,d1        ; Retrieve scan_line value
            andi.l  #$ff00ffff,d2   ; D2 = qdos, mask out the dot in "1.03" etc
            cmpi.l  #$31003034,d2   ; Test for "1?03" where ? = don't care
            bcs.s   too_old         ; Less than 1.03 is too old

save        move.w  d1,(a1)         ; Store the scan_line size

done        rts                     ; Finished

too_old     move.w  #128,d1         ; Must be 128 bytes 
            bra.s   save            ; Save D1 and exit

extop       move.l  $32(a0),(a1)+   ; Fetch the scan_line length & store it
            move.w  $64(a0),d1      ; Fetch the screen base - don't store it
            moveq   #0,d0           ; No errors
            rts                     ; done

*-------------------------------------------------------------------------------
* Set aside some storage space to hold the screen base and scan_line width. This
* saves having to calculate it every time we plot a single pixel.
*-------------------------------------------------------------------------------
scr_base    ds.l    1
scan_line   ds.w    1

plot_8      bsr.s   calc            ; Get A1 = screen address
            andi.w  #7,d3           ; D3 = 00000000 00000GRB
            lsl.w   #6,d3           ; D3 = 0000000G RB000000
            move.w  d3,d4           ; D4 = 0000000G RB000000
            lsl.w   #7,d4           ; D4 = GRB00000 00000000
            andi.w  #$8000,d4       ; D4 = G0000000 00000000
            andi.w  #$00C0,d3       ; D3 = 00000000 RB000000
            or.w    d4,d3           ; D3 = G000000G RB000000
            move.w  #$7f3f,d2       ; AND mask = 01111111 00111111
            andi.w  #6,d1           ; (x AND 6) in d1
            ror.w   d1,d2           ; Build correct AND mask
            ror.w   d1,d3           ; Build correct OR mask (colour)
            and.w   d2,(a1)         ; AND out the changing pixel
            or.w    d3,(a1)         ; OR in the (new) colour
            moveq   #0,d0           ; No errors
            rts                     ; All done

