pdf:
	xelatex -interaction=nonstopmode architecture.txt

2pdf: mermaid
	pandoc -F mermaid-filter -o arch.pdf arch.md --pdf-engine=xelatex -V mainfont="Libertinus Serif" -V lang=ru-RU -V geometry:top=2cm,bottom=2cm,left=2.2cm,right=2.2cm -V figure-placement=H -H header.tex -f markdown-implicit_figures

html: mermaid
	pandoc -s -F mermaid-filter -o arch.html --embed-resources arch.md

SHELL := /bin/bash

CHROME := /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome

MMD := $(shell find . -type f -name '*.mmd')
SVG := $(MMD:.mmd=.svg)

.PHONY: mermaid
mermaid: $(SVG)

%.svg: %.mmd
	PUPPETEER_EXECUTABLE_PATH=$(CHROME) mmdc -i "$<" -o "$@" -b transparent

pdfs:
	@set -eu; \
	echo "PWD=$$(pwd)"; \
	echo "SVG files:"; \
	find . -type f -name '*.svg' -print; \
	echo "Converting..."; \
	find . -type f -name '*.svg' -print0 | while IFS= read -r -d '' f; do \
	  out="$${f%.svg}.pdf"; \
	  echo "  $$f  ->  $$out"; \
	  inkscape "$$f" --export-type=pdf --export-filename="$$out" --export-overwrite --export-text-to-path; \
	done

watch:
	echo ./a.tex | entr xelatex -interaction=nonstopmode a.tex
