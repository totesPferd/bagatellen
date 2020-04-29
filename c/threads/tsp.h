#ifndef TSP_H
#define TSP_H

#include <pthread.h>

/* Globals. */
pthread_mutex_t tsp_mutex;

void tsp_init();
void tsp_tsp(const char *);
void tsp_destroy();

#endif
