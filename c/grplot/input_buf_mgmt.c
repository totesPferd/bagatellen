#include <assert.h>
#include <stdlib.h>

#include "input_buf_mgmt.h"

int
grplot_input_buf_mgmt_init(grplot_input_buf_mgmt_t *p_input_buf_mgmt, unsigned nrRows, unsigned nrCols, unsigned nrInpBufs) {
   assert(p_input_buf_mgmt);
   int retval =  0;

   p_input_buf_mgmt->nrRows =  nrRows;
   p_input_buf_mgmt->nrCols =  nrCols;
   p_input_buf_mgmt->nrInpBufs =  nrInpBufs;
   p_input_buf_mgmt->bufLen =  nrRows * nrCols;
   p_input_buf_mgmt->elemLen =  p_input_buf_mgmt->bufLen + 4;
   const unsigned mgmtLen =  p_input_buf_mgmt->elemLen * nrInpBufs;
   p_input_buf_mgmt->buf =  (double *) malloc(mgmtLen * sizeof(double));

   return retval;
}

int
grplot_input_buf_mgmt_get_color(const grplot_input_buf_mgmt_t *p_input_buf_mgmt, double **pp_color, unsigned index) {
   assert(p_input_buf_mgmt);
   assert(index < p_input_buf_mgmt->nrInpBufs);
   int retval =  0;

   const unsigned mgmtIndex =  p_input_buf_mgmt->elemLen * index;
   *pp_color =  p_input_buf_mgmt->buf + mgmtIndex;

   return retval;
}

int
grplot_input_buf_mgmt_get_pixels(
      const grplot_input_buf_mgmt_t *p_input_buf_mgmt
   ,  double **pp_pixels
   ,  unsigned index ) {
   assert(p_input_buf_mgmt);
   assert(index < p_input_buf_mgmt->nrInpBufs);
   int retval =  0;

   const unsigned mgmtIndex =  p_input_buf_mgmt->elemLen * index + 4;
   *pp_pixels =  p_input_buf_mgmt->buf + mgmtIndex;

   return retval;
}

void
grplot_input_buf_mgmt_destroy(grplot_input_buf_mgmt_t *p_input_buf_mgmt) {
   assert(p_input_buf_mgmt);

   free(p_input_buf_mgmt->buf);
}

