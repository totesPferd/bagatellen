#ifndef GRPLOT_INPUT_BUF_H
#define GRPLOT_INPUT_BUF_H

#include "input_buf_mgmt.h"

typedef enum {
      grplot_input_buf_ok = 0
   ,  grplot_input_buf_empty_buf
   ,  grplot_input_buf_zero_range } grplot_input_buf_status_t;

typedef struct {
   unsigned nrRows;
   unsigned nrCols;
   unsigned long bufLen;
   double *buf;
} grplot_input_buf_t;

grplot_input_buf_status_t
grplot_input_buf_init(grplot_input_buf_t *, unsigned long, double *, unsigned, unsigned);

grplot_input_buf_status_t
grplot_input_buf_plot_point(grplot_input_buf_t *, double, double, double, double);

grplot_input_buf_status_t
grplot_input_buf_get_max(const grplot_input_buf_t *, double *);

grplot_input_buf_status_t
grplot_input_buf_get_min(const grplot_input_buf_t *, double *);

grplot_input_buf_status_t
grplot_input_buf_normalize(grplot_input_buf_t *, double, double);

void
grplot_input_buf_destroy(grplot_input_buf_t *);

#endif
