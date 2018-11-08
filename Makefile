LATEX=latexmk -pdf -bibtex
CHKTEX_ARGS=-n 3 -n 6
TEX_SOURCES=$(wildcard *.tex)
TEX_SOURCES_BASENAME=$(basename $(TEX_SOURCES))

%.pdf: %.tex refs.bib
	$(LATEX) $<

clean-src-%: %.tex
	$(LATEX) -c $<

clean-all-src-%: %.tex
	$(LATEX) -C $<

clean-srcs: $(addprefix clean-src-,$(TEX_SOURCES_BASENAME))

clean-all-srcs: $(addprefix clean-all-src-,$(TEX_SOURCES_BASENAME))

clean: clean-fmt clean-check clean-srcs

clean-all: clean clean-all-srcs

fmt: $(addsuffix .bak,$(TEX_SOURCES_BASENAME))

clean-fmt:
	$(RM) *.bak
	$(RM) indent.log

check: $(addprefix check-,$(TEX_SOURCES_BASENAME))

clean-check:
	$(RM) lint-*.out

fmt-%: %.bak

%.bak: %.tex
	echo "Indenting $<"
	latexindent -w -l $<

lint-%.out: %.tex
	chktex -q $(CHKTEX_ARGS) $< 2>/dev/null | tee $@

check-%: lint-%.out
	test ! -s $<
