#ifndef GRPLOT_INPUT_BUF_MGMT_H
#define GRPLOT_INPUT_BUF_MGMT_H

#include "input_buf.h"

typedef struct {
   unsigned nrRows;
   unsigned nrCols;
   unsigned nrInpBufs;
   unsigned long bufLen;
   unsigned elemLen;
   double *buf;
} grplot_input_buf_mgmt_t;

int
grplot_input_buf_mgmt_init(grplot_input_buf_mgmt_t *, unsigned, unsigned, unsigned);

int
grplot_input_buf_mgmt_get_color(const grplot_input_buf_mgmt_t *, double **, unsigned);

int
grplot_input_buf_mgmt_get_input_buf(const grplot_input_buf_mgmt_t *, grplot_input_buf_t *, unsigned, double);

int
grplot_input_buf_mgmt_get_pixels(const grplot_input_buf_mgmt_t *, double **, unsigned);

void
grplot_input_buf_mgmt_destroy(grplot_input_buf_mgmt_t *);

#endif
