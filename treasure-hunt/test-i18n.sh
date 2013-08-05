#! /bin/sh

. ./i18n-lib.sh

f() {
    echo "Displaying message with locale $LANG (should NOT display just 'message-id')"
    gettext "message-id
"
    locale
    echo "If you see error messages above, you may need to run (as root):"
    echo "locale-gen $LANG"
    echo
}

multilingual_do f
