#include <assert.h>

#include "inscription.h"

int
grplot_inscription_init(
      grplot_inscription_t *pInscription
   ,  Imlib_Font font
   ,  char *text) {
   assert(pInscription);
   assert(text);

   int retval =  0;

   pInscription->text =  text;

   imlib_context_set_font(font);
   imlib_get_text_size(text, &(pInscription->width), &(pInscription->height));

   return retval;
}

int
grplot_inscription_set_color(DATA32 color) {
   int retval =  0;
   imlib_context_set_color(
         ((unsigned char *) &color)[2]
      ,  ((unsigned char *) &color)[1]
      ,  ((unsigned char *) &color)[0]
      ,  ((unsigned char *) &color)[3] );

   return retval;
}
