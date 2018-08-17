; hello-os
; TAB=4

; For FAT12
    ORG     0x7c00
    JMP     entry
    DB      0x90
    DB    "HELLOIPL"
    DW    512
    DB    1
    DW    1
    DB    2
    DW    224
    DW    2880
    DB    0xf0
    DW    9
    DW    18
    DW    2
    DD    0
    DD    2880
    DB    0,0,0x29
    DD    0xffffffff
    DB    "HELLO-OS   "
    DB    "FAT12   "
    RESB  18

; プログラム本体

entry:
    MOV     AX,0
    MOV     SS,AX
    MOV     SP,0x7c00
    MOV     DS,AX   ; セグメントレジスタ. バッファアドレスに加算される.

; Read disk
    MOV     AX,0x0820
    MOV     ES,AX   ; バッファアドレス
    MOV     CH,0    ; シリンダ番号
    MOV     DH,0    ; ヘッド番号
    MOV     CL,2    ; セクタ番号

    MOV     AH,0x02 ; 0x13のモード読み込み
    MOV     AL,1    ; 処理するセクタ数
    MOV     BX,0    ; バッファアドレス
    MOV     DL,0x00 ; ドライブ番号
    INT     0x13    ; ディスクアクセス命令
    JC      error   ; 0x13できゃりーがあるならerrorへ

fin:
    HLT
    JMP     fin

error:
    MOV     AX,0
    MOV     ES,AX
    MOV     SI,msg

putloop:
    MOV     AL,[SI]
    ADD     SI,1
    CMP     AL,0
    JE      fin
    MOV     AH,0x0e
    MOV     BX,15
    INT     0x10
    JMP     putloop

msg:
    DB      0x0a, 0x0a
    DB      "load error"
    DB      0x0a
    DB      0
    RESB    0x7dfe-$
    DB      0x55, 0xaa