#! /bin/bash

set -x
set -e

./generate-step-A2.sh
./generate-step-A5.sh

./generate-step-B1.sh

./generate-step-C1.sh
./generate-step-C3.sh

./generate-step-D1.sh
./generate-step-D2.sh

./generate-step-E10.sh
./generate-step-E11.sh
./generate-step-E13.sh

rm -fr ./demo-exam-ensimag2011/
(cd ../exam-expl/ && ./demo-ensimag2011.sh)
mv ../exam-expl/exam_genere/php/ ./demo-exam-ensimag2011/

./generate-step-E1.sh
./generate-step-E4.sh
./generate-step-E5.sh
# Must come after E4 and E5.
./generate-step-E3.sh
./generate-step-E6.sh

./generate-step-F2.sh

./generate-step-G2.sh

./generate-step-H5.sh
./generate-step-H8.sh
