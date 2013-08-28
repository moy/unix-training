#! /bin/sh

for m in telesun ensibm ensisun ensipc100; do
	HUNT_MAINMACHINE=$m make install
done
