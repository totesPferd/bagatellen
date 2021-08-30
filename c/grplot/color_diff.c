#include <assert.h>

#include "color_diff.h"

typedef unsigned char *p_color_channel_t;

grplot_color_diff_status_t
grplot_color_diff_encode(double *p_out, DATA32 background_pixel, DATA32 foreground_pixel) {
   assert(p_out);

   grplot_color_diff_status_t retval =  grplot_color_diff_ok;

   for (unsigned char i =  0; i < 4; i++) {
      p_out[i] =  (double) (((p_color_channel_t) &foreground_pixel)[i] - ((p_color_channel_t) &background_pixel)[i]);
   }

   return retval;
}

grplot_color_diff_status_t
grplot_color_diff_decode(DATA32 *p_color, const double *p_in, DATA32 background_pixel) {
   assert(p_color);
   assert(p_in);
   assert(p_in[0] >= - (double) ((p_color_channel_t) &background_pixel)[0]);
   assert(p_in[1] >= - (double) ((p_color_channel_t) &background_pixel)[1]);
   assert(p_in[2] >= - (double) ((p_color_channel_t) &background_pixel)[2]);
   assert(p_in[3] >= - (double) ((p_color_channel_t) &background_pixel)[3]);
   assert(p_in[0] + (double) ((p_color_channel_t) &background_pixel)[0] < 256.0);
   assert(p_in[1] + (double) ((p_color_channel_t) &background_pixel)[1] < 256.0);
   assert(p_in[2] + (double) ((p_color_channel_t) &background_pixel)[2] < 256.0);
   assert(p_in[3] + (double) ((p_color_channel_t) &background_pixel)[3] < 256.0);

   grplot_color_diff_status_t retval =  grplot_color_diff_ok;

   for (unsigned char i =  0; i < 4; i++) {
      ((unsigned char *) p_color)[i]
         =  (unsigned char) ((short) p_in[i] + (short) ((p_color_channel_t) &background_pixel)[i]);
   }

   return retval;
}


