all: check test

.PHONY: check
check: list_test.csv
	@for session in 1 2; do \
		if grep ";$$session;" list_test.csv | \
			cut -d ';' -f 5 | \
			sort | uniq -c | grep -v '^ *1' ; then \
			echo "Oups, same machine assigned twice?"; exit 1; \
		else echo "Session $$session OK"; fi \
	done

test: exam_test.tar.gz

TMP=$(HOME)/local/tmp

exam_%.tar.gz: list_%.csv ./exam-%.sh
	./exam-$*.sh --cleanup --cleanup-db --list "$<" --output $(TMP)/exam_$*
	../gen-exam/init-db.sh > $(TMP)/exam_$*/init-db.sql
	(cd $(TMP); tar czf - exam_$*) > $@
	-$(RM) -fr $(TMP)/exam_$*
