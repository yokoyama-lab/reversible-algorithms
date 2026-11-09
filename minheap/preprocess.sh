#!/bin/sh
# マクロの展開は以下のように行うこと

cat minheap_Nohr2015_w_macro.j |\
 sed -e 's/MAX/4294967295/g' |\
 sed -e 's/^\([[:space:]]*\)\(.*\)[[:space:]]*^=[[:space:]]*\(.*\)[[:space:]]*?[[:space:]]*\(.*\)[[:space:]]*:[[:space:]]*\(.*\)/\1if \3 then\n\1    \2 ^= \4\n\1else\n\1    \2 ^= \5\n\1fi \3/g' |\
 sed -e 's/^\([[:space:]]*\)local int[[:space:]]*\(\w*\)[[:space:]]*=[[:space:]]*\(.*\)[[:space:]]*?[[:space:]]*\(.*\)[[:space:]]*:[[:space:]]*\(.*\)/\1local int \2 = 0\n\1if \3 then\n\1    \2 ^= \4\n\1else\n\1    \2 ^= \5\n\1fi \3/g' |\
 sed -e 's/^\([[:space:]]*\)delocal int[[:space:]]*\(\w*\)[[:space:]]*=[[:space:]]*\(.*\)[[:space:]]*?[[:space:]]*\(.*\)[[:space:]]*:[[:space:]]*\(.*\)/\1if \3 then\n\1    \2 ^= \4\n\1else\n\1    \2 ^= \5\n\1fi \3\n\1delocal int \2 = 0/g' |\
 sed -e 's/LEFT(\([^)]*\))/2 * \1/g' |\
 sed -e 's/RIGHT(\([^)]*\))/2 * \1 + 1/g' |\
 sed -e 's/PARENT(\([^)]*\))/(\1) \/ 2/g'\
 > minheap_Nohr2015_w_macro_generated.j
