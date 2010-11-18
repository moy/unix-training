TARBALLS=exam_test.tar.gz demo_ensimag2010.tar.gz demo_ensimag2010-en.tar.gz
all: check $(TARBALLS)

.PHONY: check
check: list_test.csv
	@for session in 1 2; do \
		if grep ";$$session;" list_test.csv | \
			cut -d ';' -f 5 | \
			sort | uniq -c | grep -v '^ *1' ; then \
			echo "Oups, same machine assigned twice?"; exit 1; \
		else echo "Session $$session OK"; fi \
	done

TMP=$(HOME)/local/tmp

exam_%.tar.gz: list_%.csv ./exam-%.sh
	./exam-$*.sh --cleanup --cleanup-db --list "$<" --output $(TMP)/exam_$*
	../gen-exam/init-db.sh > $(TMP)/exam_$*/init-db.sql
	(cd $(TMP); tar czf - exam_$*) > $@
	-$(RM) -fr $(TMP)/exam_$*

demo_%.tar.gz: ./demo-%.sh
	./demo-$*.sh --cleanup
	cd exam_genere/ && mv php demo_$* && tar czvf ../demo_$*.tar.gz demo_$*
	-$(RM) -fr exam_genere/

.PHONY: clean
clean:
	-$(RM) $(TARBALLS)
