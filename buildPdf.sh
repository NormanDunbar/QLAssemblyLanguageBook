#! /bin/bash

#
# Builds a new version of the Assembly Language book with contents and indexes etc
# all correctly styled. Assumes the utilities on the path include:
#
#    pdflatex
#    makeindex
#
# And, that your shell session is correctly open in the top level directory.
#
# Norman Dunbar.
# Somethime in 2015!
# Last Modified: 25th June 2017.
#

pdflatex AssemblyLanguage.tex
pdflatex AssemblyLanguage.tex
makeindex -s StyleInd.ist AssemblyLanguage.idx
pdflatex AssemblyLanguage.tex

