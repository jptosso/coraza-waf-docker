#!/bin/bash

git clone https://github.com/libinjection/libinjection
cd libinjection
gcc -std=c99 -Wall -Werror -fpic -c src/libinjection_sqli.c -o libinjection_sqli.o 
gcc -std=c99 -Wall -Werror -fpic -c src/libinjection_xss.c -o libinjection_xss.o
gcc -std=c99 -Wall -Werror -fpic -c src/libinjection_html5.c -o libinjection_html5.o
gcc -dynamiclib -shared -o libinjection.so libinjection_sqli.o libinjection_xss.o libinjection_html5.o
cp *.so /usr/local/lib
cp *.o /usr/local/lib
cp src/*.h /usr/local/include/
chmod 444 /usr/local/include/libinjection*