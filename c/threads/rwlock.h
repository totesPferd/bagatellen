#ifndef RWLOCK_H
#define RWLOCK_H

#include <pthread.h>

typedef struct {
 pthread_cond_t     condVar;
 pthread_mutex_t    mutex;
 unsigned long long nrReader;
} rwlock_t;

void
rwlock_init(rwlock_t *);

void
rwlock_destroy(rwlock_t *);

void
rwlock_read_lock(rwlock_t *);

void
rwlock_read_unlock(rwlock_t *);

void
rwlock_write_lock(rwlock_t *);

void
rwlock_write_unlock(rwlock_t *);

#endif
