#!/bin/bash
(cd sources && sjasmplus main.asm)
(cd bootstrap && ez80asm cpm.asm)