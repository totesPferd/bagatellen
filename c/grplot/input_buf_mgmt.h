#ifndef GRPLOT_INPUT_BUF_MGMT_H
#define GRPLOT_INPUT_BUF_MGMT_H

typedef enum {
      grplot_input_buf_mgmt_ok = 0 } grplot_input_buf_mgmt_status_t;

typedef struct {
   unsigned nrRows;
   unsigned nrCols;
   unsigned nrInpBufs;
   unsigned long bufLen;
   unsigned elemLen;
   double *buf;
} grplot_input_buf_mgmt_t;

grplot_input_buf_mgmt_status_t
grplot_input_buf_mgmt_init(grplot_input_buf_mgmt_t *, unsigned, unsigned, unsigned);

grplot_input_buf_mgmt_status_t
grplot_input_buf_mgmt_get_color(const grplot_input_buf_mgmt_t *, double **, unsigned);

grplot_input_buf_mgmt_status_t
grplot_input_buf_mgmt_get_pixels(const grplot_input_buf_mgmt_t *, double **, unsigned);

void
grplot_input_buf_mgmt_destroy(grplot_input_buf_mgmt_t *);

#endif
