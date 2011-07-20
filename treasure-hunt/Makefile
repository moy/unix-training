PO_FILES=${wildcard */LC_MESSAGES/*.po}
MO_FILES=$(PO_FILES:.po=.mo)

all: $(MO_FILES)

clean:
	-$(RM) $(MO_FILES)

%.mo: %.po
	msgfmt -o $@ $<

XGETTEXT_FLAGS=-L Shell --from-code=UTF-8

xgettext: xgettext-join-A5

xgettext-join-%:
	xgettext --join-existing -d $* $(XGETTEXT_FLAGS) generate-step-$*.sh -o fr/LC_MESSAGES/$*.po
	xgettext --join-existing -d $* $(XGETTEXT_FLAGS) generate-step-$*.sh -o en/LC_MESSAGES/$*.po

xgettext-reset-%:
	xgettext -d $* $(XGETTEXT_FLAGS) generate-step-$*.sh -o fr/LC_MESSAGES/$*.po
	perl -pi -e 's/CHARSET/UTF-8/' fr/LC_MESSAGES/$*.po
	xgettext -d $* $(XGETTEXT_FLAGS) generate-step-$*.sh -o en/LC_MESSAGES/$*.po
	perl -pi -e 's/CHARSET/UTF-8/' en/LC_MESSAGES/$*.po
