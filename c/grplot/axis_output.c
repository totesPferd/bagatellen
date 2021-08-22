#include <assert.h>

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
grplot_axis_output_inscription_init(grplot_axis_output_inscription_t *pOutputInscription, Imlib_Font font, const char *text) {
   assert(pOutputInscription);

   int retval =  0;

   pOutputInscription->text =  text;

   imlib_context_set_font(font);
   imlib_get_text_size(text, &(pOutputInscription->width), &(pOutputInscription->height));

   return retval;
}

int
grplot_axis_output_init(
      grplot_axis_output_t *pAxisOutput
   ,  grplot_axis_type_t axisType
   ,  grplot_axis_scale_type_t scaleType
   ,  Imlib_Font inscriptionFont
   ,  Imlib_Font labelFont
   ,  unsigned nrPixels
   ,  grplot_axis_val_t min
   ,  grplot_axis_val_t max
   ,  const char *label ) {
   assert(pAxisOutput);

   int retval =  0;

   grplot_axis_init(
         &(pAxisOutput->axisSpec)
      ,  axisType
      ,  scaleType
      ,  nrPixels
      ,  min
      ,  max );
   pAxisOutput->inscriptionFont =  inscriptionFont;
   pAxisOutput->labelFont =  labelFont;
   pAxisOutput->nrInscriptions =  1;
   grplot_axis_output_inscription_init(
         &(pAxisOutput->label)
      ,  labelFont
      ,  label );

   {
      char *inscriptionText;
      grplot_axis_get_string(
            &(pAxisOutput->axisSpec)
         ,  &inscriptionText
         ,  min );

      grplot_axis_output_inscription_init(
         pAxisOutput->inscriptions
      ,  inscriptionFont
      ,  inscriptionText );
   }

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
         ,  &(pAxisOutput->inscriptions[pAxisOutput->nrInscriptions - 1]) );

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
            char *inscriptionText;
            grplot_axis_get_string(
                  &(pAxisOutput->axisSpec)
               ,  &inscriptionText
               ,  val );
            grplot_axis_output_inscription_init(
                  pAxisOutput->inscriptions + pAxisOutput->nrInscriptions
               ,  pAxisOutput->inscriptionFont
               ,  inscriptionText );
            unsigned innerSpace;
            get_inscription_sum(
                  pAxisOutput
               ,  &innerSpace
               ,  &(pAxisOutput->inscriptions[pAxisOutput->nrInscriptions])
               ,  &(pAxisOutput->inscriptions[pAxisOutput->nrInscriptions - 1]) );
            double normalizedVal;
            grplot_axis_get_double(
                  &(pAxisOutput->axisSpec)
               ,  &normalizedVal
               ,  val );
            grplot_axis_getRawDistancePerPixel(
                  &(pAxisOutput->axisSpec)
               ,  &height
               ,  normalizedVal );
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
