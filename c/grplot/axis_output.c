#include <assert.h>
#include <stdlib.h>

#include "axis_output.h"

static int
get_inscription_sum(
      const grplot_axis_output_t *
   ,  unsigned *
   ,  const grplot_axis_output_inscription_t *
   ,  const grplot_axis_output_inscription_t * );

static int
get_inscriptions(grplot_axis_output_t *);

int
grplot_axis_output_inscription_init(grplot_axis_output_inscription_t *pOutputInscription, Imlib_Font font, char *text) {
   assert(pOutputInscription);
   assert(text);

   int retval =  0;

   pOutputInscription->text =  text;

   imlib_context_set_font(font);
   imlib_get_text_size(text, &(pOutputInscription->width), &(pOutputInscription->height));

   return retval;
}

int
grplot_axis_output_val_inscription_init(
      const grplot_axis_t *pAxis
   ,  grplot_axis_output_val_inscription_t *pValInscription
   ,  Imlib_Font font
   ,  grplot_axis_val_t val) {
   assert(pAxis);
   assert(pValInscription);

   char *text;
   grplot_axis_get_string(pAxis, &text, val);
   int retval =  grplot_axis_output_inscription_init(
         &(pValInscription->inscription)
      ,  font
      ,  text );

   double distance;
   grplot_axis_get_double(pAxis, &distance, val);
   pValInscription->valPerPixel =  (unsigned) (distance * (double) pAxis->nrPixels);

   return retval;
}

int
grplot_axis_output_init(
      grplot_axis_output_t *pAxisOutput
   ,  grplot_axis_type_t axisType
   ,  grplot_axis_scale_type_t scaleType
   ,  Imlib_Font inscriptionFont
   ,  DATA32 inscriptionColor
   ,  Imlib_Font labelFont
   ,  DATA32 labelColor
   ,  unsigned nrPixels
   ,  grplot_axis_val_t min
   ,  grplot_axis_val_t max
   ,  char *label ) {
   assert(pAxisOutput);
   assert(nrPixels > 0);
   assert(
         (
               scaleType != grplot_axis_linear
            && scaleType != grplot_axis_logarithm )
      || min.numeric < max.numeric );
   assert(
         scaleType != grplot_axis_logarithm
      || min.numeric > 0.0 );

   int retval =  0;

   grplot_axis_init(
         &(pAxisOutput->axisSpec)
      ,  axisType
      ,  scaleType
      ,  nrPixels
      ,  min
      ,  max );
   pAxisOutput->inscriptionFont =  inscriptionFont;
   pAxisOutput->inscriptionColor =  inscriptionColor;
   pAxisOutput->labelFont =  labelFont;
   pAxisOutput->labelColor =  labelColor;
   pAxisOutput->nrInscriptions =  1;
   grplot_axis_output_inscription_init(
         &(pAxisOutput->label)
      ,  labelFont
      ,  label );

   grplot_axis_output_val_inscription_init(
         &(pAxisOutput->axisSpec)
      ,  pAxisOutput->inscriptions
      ,  inscriptionFont
      ,  min );

   {
      char *inscriptionText;
      grplot_axis_get_string(
            &(pAxisOutput->axisSpec)
         ,  &inscriptionText
         ,  max );
      grplot_axis_output_inscription_init(
            &(pAxisOutput->upperInscription)
         ,  inscriptionFont
         ,  inscriptionText );
   }

   retval =  get_inscriptions(pAxisOutput);

   return retval;
}

void
grplot_axis_output_destroy(grplot_axis_output_t *pAxisOutput) {
   assert(pAxisOutput);

   free(pAxisOutput->upperInscription.text);
   for (unsigned i =  0; i < pAxisOutput->nrInscriptions; i++) {
      free((pAxisOutput->inscriptions)[i].inscription.text);
   }
}

int
grplot_axis_output_draw(
      grplot_axis_output_t *pAxisOutput
   ,  unsigned width
   ,  int originX
   ,  int originY ) {
   assert(pAxisOutput);
   assert(originX <= width);

   int retval =  0;

   switch ((pAxisOutput->axisSpec).axisType) {

      case grplot_axis_x_axis: {
         {
            int x =  originX + (pAxisOutput->axisSpec).nrPixels;
            int y =  originY - (pAxisOutput->label).height;
            imlib_context_set_color(
                  ((unsigned char *) &(pAxisOutput->labelColor))[1]
               ,  ((unsigned char *) &(pAxisOutput->labelColor))[2]
               ,  ((unsigned char *) &(pAxisOutput->labelColor))[3]
               ,  ((unsigned char *) &(pAxisOutput->labelColor))[0] );
            imlib_context_set_font(pAxisOutput->labelFont);
            imlib_context_set_direction(IMLIB_TEXT_TO_RIGHT);
            imlib_text_draw(x, y, (pAxisOutput->label).text);
         }
         {
            int x =
                  originX
               +  (pAxisOutput->axisSpec).nrPixels
               +  (pAxisOutput->upperInscription).height >> 1;
            int y =  originY;
            imlib_context_set_color(
                  ((unsigned char *) &(pAxisOutput->inscriptionColor))[1]
               ,  ((unsigned char *) &(pAxisOutput->inscriptionColor))[2]
               ,  ((unsigned char *) &(pAxisOutput->inscriptionColor))[3]
               ,  ((unsigned char *) &(pAxisOutput->inscriptionColor))[0] );
            imlib_context_set_font(pAxisOutput->inscriptionFont);
            imlib_context_set_direction(IMLIB_TEXT_TO_DOWN);
            imlib_text_draw(x, y, (pAxisOutput->upperInscription).text);
         }
         for (unsigned i =  0; i < pAxisOutput->nrInscriptions; i++) {
            int x =
                  originX
               +  (pAxisOutput->inscriptions)[i].valPerPixel;
               +  (pAxisOutput->inscriptions)[i].inscription.height >> 1;
            int y =  originY;
            imlib_text_draw(x, y, (pAxisOutput->inscriptions)[i].inscription.text);
         }
      }
      break;

      case grplot_axis_y_axis: {
         {
            int x =  originX + (pAxisOutput->label).height;
            int y =  originY - (pAxisOutput->axisSpec).nrPixels - (pAxisOutput->label).width;
            imlib_context_set_color(
                  ((unsigned char *) &(pAxisOutput->labelColor))[1]
               ,  ((unsigned char *) &(pAxisOutput->labelColor))[2]
               ,  ((unsigned char *) &(pAxisOutput->labelColor))[3]
               ,  ((unsigned char *) &(pAxisOutput->labelColor))[0] );
            imlib_context_set_font(pAxisOutput->labelFont);
            imlib_context_set_direction(IMLIB_TEXT_TO_DOWN);
            imlib_text_draw(x, y, (pAxisOutput->label).text);
         }
         {
            int x =  originX - (pAxisOutput->upperInscription).width;
            int y =
                  originY
               -  (pAxisOutput->axisSpec).nrPixels
               -  (pAxisOutput->upperInscription).height >> 1;
            imlib_context_set_color(
                  ((unsigned char *) &(pAxisOutput->inscriptionColor))[1]
               ,  ((unsigned char *) &(pAxisOutput->inscriptionColor))[2]
               ,  ((unsigned char *) &(pAxisOutput->inscriptionColor))[3]
               ,  ((unsigned char *) &(pAxisOutput->inscriptionColor))[0] );
            imlib_context_set_font(pAxisOutput->inscriptionFont);
            imlib_context_set_direction(IMLIB_TEXT_TO_RIGHT);
            imlib_text_draw(x, y, (pAxisOutput->upperInscription).text);
         }
         for (unsigned i =  0; i < pAxisOutput->nrInscriptions; i++) {
            int x =  originX - (pAxisOutput->inscriptions)[i].inscription.width;
            int y =
                  originY
               -  (pAxisOutput->inscriptions)[i].valPerPixel
               -  (pAxisOutput->inscriptions)[i].inscription.height >> 1;
            imlib_context_set_font(pAxisOutput->inscriptionFont);
            imlib_context_set_direction(IMLIB_TEXT_TO_RIGHT);
            imlib_text_draw(x, y, (pAxisOutput->inscriptions)[i].inscription.text);
         }
      }
      break;

      default: {
         assert(0);
      }
   }

   return retval;
}

static int
get_inscription_sum(
      const grplot_axis_output_t *pAxisOutput
   ,  unsigned *pResult
   ,  const grplot_axis_output_inscription_t *pA
   ,  const grplot_axis_output_inscription_t *pB) {
   assert(pAxisOutput);
   assert(pResult);
   assert(pA);
   assert(pB);

   int retval =  0;

   *pResult =  (pA->height + pB->height) >> 1;

   return retval;
}

static int
get_inscriptions(
      grplot_axis_output_t *pAxisOutput ) {
   assert(pAxisOutput);

   int retval =  0;

   int isRunning =  1;
   int isFirstTime =  1;
   grplot_axis_val_t currentVal =  (pAxisOutput->axisSpec).min;
   unsigned currentHeight =  0;

   while (isRunning) {
      unsigned space;
      get_inscription_sum(
            pAxisOutput
         ,  &space
         ,  &(pAxisOutput->upperInscription)
         ,  &((pAxisOutput->inscriptions[pAxisOutput->nrInscriptions - 1]).inscription) );

      if (space < (pAxisOutput->axisSpec).nrPixels) {
         retval =  isFirstTime;
         isRunning =  0;
      }

      if (isRunning) {
         isFirstTime =  0;

         grplot_axis_step_t step;
         grplot_axis_step_init(&(pAxisOutput->axisSpec), &step);
   
         int isInnerRunning =  1;
         grplot_axis_val_t val =  currentVal;
         unsigned height;
         while (isInnerRunning) {
            grplot_axis_next_val(
                  &(pAxisOutput->axisSpec)
               ,  &step
               ,  &val );
            grplot_axis_output_val_inscription_init(
                  &(pAxisOutput->axisSpec)
               ,  pAxisOutput->inscriptions + pAxisOutput->nrInscriptions
               ,  pAxisOutput->inscriptionFont
               ,  val );
            unsigned innerSpace;
            get_inscription_sum(
                  pAxisOutput
               ,  &innerSpace
               ,  &((pAxisOutput->inscriptions[pAxisOutput->nrInscriptions]).inscription)
               ,  &((pAxisOutput->inscriptions[pAxisOutput->nrInscriptions - 1]).inscription) );
            height =  pAxisOutput->inscriptions[pAxisOutput->nrInscriptions].valPerPixel;
            if (innerSpace >= height - currentHeight) {
               isInnerRunning =  0;
            } else {
               int errorMode =  grplot_axis_step_next(&(pAxisOutput->axisSpec), &step);
               if (errorMode) {
                  retval =  3;
                  isInnerRunning =  0;
                  isRunning =  0;
               }
            }
         }
         currentVal =  val;
         currentHeight =  height;
      }

      pAxisOutput->nrInscriptions++;
      if (pAxisOutput->nrInscriptions > MAX_NR_INSCRIPTIONS) {
         retval =  2;
         isRunning =  0;
      }
   }

   return retval;
}
