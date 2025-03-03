#!/bin/bash
(cd autoexec && sjasmplus autoexec.asm)
(cd sources && sjasmplus -DCRT=1 main.asm)
(cd bootstrap && ez80asm cpm.asm)

cp bootstrap/cpm.bin cpm.bin

(cd sources && sjasmplus main.asm)
(cd bootstrap && ez80asm cpm.asm)

cp bootstrap/cpm.bin cpm-uart.bin