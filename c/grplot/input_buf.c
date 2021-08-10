#include <assert.h>
#include <math.h>

#include "input_buf.h"

int
grplot_input_buf_init(grplot_input_buf_t *input_buf, double *buf, unsigned nrRows, unsigned nrCols, double radius) {
   assert(input_buf);
   assert(buf);

   int retval =  0;

   input_buf->nrRows =  nrRows;
   input_buf->nrCols =  nrCols;
   input_buf->radius =  radius;

   input_buf->bufLen =  nrRows * nrCols;

   input_buf->buf =  buf;

   for (unsigned i =  0; i < input_buf->bufLen; i++) {
      input_buf->buf[i] =  0.0;
   }

   return retval;
}

int
grplot_input_buf_plot_point(grplot_input_buf_t *input_buf, double x, double y, double weight) {
   assert(input_buf);
   assert(input_buf->buf);
   assert(x <= 1.0);
   assert(x >= 0.0);
   assert(y <= 1.0);
   assert(y >= 0.0);

   int retval =  0;

   double *ptr =  input_buf->buf;
   for (int pixelY =  0; pixelY < input_buf->nrRows; pixelY) {

      double double_pixelY =  (double) pixelY / (double) input_buf->nrRows - y;

      for (int pixelX =  0; pixelX < input_buf->nrCols; pixelX) {

         double double_pixelX =  (double) pixelX / (double) input_buf->nrCols - x;

         *(ptr++) +=
            weight * exp((- double_pixelX * double_pixelX - double_pixelY * double_pixelY) / input_buf->radius);

      }
   }

   return retval;
}

void
grplot_input_buf_destroy(grplot_input_buf_t *input_buf) {
   assert(input_buf);
}
