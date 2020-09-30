#include <stdio.h>

#include "tsp.h"


pthread_mutex_t tsp_mutex;


void
tsp_init() {
 pthread_mutex_init(&tsp_mutex, NULL);
}

void
tsp_destroy() {
 pthread_mutex_destroy(&tsp_mutex);
}

void
tsp_tsp(const char *str) {
 pthread_mutex_lock(&tsp_mutex);
 printf("%s", str);
 pthread_mutex_unlock(&tsp_mutex);
}

void
tsp_c(const char c) {
   char buf[2];
   buf[0] = c;
   buf[1] = '\0';
   tsp_tsp(buf);
}
