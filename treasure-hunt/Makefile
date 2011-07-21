# Makefile for i18n of the hunt with gettext.
STEP_FILES=${wildcard generate-step-*.sh i18n-lib.sh upload-to-servers.sh generate-all.sh}
STEPS=${patsubst generate-step-%.sh, %, $(STEP_FILES)}
LANGUAGES=fr en
PO_FILES=${foreach l, $(LANGUAGES), $l/LC_MESSAGES/hunt.po}
MO_FILES=$(PO_FILES:.po=.mo)
PO_TEMPLATE=hunt.pot

all: mo pot

full:
	@$(MAKE) --no-print-directory pot
	@$(MAKE) --no-print-directory msgmerge
	@$(MAKE) --no-print-directory mo

mo: $(MO_FILES)
pot: $(PO_TEMPLATE)

clean:
	-$(RM) $(MO_FILES)

%.mo: %.po
	msgfmt -o $@ $<

XGETTEXT_FLAGS=-L Shell --from-code=UTF-8

$(PO_TEMPLATE): $(STEP_FILES)
	xgettext -d hunt $(XGETTEXT_FLAGS) $^ -o $@

msgmerge:
	$(foreach p, $(PO_FILES), echo Updating $p ; msgmerge -U $p $(PO_TEMPLATE) ; )

install: mo
	./generate-all.sh
	./upload-to-servers.sh
