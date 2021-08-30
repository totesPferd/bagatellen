#include <assert.h>
#include <math.h>

#include "input_buf.h"

grplot_input_buf_status_t
grplot_input_buf_init(
      grplot_input_buf_t *p_input_buf
   ,  unsigned long bufLen
   ,  double *buf
   ,  unsigned nrRows
   ,  unsigned nrCols ) {
   assert(p_input_buf);
   assert(buf);
   assert(bufLen == nrRows * nrCols);

   grplot_input_buf_status_t retval =  grplot_input_buf_ok;

   p_input_buf->bufLen =  bufLen;
   p_input_buf->buf =  buf;
   p_input_buf->nrRows =  nrRows;
   p_input_buf->nrCols =  nrCols;

   return retval;
}

grplot_input_buf_status_t
grplot_input_buf_plot_point(grplot_input_buf_t *p_input_buf, double x, double y, double weight, double radius) {
   assert(p_input_buf);
   assert(p_input_buf->buf);
   assert(radius >= 0.0);
   assert(x <= 1.0);
   assert(x >= 0.0);
   assert(y <= 1.0);
   assert(y >= 0.0);

   grplot_input_buf_status_t retval =  grplot_input_buf_ok;

   double *ptr =  p_input_buf->buf;
   for (int pixelY =  0; pixelY < p_input_buf->nrRows; pixelY++) {

      double double_pixelY =  (double) pixelY / (double) p_input_buf->nrRows - y;

      for (int pixelX =  0; pixelX < p_input_buf->nrCols; pixelX++) {

         double double_pixelX =  (double) pixelX / (double) p_input_buf->nrCols - x;

         *(ptr++) +=
            weight * exp((- double_pixelX * double_pixelX - double_pixelY * double_pixelY) / radius);

      }
   }

   return retval;
}

grplot_input_buf_status_t
grplot_input_buf_get_max(const grplot_input_buf_t *p_input_buf, double *p_result) {
   assert(p_input_buf);
   assert(p_result);

   grplot_input_buf_status_t retval =  grplot_input_buf_empty_buf;

   double *p_buf_ptr =  p_input_buf->buf;

   for (unsigned long i =  0; i < p_input_buf->bufLen; i++) {
      if (retval) {
         *p_result =  *p_buf_ptr;
         retval =  grplot_input_buf_ok;
      } else if (*p_result < *p_buf_ptr) {
         *p_result =  *p_buf_ptr;
      }
      p_buf_ptr++;
   }

   return retval;
}

grplot_input_buf_status_t
grplot_input_buf_get_min(const grplot_input_buf_t *p_input_buf, double *p_result) {
   assert(p_input_buf);
   assert(p_result);

   grplot_input_buf_status_t retval =  grplot_input_buf_empty_buf;

   double *p_buf_ptr =  p_input_buf->buf;

   for (unsigned long i =  0; i < p_input_buf->bufLen; i++) {
      if (retval) {
         *p_result =  *p_buf_ptr;
         retval =  grplot_input_buf_ok;
      } else if (*p_result > *p_buf_ptr) {
         *p_result =  *p_buf_ptr;
      }
      p_buf_ptr++;
   }

   return retval;
}

grplot_input_buf_status_t
grplot_input_buf_normalize(grplot_input_buf_t *p_input_buf, double minVal, double maxVal) {
   assert(p_input_buf);
   assert(maxVal > minVal);
   grplot_input_buf_status_t retval =  grplot_input_buf_ok;

   double diffVal =  maxVal - minVal;

   if (diffVal > 0.0) {
      for (unsigned long i =  0; i < p_input_buf->bufLen; i++) {
         assert(p_input_buf->buf[i] >= minVal - 1.0E-12);
         assert(p_input_buf->buf[i] <= maxVal + 1.0E-12);
   
         p_input_buf->buf[i] =  (p_input_buf->buf[i] - minVal) / diffVal;
      }
   } else {
      retval =  grplot_input_buf_zero_range;
   }

   return retval;
}

void
grplot_input_buf_destroy(grplot_input_buf_t *p_input_buf) {
   assert(p_input_buf);
}
