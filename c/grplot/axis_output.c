#include <assert.h>
#include <stdlib.h>

#include "axis_output.h"

static int
get_inscription_sum(
      int *
   ,  unsigned
   ,  const grplot_inscription_t *
   ,  const grplot_inscription_positional_inscription_t * );

static int
get_inscriptions(grplot_axis_output_t *);

int
grplot_axis_output_positional_inscription_init(
      const grplot_axis_t *pAxis
   ,  grplot_inscription_positional_inscription_t *pPositionalInscription
   ,  Imlib_Font font
   ,  grplot_axis_val_t val) {
   assert(pAxis);
   assert(pPositionalInscription);

   char *text;
   grplot_axis_get_string(pAxis, &text, val);
   int retval =  grplot_inscription_init(
         &(pPositionalInscription->inscription)
      ,  font
      ,  text );

   double distance;
   grplot_axis_get_double(pAxis, &distance, val);
   pPositionalInscription->positionPerPixel =  (unsigned) (distance * (double) pAxis->nrPixels);

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
   ,  DATA32 lineColor
   ,  unsigned maxExt
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
   pAxisOutput->lineColor =  lineColor;
   pAxisOutput->maxExt =  maxExt;
   pAxisOutput->nrInscriptions =  1;
   grplot_inscription_init(
         &(pAxisOutput->label)
      ,  labelFont
      ,  label );

   grplot_axis_output_positional_inscription_init(
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
      grplot_inscription_init(
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
            grplot_inscription_set_color(pAxisOutput->lineColor);
            imlib_image_draw_line(originX, originY, originX, pAxisOutput->maxExt, 0);
         }
         {
            int x =
                  originX
               +  (pAxisOutput->axisSpec).nrPixels
               -  ((pAxisOutput->upperInscription).height >> 1);
            int y =  originY;
            grplot_inscription_draw_vertical(
                  &(pAxisOutput->upperInscription)
               ,  pAxisOutput->inscriptionColor
               ,  pAxisOutput->inscriptionFont
               ,  x
               ,  y );
         }
         {
            int x =  originX + (pAxisOutput->axisSpec).nrPixels;
            grplot_inscription_set_color(pAxisOutput->lineColor);
            imlib_image_draw_line(x, originY, x, pAxisOutput->maxExt, 0);
         }
         for (unsigned i =  0; i < pAxisOutput->nrInscriptions; i++) {
            {
               int x =
                     originX
                  +  (pAxisOutput->inscriptions)[i].positionPerPixel;
                  -  ((pAxisOutput->inscriptions)[i].inscription.height >> 1);
               int y =  originY;
               grplot_inscription_draw_LB_vertical(
                     &((pAxisOutput->inscriptions)[i])
                  ,  pAxisOutput->inscriptionColor
                  ,  pAxisOutput->inscriptionFont
                  ,  x
                  ,  y );
            }
            {
               int x =
                     originX
                  +  (pAxisOutput->inscriptions)[i].positionPerPixel;
               grplot_inscription_set_color(pAxisOutput->lineColor);
               imlib_image_draw_line(x, originY, x, pAxisOutput->maxExt, 0);
            }
         }
         {
            int x =  originX + (pAxisOutput->axisSpec).nrPixels;
            int y =  originY - (pAxisOutput->label).height;
            grplot_inscription_draw_horizontal(
                  &(pAxisOutput->label)
               ,  pAxisOutput->labelColor
               ,  pAxisOutput->labelFont
               ,  x
               ,  y );
         }
      }
      break;

      case grplot_axis_y_axis: {
         {
            int x =  originX - (pAxisOutput->upperInscription).width;
            int y =
                  originY
               -  (pAxisOutput->axisSpec).nrPixels
               -  ((pAxisOutput->upperInscription).height >> 1);
            grplot_inscription_draw_horizontal(
                  &(pAxisOutput->upperInscription)
               ,  pAxisOutput->inscriptionColor
               ,  pAxisOutput->inscriptionFont
               ,  x
               ,  y );
         }
         {
            int y =
                  originY
               -  (pAxisOutput->axisSpec).nrPixels;
            grplot_inscription_set_color(pAxisOutput->lineColor);
            imlib_image_draw_line(originX, y, pAxisOutput->maxExt, y, 0);
         }
         for (unsigned i =  0; i < pAxisOutput->nrInscriptions; i++) {
            {
               int x =  originX - (pAxisOutput->inscriptions)[i].inscription.width;
               int y =
                     originY
                  -  (pAxisOutput->inscriptions)[i].positionPerPixel
                  -  ((pAxisOutput->inscriptions)[i].inscription.height >> 1);
               grplot_inscription_draw_LT_horizontal(
                     &((pAxisOutput->inscriptions)[i])
                  ,  pAxisOutput->inscriptionColor
                  ,  pAxisOutput->inscriptionFont
                  ,  x
                  ,  y );
            }
            {
               int y =
                     originY
                  -  (pAxisOutput->inscriptions)[i].positionPerPixel;
               grplot_inscription_set_color(pAxisOutput->lineColor);
               imlib_image_draw_line(originX, y, pAxisOutput->maxExt, y, 0);
            }
         }
         {
            int x =  originX;
            int y =  originY - (pAxisOutput->axisSpec).nrPixels - (pAxisOutput->label).width;
            grplot_inscription_draw_vertical(
                  &(pAxisOutput->label)
               ,  pAxisOutput->labelColor
               ,  pAxisOutput->labelFont
               ,  x
               ,  y );
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
      int *pResult
   ,  unsigned positionPerPixel
   ,  const grplot_inscription_t *pA
   ,  const grplot_inscription_positional_inscription_t *pVB) {
   assert(pResult);
   assert(pA);
   assert(pVB);

   int retval =  0;

   *pResult =
         positionPerPixel
      -  pVB->positionPerPixel
      -  ((pA->height + (pVB->inscription).height) >> 1);

   return retval;
}

static int
get_inscriptions(
      grplot_axis_output_t *pAxisOutput ) {
   assert(pAxisOutput);

   int retval =  0;

   int isRunning =  1;
   grplot_axis_val_t currentVal =  (pAxisOutput->axisSpec).min;

   while (isRunning) {
      int space;
      get_inscription_sum(
            &space
         ,  (pAxisOutput->axisSpec).nrPixels
         ,  &(pAxisOutput->upperInscription)
         ,  &((pAxisOutput->inscriptions[pAxisOutput->nrInscriptions - 1])) );

      if (space < 0) {
         isRunning =  0;
         pAxisOutput->nrInscriptions--;
      }

      if (isRunning) {
         grplot_axis_step_t step;
         grplot_axis_step_init(&(pAxisOutput->axisSpec), &step);
   
         int isInnerRunning =  1;
         grplot_axis_val_t val =  currentVal;
         while (isInnerRunning) {
            grplot_axis_next_val(
                  &(pAxisOutput->axisSpec)
               ,  &step
               ,  &val );
            grplot_axis_output_positional_inscription_init(
                  &(pAxisOutput->axisSpec)
               ,  pAxisOutput->inscriptions + pAxisOutput->nrInscriptions
               ,  pAxisOutput->inscriptionFont
               ,  val );
            int innerSpace;
            get_inscription_sum(
                  &innerSpace
               ,  (pAxisOutput->inscriptions[pAxisOutput->nrInscriptions]).positionPerPixel
               ,  &((pAxisOutput->inscriptions[pAxisOutput->nrInscriptions]).inscription)
               ,  &((pAxisOutput->inscriptions[pAxisOutput->nrInscriptions - 1])) );
            if (innerSpace > 0) {
               isInnerRunning =  0;
            } else {
               int errorMode =  grplot_axis_step_next(&(pAxisOutput->axisSpec), &step);
               if (errorMode) {
                  retval =  3;
                  isInnerRunning =  0;
                  isRunning =  0;
               }
            }
            currentVal =  val;
         }
         if (isRunning) {
            pAxisOutput->nrInscriptions++;
            if (pAxisOutput->nrInscriptions > MAX_NR_INSCRIPTIONS) {
               retval =  2;
               isRunning =  0;
               pAxisOutput->nrInscriptions =  MAX_NR_INSCRIPTIONS;
            }
         }
      }
   }

   return retval;
}
