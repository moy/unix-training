#! /bin/bash

set -x
set -e

./genere-etape-A2.sh
./genere-etape-A5.sh

./genere-etape-B1.sh

./genere-etape-C1.sh
./genere-etape-C3.sh

./genere-etape-D1.sh
./genere-etape-D2.sh

./genere-etape-E10.sh
./genere-etape-E11.sh
./genere-etape-E13.sh

rm -fr ./demo-exam-ensimag2011/
(cd ../exam-expl/ && ./demo-ensimag2011.sh)
mv ../exam-expl/exam_genere/php/ ./demo-exam-ensimag2011/

./genere-etape-E1.sh
./genere-etape-E4.sh
./genere-etape-E5.sh
# Must come after E4 and E5.
./genere-etape-E3.sh
./genere-etape-E6.sh

./genere-etape-F2.sh

./genere-etape-G2.sh

./genere-etape-H5.sh
./genere-etape-H8.sh
