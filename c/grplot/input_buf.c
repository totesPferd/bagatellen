#include <assert.h>
#include <math.h>

#include "input_buf.h"

int
grplot_input_buf_init(
      grplot_input_buf_t *p_input_buf
   ,  unsigned long bufLen
   ,  double *buf
   ,  unsigned nrRows
   ,  unsigned nrCols
   ,  double radius ) {
   assert(p_input_buf);
   assert(buf);
   assert(bufLen == nrRows * nrCols);

   int retval =  0;

   p_input_buf->bufLen =  bufLen;
   p_input_buf->buf =  buf;
   p_input_buf->nrRows =  nrRows;
   p_input_buf->nrCols =  nrCols;
   p_input_buf->radius =  radius;

   for (unsigned i =  0; i < bufLen; i++) {
      p_input_buf->buf[i] =  0.0;
   }

   return retval;
}

int
grplot_input_buf_plot_point(grplot_input_buf_t *p_input_buf, double x, double y, double weight) {
   assert(p_input_buf);
   assert(p_input_buf->buf);
   assert(x <= 1.0);
   assert(x >= 0.0);
   assert(y <= 1.0);
   assert(y >= 0.0);

   int retval =  0;

   double *ptr =  p_input_buf->buf;
   for (int pixelY =  0; pixelY < p_input_buf->nrRows; pixelY++) {

      double double_pixelY =  (double) pixelY / (double) p_input_buf->nrRows - y;

      for (int pixelX =  0; pixelX < p_input_buf->nrCols; pixelX++) {

         double double_pixelX =  (double) pixelX / (double) p_input_buf->nrCols - x;

         *(ptr++) +=
            weight * exp((- double_pixelX * double_pixelX - double_pixelY * double_pixelY) / p_input_buf->radius);

      }
   }

   return retval;
}

int 
grplot_input_buf_get_max(const grplot_input_buf_t *p_input_buf, double *p_result) {
   assert(p_input_buf);
   assert(p_result);

   int retval =  1;

   double *p_buf_ptr =  p_input_buf->buf;

   for (unsigned long i =  0; i < p_input_buf->bufLen; i++) {
      if (retval) {
         *p_result =  *p_buf_ptr;
         retval =  0;
      } else if (*p_result < *p_buf_ptr) {
         *p_result =  *p_buf_ptr;
      }
      p_buf_ptr++;
   }

   return retval;
}

int
grplot_input_buf_get_min(const grplot_input_buf_t *p_input_buf, double *p_result) {
   assert(p_input_buf);
   assert(p_result);

   int retval =  1;

   double *p_buf_ptr =  p_input_buf->buf;

   for (unsigned long i =  0; i < p_input_buf->bufLen; i++) {
      if (retval) {
         *p_result =  *p_buf_ptr;
         retval =  0;
      } else if (*p_result > *p_buf_ptr) {
         *p_result =  *p_buf_ptr;
      }
   }

   return retval;
}

int
grplot_input_buf_normalize(grplot_input_buf_t *p_input_buf, double minVal, double maxVal) {
   assert(p_input_buf);
   assert(maxVal > minVal);
   int retval =  0;

   double diffVal =  maxVal - minVal;

   for (unsigned long i =  0; i < p_input_buf->bufLen; i++) {
      assert(p_input_buf->buf[i] >= minVal);
      assert(p_input_buf->buf[i] <= maxVal);

      p_input_buf->buf[i] =  (p_input_buf->buf[i] - minVal) / diffVal;
   }

   return retval;
}

void
grplot_input_buf_destroy(grplot_input_buf_t *p_input_buf) {
   assert(p_input_buf);
}
