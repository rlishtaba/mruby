require 'rubygems'

compiller = <<-STR

/C/Tools/arm-elf-gcc-4.7.3-r1bin/arm-elf-gcc -Wall -Wno-deprecated-declarations -Wno-write-strings -Wno-attributes -std=gnu++0x -D_GLIBCXX_USE_C99 -D_GLIBCXX_USE_C99_DYNAMIC -DMRB_HEAP_PAGE_SIZE=64 -DMRB_USE_IV_SEGLIST -DKHASH_DEFAULT_SIZE=8 -DMRB_STR_BUF_MIN_SIZE=20 -DMRB_GC_STRESS -Iz:/Personal/Development/workspace/EXPERIMENT/SimpleApp/DevLibs/mruby/include -o z:/Personal/Development/workspace/EXPERIMENT/SimpleApp/DevLibs/mruby/build/telium/src/array.o -c z:/Personal/Development/workspace/EXPERIMENT/SimpleApp/DevLibs/mruby/src/array.c

STR

system compiller