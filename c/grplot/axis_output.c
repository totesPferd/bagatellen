#include <assert.h>

#include "axis_output.h"

int
grplot_axis_output_inscription_init(grplot_axis_output_inscription_t *pOutputInscription, Imlib_Font font, const char *text) {
   assert(pOutputInscription);

   int retval =  0;

   pOutputInscription->text =  text;

   imlib_context_set_font(font);
   imlib_get_text_size(text, &(pOutputInscription->width), &(pOutputInscription->height));

   return retval;
}
