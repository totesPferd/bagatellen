#include <assert.h>

#include "inscription.h"

int
grplot_inscription_init(
      grplot_inscription_t *pInscription
   ,  char *text
   ,  int width
   ,  int height ) {
   assert(pInscription);
   assert(text);

   int retval =  0;

   pInscription->text =  text;
   pInscription->width =  width;
   pInscription->height =  height;

   return retval;
}

int
grplot_inscription_position_inscription_init(
      grplot_inscription_positional_inscription_t *pPositionalInscription
   ,  char *text
   ,  int width
   ,  int height
   ,  unsigned positionPerPixel ) {
   assert(pPositionalInscription);
   assert(text);

   int retval =  grplot_inscription_init(
         &(pPositionalInscription->inscription)
      ,  text
      ,  width
      ,  height );
   pPositionalInscription->positionPerPixel =  positionPerPixel;

   return retval;
}

