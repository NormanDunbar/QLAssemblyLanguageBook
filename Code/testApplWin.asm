;Menu source code generated with EASYSOURCE  V3.03
; 1991/92  Albin Hessler Software
;*************************************************

;            ++++++++++++++++++++++++++++++++++++++++++++++
;IMPORTANT : +   ->   Fill in pointers to routines   <-   +
;            ++++++++++++++++++++++++++++++++++++++++++++++

;Menu  ->  menu  <-    2015 Apr 19 09:58:02

         section   MDATA
         xdef      menu

menu

worklen  equ    $00000140           ; working definition length
statlen  equ    $00000050           ; status area length


;Main window definition :
;======================== 

         dc.w  200                  ;default window x size
         dc.w  140                  ;               y size
         dc.w  6                    ;initial pointer x position 
         dc.w  5                    ;                y position 
         dc.b  $00                  ;MSbit clear to clear window
         dc.b  2                    ;shadow depth 
         dc.w  1                    ;border width 
         dc.w  0                    ;border colour
         dc.w  7                    ;paper colour 
         dc.w  0                    ;pointer to pointer sprite
; menu item attributes
         dc.w  0                    ;current item border width  
         dc.w  7                    ;             border colour 
; menu item unavailable:
         dc.w  7                    ;background colour
         dc.w  55                   ;text object ink colour 
         dc.w  0                    ;pointer to blob for pattern
         dc.w  0                    ;pointer to pattern for blob
; menu item available  :
         dc.w  7                    ;background colour
         dc.w  0                    ;text object ink colour 
         dc.w  0                    ;pointer to blob for pattern
         dc.w  0                    ;pointer to pattern for blob
; menu item selected   :
         dc.w  4                    ;background colour
         dc.w  0                    ;text object ink colour 
         dc.w  0                    ;pointer to blob for pattern
         dc.w  0                    ;pointer to pattern for blob
;
         dc.w  0                    ;pointer to help window
;base of repeated part of window definition 
         dc.w  200                  ;x (min.) size for this layout
         dc.w  140                  ;y (min.) size for this layout
;pointers to definition lists :
         dc.w  0                    ;information sub-windows 
         dc.w  0                    ;loose menu items
         dc.w  al_menu-*            ;application sub-windows
;
         dc.w  -1                   ;end flag
;
;
;Universal application sub-window routines
;
asw_setr
        move.l  a4,-(a7)
        jsr     $08(a2)
        move.l  (a7)+,a3
        tst.l   d0
        bne.s   end_setr
        movem.l d3-d7/a1,-(a7)
        tst.l   $44(a3)
        bne.s   cal_ctrl
        tst.l   -$44(a3)
        beq.s   end_cal
        tst.l   $2c(a3)
        beq.s   end_cal
        lea     awb_draw,a1
        move.l  a1,-$50(a3)
        clr.l   -$4c(a3)
        lea     awb_ctrl,a1
        move.l  a1,-$48(a3)
cal_ctrl
        move.w  $04(a3),d3
        add.w   d3,d3
        addq.w  #4,d3
        move.l  -$1e(a3),d0
        beq.s   pan_ctrl
        move.l  $38(a3),d7
        addq.l  #2,a3
        bsr.s   set_ctrl
        subq.l  #2,a3
pan_ctrl
        move.l  -$3c(a3),d0
        beq.s   end_cal
        add.w   d3,d3
        move.l  $34(a3),d7
        bsr.s   set_ctrl
end_cal
        movem.l (a7)+,d3-d7/a1
        moveq   #0,d0
end_setr
        rts
set_ctrl
        move.l  d0,a1
        move.w  #1,(a1)+
        clr.l   (a1)+
        move.w  -$64(a3),d0
        sub.w   $30(a3),d0
        sub.w   d3,d0
        move.w  $2c(a3),d4
        ble.s   end_setr
        subq.w  #1,d4
        moveq   #-1,d5
        tst.l   d7
        bgt.s   spac_lst
cnt_spc
        addq.w  #1,d5
        add.w   d7,d0
        dblt    d4,cnt_spc
        bra.s   set_siz
spac_lst
        move.l  d7,a2
cnt_spl
        addq.l  #2,a2
        addq.w  #1,d5
        sub.w   (a2)+,d0
        dblt    d4,cnt_spl
set_siz
        move.w  d5,(a1)
        rts
awm_hitr
        jmp      $34(a2)
awm_draw
        jsr      $20(a2)
awb_draw
        jmp      $24(a2)
awm_ctrl
        jmp      $38(a2)
awb_ctrl
        subi.w  #$0a,d4
        beq.s   pan_bl
        move.l  $46(a3),d0
        bra.s   ctrl_bl
pan_bl
        move.l  $28(a3),d0
ctrl_bl
        beq.s   end_ctrl
        move.l  d0,a1
        add.w   d4,d4
        adda.w  d4,a3
        swap    d3
        mulu    $90(a3),d3
        divu    (a3),d3
        move.w  d3,4(a1)
        suba.w  d4,a3
        jsr     $24(a2)
end_ctrl
        moveq   #0,d4
        rts
;
;Application sub-window definition list :
;======================================== 

al_menu
         dc.w  aw0_menu-*           ;pointer to application sub-window
;
         dc.w  0                    ;end flag
;
;
;Application sub-window No. 0
aw0_menu
         dc.w  196                  ;sub-window x size
         dc.w  90                   ;sub-window y size
         dc.w  2                    ;sub-window x origin
         dc.w  25                   ;sub-window y origin
         dc.b  $00                  ;MSbit clear to clear window
         dc.b  0                    ;shadow depth 
         dc.w  1                    ;border width 
         dc.w  4                    ;border colour
         dc.w  2                    ;paper colour 
         dc.w  0                    ;pointer to pointer sprite
         dc.w  asw_setr-*           ;pointer to setup routine
         dc.w  awm_draw-*           ;pointer to draw routine
         dc.w  awm_hitr-*           ;pointer to hit routine
         dc.w  awm_ctrl-*           ;pointer to control routine 
         dc.w  0                    ;maximum number of x control sections 
         dc.w  0                    ;maximum number of y control sections 
         dc.b  0                    ;selection keystroke
         dc.b  0                    ;zero
;menu sub-window definition : 
         dc.w  0                    ;pointer to menu status block 
; menu item attributes
         dc.w  0                    ;current item border width  
         dc.w  7                    ;             border colour 
; menu item unavailable:
         dc.w  7                    ;background colour
         dc.w  55                   ;text object ink colour 
         dc.w  0                    ;pointer to blob for pattern
         dc.w  0                    ;pointer to pattern for blob
; menu item available  :
         dc.w  7                    ;background colour
         dc.w  0                    ;text object ink colour 
         dc.w  0                    ;pointer to blob for pattern
         dc.w  0                    ;pointer to pattern for blob
; menu item selected   :
         dc.w  4                    ;background colour
         dc.w  0                    ;text object ink colour 
         dc.w  0                    ;pointer to blob for pattern
         dc.w  0                    ;pointer to pattern for blob
;
         dc.w  0                    ;number of actual columns 
         dc.w  0                    ;number of actual rows
         dc.w  0                    ;x offset to start of menu (section)
         dc.w  0                    ;y offset to start of menu (section)
         dc.w  0                    ;pointer to x (column) spacing list 
         dc.w  0                    ;pointer to y (row) spacing list
         dc.w  0                    ;pointer to x (column) index list 
         dc.w  0                    ;pointer to y (row) index list
         dc.w  0                    ;pointer to menu row list
;
;


;You have choosen the option that all internal action,
;setup, draw, hit and control routines point to a list of
;longword pointers starting form here.
;EXAMPLE:
;rout
;      dc.l    l0act-*
;      dc.l    l1act-*
;      dc.l    l2act-*
;      ...
;      dc.l    aw1set-*
;      dc.l    aw1draw-*
;      dc.l    aw1hit-*
;      dc.l    aw1ctrl-*
;      dc.l    am1act-*
;      ...
;
;Here must follow
;
;1 longword pointer(s) to
;application sub-window setup, draw, hit, control and/or
;menu item action routines (i.e. 1, 4 or 5 for each sub-window).
;
rout_menu
         end

