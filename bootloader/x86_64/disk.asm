sectalign off

%include "bootsector.asm"

startup_start:
%ifdef ARCH_i386
    %include "startup-i386.asm"
%endif

%ifdef ARCH_x86_64
    %include "startup-x86_64.asm"
%endif
align 512, db 0
startup_end:

%define FS_BLOCK_SHIFT 12
%define FS_BLOCK_SIZE (1 << FS_BLOCK_SHIFT)

align FS_BLOCK_SIZE, db 0
%ifdef REDOXFS
redox_fs:
    %defstr REDOXFS_STR %[REDOXFS]
    incbin REDOXFS_STR
    .end:
    align FS_BLOCK_SIZE, db 0
%endif

%ifdef KERNEL
    kernel_file:
      %defstr KERNEL_STR %[KERNEL]
      incbin KERNEL_STR
    .end:
    align 512, db 0
%else
    align BLOCK_SIZE, db 0
    %ifdef FILESYSTEM
        filesystem:
            %defstr FILESYSTEM_STR %[FILESYSTEM]
            incbin FILESYSTEM_STR
        .end:
        align BLOCK_SIZE, db 0
    %else
        filesystem:
    %endif
%endif


align FS_BLOCK_SIZE, db 0
%ifdef REALSTUB
drop_to_real_start:
    %defstr REALSTUB_STR %[REALSTUB]
    incbin REALSTUB_STR
    .end:
    align FS_BLOCK_SIZE, db 0
%else
    drop_to_real_start:
%endif

align FS_BLOCK_SIZE, db 0
%ifdef INITSTUB
drop_for_init_start:
    %defstr INITSTUB_STR %[INITSTUB]
    incbin INITSTUB_STR
    .end:
    align FS_BLOCK_SIZE, db 0
%else
    drop_for_init_start:
%endif



align FS_BLOCK_SIZE, db 0
%ifdef FAT32
fat32:
    %defstr FAT32_STR %[FAT32]
    incbin FAT32_STR
    .end:
    align FS_BLOCK_SIZE, db 0
%else
    fat32:
%endif

