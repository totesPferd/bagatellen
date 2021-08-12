#include <assert.h>

#include "input_buf_by_mgmt.h"

int
grplot_input_buf_by_mgmt_init(
      const grplot_input_buf_mgmt_t *p_input_buf_mgmt
   ,  grplot_input_buf_t *p_input_buf
   ,  unsigned index
   ,  double radius ) {
   assert(p_input_buf_mgmt);
   assert(p_input_buf);
   assert(index < p_input_buf_mgmt->nrInpBufs);
   int retval =  0;

   {
      double *p_pixels;
      retval =  grplot_input_buf_mgmt_get_pixels(p_input_buf_mgmt, &p_pixels, index);

      grplot_input_buf_init(
            p_input_buf
         ,  p_input_buf_mgmt->bufLen
         ,  p_pixels
         ,  p_input_buf_mgmt->nrRows
         ,  p_input_buf_mgmt->nrCols
         ,  radius );
   }

   return retval;
}

