#!/bin/sh

cd src
make all
cd ..
make
sudo make install
php -f test.php