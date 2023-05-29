    device zxspectrum48
    
    org $e200-3
    DISPLAY "ORG: ", $
cpm:
    jp BOOT
    include "ez80.asm"
    DISPLAY "CPM: ", $
    include "cpm.asm"
    include "bios/bios.asm"
cpm_size = $ - cpm
    savebin "cpm.sys", cpm, cpm_size
    