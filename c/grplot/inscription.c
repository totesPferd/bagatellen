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

int
grplot_inscription_draw_LB_horizontal(
      const grplot_inscription_t *pInscription
   ,  DATA32 color
   ,  Imlib_Font font
   ,  int x
   ,  int y ) {
   assert(pInscription);

   int retval =  grplot_inscription_draw_LT_horizontal(
         pInscription
      ,  color
      ,  font
      ,  x
      ,  y - pInscription->height );

   return retval;
}

int
grplot_inscription_draw_LB_vertical(
      const grplot_inscription_t *pInscription
   ,  DATA32 color
   ,  Imlib_Font font
   ,  int x
   ,  int y ) {
   assert(pInscription);

   int retval =  0;

   grplot_inscription_set_color(color);
   imlib_context_set_direction(IMLIB_TEXT_TO_DOWN);
   imlib_context_set_font(font);
   imlib_text_draw(x, y, pInscription->text);

   return retval;
}

int
grplot_inscription_draw_LC_vertical(
      const grplot_inscription_t *pInscription
   ,  DATA32 color
   ,  Imlib_Font font
   ,  int x
   ,  int y ) {
   assert(pInscription);

   int retval =  grplot_inscription_draw_LB_vertical(
         pInscription
      ,  color
      ,  font
      ,  x - (pInscription->height >> 1)
      ,  y );

   return retval;
}

int
grplot_inscription_draw_LT_horizontal(
      const grplot_inscription_t *pInscription
   ,  DATA32 color
   ,  Imlib_Font font
   ,  int x
   ,  int y ) {
   assert(pInscription);

   int retval =  0;

   grplot_inscription_set_color(color);
   imlib_context_set_direction(IMLIB_TEXT_TO_RIGHT);
   imlib_context_set_font(font);
   imlib_text_draw(x, y, pInscription->text);

   return retval;
}

int
grplot_inscription_draw_RB_vertical(
      const grplot_inscription_t *pInscription
   ,  DATA32 color
   ,  Imlib_Font font
   ,  int x
   ,  int y ) {
   assert(pInscription);

   int retval =  grplot_inscription_draw_LB_vertical(
         pInscription
      ,  color
      ,  font
      ,  x
      ,  y - pInscription->width );

   return retval;
}

int
grplot_inscription_draw_RC_horizontal(
      const grplot_inscription_t *pInscription
   ,  DATA32 color
   ,  Imlib_Font font
   ,  int x
   ,  int y ) {
   assert(pInscription);

   int retval =  grplot_inscription_draw_LT_horizontal(
         pInscription
      ,  color
      ,  font
      ,  x - pInscription->width
      ,  y - (pInscription->height >> 1) );

   return retval;
}

int
grplot_inscription_draw_positional_LC_vertical(
      const grplot_inscription_positional_inscription_t *pPositionalInscription
   ,  DATA32 color
   ,  Imlib_Font font
   ,  int x
   ,  int y ) {
   assert(pPositionalInscription);

   int retval =  grplot_inscription_draw_LC_vertical(
         &(pPositionalInscription->inscription)
      ,  color
      ,  font
      ,  x + pPositionalInscription->positionPerPixel
      ,  y );

   return retval;
}

int
grplot_inscription_draw_positional_LB_horizontal(
      const grplot_inscription_positional_inscription_t *pPositionalInscription
   ,  DATA32 color
   ,  Imlib_Font font
   ,  int x
   ,  int y ) {
   assert(pPositionalInscription);

   int retval =  grplot_inscription_draw_LB_horizontal(
         &(pPositionalInscription->inscription)
      ,  color
      ,  font
      ,  x
      ,  y - pPositionalInscription->positionPerPixel );

   return retval;
}

int
grplot_inscription_draw_positional_LT_horizontal(
      const grplot_inscription_positional_inscription_t *pPositionalInscription
   ,  DATA32 color
   ,  Imlib_Font font
   ,  int x
   ,  int y ) {
   assert(pPositionalInscription);

   int retval =  grplot_inscription_draw_LT_horizontal(
         &(pPositionalInscription->inscription)
      ,  color
      ,  font
      ,  x
      ,  y - pPositionalInscription->positionPerPixel );

   return retval;
}

int
grplot_inscription_draw_positional_RC_horizontal(
      const grplot_inscription_positional_inscription_t *pPositionalInscription
   ,  DATA32 color
   ,  Imlib_Font font
   ,  int x
   ,  int y ) {
   assert(pPositionalInscription);

   int retval =  grplot_inscription_draw_RC_horizontal(
         &(pPositionalInscription->inscription)
      ,  color
      ,  font
      ,  x
      ,  y - pPositionalInscription->positionPerPixel );

   return retval;
}
