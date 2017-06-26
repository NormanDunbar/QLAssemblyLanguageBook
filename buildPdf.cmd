@echo off
rem
rem Builds a new version of the Assembly Language book with contents and indexes etc
rem all correctly styled. Assumes the utilities on the path include:
rem
rem    pdflatex
rem    makeindex
rem
rem And, that your cmd session is correctly open in the top level directory.
rem
rem Norman Dunbar.
rem Sometime in 2015!
rem Last Modified: 26th June 2017.
rem

pdflatex AssemblyLanguage.tex
pdflatex AssemblyLanguage.tex
makeindex -s StyleInd.ist AssemblyLanguage.idx
pdflatex AssemblyLanguage.tex

