#include <assert.h>
#include <stdlib.h>

#include "axis_output.h"

static grplot_axis_output_status_t
get_inscription_sum(
      int *
   ,  unsigned
   ,  const grplot_inscription_t *
   ,  const grplot_inscription_positional_inscription_t * );

static grplot_axis_output_status_t
get_length(
      grplot_axis_output_t *);

static grplot_axis_output_status_t
get_width(
      grplot_axis_output_t *);

static grplot_axis_output_status_t
get_inscriptions(grplot_axis_output_t *);

grplot_axis_output_status_t
grplot_axis_output_positional_inscription_init(
      const grplot_axis_t *pAxis
   ,  grplot_inscription_positional_inscription_t *pPositionalInscription
   ,  Imlib_Font font
   ,  grplot_axis_val_t val) {
   assert(pAxis);
   assert(pPositionalInscription);

   grplot_axis_output_status_t retval =  grplot_axis_output_ok;

   char *text;
   grplot_axis_get_string(pAxis, &text, val);
   grplot_inscription_init(
         &(pPositionalInscription->inscription)
      ,  font
      ,  text );

   double distance;
   grplot_axis_get_double(pAxis, &distance, val);
   pPositionalInscription->positionPerPixel =  (unsigned) (distance * (double) pAxis->nrPixels);

   return retval;
}

void
grplot_axis_output_positional_inscription_destroy(
      grplot_inscription_positional_inscription_t *pPositionalInscription ) {
   assert(pPositionalInscription);

   free((pPositionalInscription->inscription).text);
}

grplot_axis_output_status_t
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
   ,  grplot_axis_val_t min
   ,  grplot_axis_val_t max
   ,  const char *label ) {
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

   grplot_axis_output_status_t retval =  grplot_axis_output_ok;

   {
      grplot_axis_status_t errorMode =  grplot_axis_init(
            &(pAxisOutput->axisSpec)
         ,  axisType
         ,  scaleType
         ,  nrPixels
         ,  min
         ,  max );
      if (errorMode == grplot_axis_zero_range) {
         retval =  grplot_axis_output_zero_range;
      }
   }
      
   pAxisOutput->inscriptionFont =  inscriptionFont;
   pAxisOutput->inscriptionColor =  inscriptionColor;
   pAxisOutput->labelFont =  labelFont;
   pAxisOutput->labelColor =  labelColor;
   pAxisOutput->lineColor =  lineColor;
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

   if (retval == grplot_axis_output_ok) {
      retval =  get_inscriptions(pAxisOutput);
   }

   get_length(pAxisOutput);
   get_width(pAxisOutput);

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

grplot_axis_output_status_t
grplot_axis_output_draw(
      grplot_axis_output_t *pAxisOutput
   ,  unsigned width
   ,  unsigned maxExt
   ,  int originX
   ,  int originY ) {
   assert(pAxisOutput);
   assert(originX <= width);

   grplot_axis_output_status_t retval =  grplot_axis_output_ok;

   switch ((pAxisOutput->axisSpec).axisType) {

      case grplot_axis_x_axis: {
         {
            grplot_inscription_set_color(pAxisOutput->lineColor);
            imlib_image_draw_line(originX, originY, originX, maxExt, 0);
         }
         grplot_inscription_draw_LC_vertical(
               &(pAxisOutput->upperInscription)
            ,  pAxisOutput->inscriptionColor
            ,  pAxisOutput->inscriptionFont
            ,  originX + (pAxisOutput->axisSpec).nrPixels
            ,  originY );
         {
            int x =  originX + (pAxisOutput->axisSpec).nrPixels;
            grplot_inscription_set_color(pAxisOutput->lineColor);
            imlib_image_draw_line(x, originY, x, maxExt, 0);
         }
         for (unsigned i =  0; i < pAxisOutput->nrInscriptions; i++) {
            grplot_inscription_draw_positional_LC_vertical(
                  &((pAxisOutput->inscriptions)[i])
               ,  pAxisOutput->inscriptionColor
               ,  pAxisOutput->inscriptionFont
               ,  originX
               ,  originY );
            {
               int x =
                     originX
                  +  (pAxisOutput->inscriptions)[i].positionPerPixel;
               grplot_inscription_set_color(pAxisOutput->lineColor);
               imlib_image_draw_line(x, originY, x, maxExt, 0);
            }
         }
         grplot_inscription_draw_LB_horizontal(
               &(pAxisOutput->label)
            ,  pAxisOutput->labelColor
            ,  pAxisOutput->labelFont
            ,  originX + (pAxisOutput->axisSpec).nrPixels
            ,  originY );
      }
      break;

      case grplot_axis_y_axis: {
         {
            grplot_inscription_set_color(pAxisOutput->lineColor);
            imlib_image_draw_line(originX, originY, maxExt, originY, 0);
         }
         grplot_inscription_draw_RC_horizontal(
               &(pAxisOutput->upperInscription)
            ,  pAxisOutput->inscriptionColor
            ,  pAxisOutput->inscriptionFont
            ,  originX
            ,  originY - (pAxisOutput->axisSpec).nrPixels );
         {
            int y =
                  originY
               -  (pAxisOutput->axisSpec).nrPixels;
            grplot_inscription_set_color(pAxisOutput->lineColor);
            imlib_image_draw_line(originX, y, maxExt, y, 0);
         }
         for (unsigned i =  0; i < pAxisOutput->nrInscriptions; i++) {
            grplot_inscription_draw_positional_RC_horizontal(
                  &((pAxisOutput->inscriptions)[i])
               ,  pAxisOutput->inscriptionColor
               ,  pAxisOutput->inscriptionFont
               ,  originX
               ,  originY );
            {
               int y =
                     originY
                  -  (pAxisOutput->inscriptions)[i].positionPerPixel;
               grplot_inscription_set_color(pAxisOutput->lineColor);
               imlib_image_draw_line(originX, y, maxExt, y, 0);
            }
         }
         grplot_inscription_draw_RB_vertical(
               &(pAxisOutput->label)
            ,  pAxisOutput->labelColor
            ,  pAxisOutput->labelFont
            ,  originX
            ,  originY - (pAxisOutput->axisSpec).nrPixels );
      }
      break;

      default: {
         assert(0);
      }
   }

   return retval;
}

static grplot_axis_output_status_t
get_inscription_sum(
      int *pResult
   ,  unsigned positionPerPixel
   ,  const grplot_inscription_t *pA
   ,  const grplot_inscription_positional_inscription_t *pVB) {
   assert(pResult);
   assert(pA);
   assert(pVB);

   grplot_axis_output_status_t retval =  grplot_axis_output_ok;

   *pResult =
         positionPerPixel
      -  pVB->positionPerPixel
      -  ((pA->height + (pVB->inscription).height) >> 1);

   return retval;
}

static grplot_axis_output_status_t
get_length(
      grplot_axis_output_t *pAxisOutput ) {
   assert(pAxisOutput);

   grplot_axis_output_status_t retval =  grplot_axis_output_ok;

   pAxisOutput->length =  (pAxisOutput->axisSpec).nrPixels + (pAxisOutput->label).width;

   return retval;
}

static grplot_axis_output_status_t
get_width(
      grplot_axis_output_t *pAxisOutput ) {
   assert(pAxisOutput);

   grplot_axis_output_status_t retval =  grplot_axis_output_ok;

   pAxisOutput->width =  (pAxisOutput->upperInscription).width;
   for (unsigned int i =  0; i < pAxisOutput->nrInscriptions; i++) {
      unsigned width =  (pAxisOutput->inscriptions)[i].inscription.width;
      if (width > pAxisOutput->width) {
         pAxisOutput->width =  width;
      }
   }

   return retval;
}

static grplot_axis_output_status_t
get_inscriptions(
      grplot_axis_output_t *pAxisOutput ) {
   assert(pAxisOutput);

   grplot_axis_output_status_t retval =  grplot_axis_output_ok;

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
               grplot_axis_status_t errorMode =  grplot_axis_step_next(&(pAxisOutput->axisSpec), &step);
               if (errorMode == grplot_axis_time_overflow) {
                  retval =  grplot_axis_output_time_overflow;
                  isInnerRunning =  0;
                  isRunning =  0;
               }
            }
            currentVal =  val;
         }
         if (isRunning) {
            pAxisOutput->nrInscriptions++;
            if (pAxisOutput->nrInscriptions > MAX_NR_INSCRIPTIONS) {
               retval =  grplot_axis_output_inscription_buf_exceeded;
               isRunning =  0;
               pAxisOutput->nrInscriptions =  MAX_NR_INSCRIPTIONS;
            }
         }
      }
   }

   return retval;
}
