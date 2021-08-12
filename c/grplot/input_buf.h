#ifndef GRPLOT_INPUT_BUF_H
#define GRPLOT_INPUT_BUF_H

typedef struct {
   unsigned nrRows;
   unsigned nrCols;
   unsigned long bufLen;
   double radius;
   double *buf;
} grplot_input_buf_t;

int
grplot_input_buf_init(grplot_input_buf_t *, unsigned long, double *, unsigned, unsigned, double);

int
grplot_input_buf_plot_point(grplot_input_buf_t *, double, double, double);

int
grplot_input_buf_get_max(const grplot_input_buf_t *, double *);

int
grplot_input_buf_get_min(const grplot_input_buf_t *, double *);

int
grplot_input_buf_normalize(grplot_input_buf_t *, double, double);

void
grplot_input_buf_destroy(grplot_input_buf_t *);

#endif
