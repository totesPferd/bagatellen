#ifndef OUTPUT_BUF_BY_MGMT_H
#define OUTPUT_BUF_BY_MGMT_H

#include <Imlib2.h>

#include "input_buf_mgmt.h"

typedef enum {
      grplot_output_buf_by_mgmt_ok = 0 } grplot_output_buf_by_mgmt_status_t;

grplot_output_buf_by_mgmt_status_t
grplot_output_buf_by_mgmt_set_buf(
      DATA32 *
   ,  const grplot_input_buf_mgmt_t *
   ,  unsigned
   ,  unsigned
   ,  unsigned
   ,  DATA32);

#endif
