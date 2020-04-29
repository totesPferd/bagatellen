all: example flowctrl.so rwlock.so semaphore.so

example: flowctrl.o main.o semaphore.o tsp.o
	gcc flowctrl.o main.o semaphore.o tsp.o -oexample -llua5.1 -lpthread

example2: flowctrl2.o example2.o semaphore.o tsp.o
	gcc flowctrl2.o example2.o semaphore.o tsp.o -oexample2 -llua5.1 -lpthread

flowctrl.o: flowctrl.c flowctrl.h semaphore.h tsp.h
	gcc -fPIC -c flowctrl.c -I/usr/include/lua5.1

flowctrl2.o: flowctrl2.c flowctrl2.h semaphore.h tsp.h
	gcc -fPIC -c flowctrl2.c

main.o: main.c flowctrl.h semaphore.h tsp.h
	gcc -c main.c 

example2.o : example2.c flowctrl2.h semaphore.h tsp.h
	gcc -c example2.c

semaphore.o: semaphore.c semaphore.h
	gcc -fPIC -c semaphore.c -I/usr/include/lua5.1

tsp.o: tsp.c tsp.h
	gcc -fPIC -c tsp.c

rwlock.o: rwlock.c rwlock.h
	gcc -fPIC -c rwlock.c -I/usr/include/lua5.1

flowctrl.so: flowctrl.o
	gcc -shared flowctrl.o semaphore.o tsp.o -oflowctrl.so

flowctrl2.so: flowctrl2.o
	gcc -shared flowctrl2.o semaphore.o tsp.o -oflowctrl2.so

rwlock.so: rwlock.o
	gcc -shared rwlock.o -orwlock.so

semaphore.so: semaphore.o
	gcc -shared semaphore.o -osemaphore.so
