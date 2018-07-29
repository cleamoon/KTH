#!/bin/sh

cp ../ps/puffin-manual.ps .
cp ../pdf/puffin-manual.pdf .
scp puffin-manual.p* merlin.cs.uchicago.edu:www-fenics/pub/documents/puffin/manual
