#! /bin/sh

rsync -av ~/WWW/test_exam/ php/ --exclude .git --exclude '*~'
