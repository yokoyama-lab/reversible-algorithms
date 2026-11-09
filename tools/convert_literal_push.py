#!/usr/bin/env python3
"""Convert playground-dialect literal `push(C, s)` into l-value form so the
program is accepted by PyJanus jana2014 (which requires push/pop operands to
be l-values).  Each

    push(<int>, <stack>)          // optional comment

becomes

    local int pushtmp = <int>
      push(pushtmp, <stack>)          // optional comment
    delocal int pushtmp = 0

(push zeroes pushtmp, so the delocal value is always 0).  Variable / array-element
pushes are already l-values and are left untouched.

Usage: python3 tools/convert_literal_push.py FILE.j [FILE.j ...]   (edits in place)
"""
import re, sys

# optional leading control keyword (then/else/do/loop) then a literal push
LIT = re.compile(r'^(\s*)(then|else|do|loop)?\s*push\s*\(\s*(-?\d+)\s*,\s*(\w+)\s*\)\s*(//.*)?$')

def convert(text):
    out, n = [], 0
    for line in text.splitlines():
        m = LIT.match(line)
        if m:
            ind, kw, val, stk, cmt = (m.group(1), m.group(2), m.group(3),
                                      m.group(4), (m.group(5) or ""))
            cmt = (" " + cmt) if cmt else ""
            body = ind + ("  " if kw else "")
            if kw:
                out.append(f"{ind}{kw}")
            out.append(f"{body}local int pushtmp = {val}")
            out.append(f"{body}  push(pushtmp, {stk}){cmt}")
            out.append(f"{body}delocal int pushtmp = 0")
            n += 1
        else:
            out.append(line)
    return "\n".join(out) + ("\n" if text.endswith("\n") else ""), n

if __name__ == "__main__":
    total = 0
    for path in sys.argv[1:]:
        new, n = convert(open(path).read())
        if n:
            open(path, "w").write(new)
        print(f"  {n:3d} push converted  {path}")
        total += n
    print(f"total: {total}")
