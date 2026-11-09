#!/usr/bin/env python3
"""Map each IN_CORPUS file of tools/build_catalog.py to its best-matching PyJanus
example (comment-stripped token sequence, difflib ratio).  Prints one TSV line
per file: file, best match, ratio, runner-up, ratio.  1.000 = token-identical.

  python3 tools/mirror_match.py <ra-tree> <PyJanus>/tests/jana2014/fixtures/examples
"""
import difflib
import glob
import os
import re
import sys


def toks(p):
    t = open(p, errors="replace").read()
    t = re.sub(r"//[^\n]*", "", t)
    t = re.sub(r"/\*.*?\*/", "", t, flags=re.S)
    return re.findall(r"\w+|[^\w\s]", t)


def main(ra, ex):
    src = open(os.path.join(ra, "tools/build_catalog.py")).read()
    in_corpus = eval(re.search(r"IN_CORPUS = (\{.*?\n\})", src, re.S).group(1))
    exs = {os.path.basename(p): toks(p) for p in glob.glob(ex + "/*.ja")}
    for f in sorted(in_corpus):
        a = toks(os.path.join(ra, f))
        best = sorted(((difflib.SequenceMatcher(None, a, b, autojunk=False).ratio(), n)
                       for n, b in exs.items()), reverse=True)[:2]
        print(f"{f}\t{best[0][1]}\t{best[0][0]:.3f}\t{best[1][1]}\t{best[1][0]:.3f}")


if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
