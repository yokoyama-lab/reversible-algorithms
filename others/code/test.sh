#!/bin/sh

##################################################
# set environment variable INT to jana interpreter
#
# Example use:
# INT=../Jana-JanusInterp/dist/build/jana/jana ./test.sh
# INT=../jana/src/ja ./test.sh
##################################################

echo ==== factorial.j ====
$INT factorial.j

# echo ==== bsort_irev.j ====
# $INT bsort_irev.j

echo ==== bsort1.j ====
$INT bsort1.j

echo ==== bsort2.j ====
$INT bsort2.j

echo ==== bsort3.j ====
$INT bsort3.j

echo ==== bsort4.j ====
$INT bsort4.j

# ==================================

# echo ==== isort_irev.j ====
# $INT isort_irev.j

echo ==== isort1.j ====
$INT isort1.j

echo ==== isort2.j ====
$INT isort2.j

echo ==== isort3.j ====
$INT isort3.j

# echo ==== isort4.j ====
# $INT isort4.j

# echo ==== isort5.j ====
# $INT isort5.j

# echo ==== isort6.j ====
# $INT isort6.j

# echo ==== isort_irev1.j ====
# $INT isort_irev1.j

echo ==== qsort.j ====
$INT qsort.j

echo ==== qsort1.j ====
$INT qsort1.j

echo ==== qsort2.j ====
$INT qsort2.j

echo ==== ssort.j ====
$INT ssort.j

echo ==== ssort1.j ====
$INT ssort1.j

echo ==== msort.j ====
$INT msort.j

echo ==== perm2decfac.j ====
$INT perm2decfac.j

echo ==== perm2decfac_nolex.j ====
$INT perm2decfac_nolex.j

echo ==== decfac2rank.j ====
$INT decfac2rank.j
