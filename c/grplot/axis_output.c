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
   pValInscription->realValPerPixel =
         pAxis->axisType == grplot_axis_x_axis
      ?  pValInscription->valPerPixel
      :  pAxis->nrPixels - pValInscription->valPerPixel;

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

   grplot_axis_output_val_inscription_init(
         &(pAxisOutput->axisSpec)
      ,  pAxisOutput->inscriptions
      ,  inscriptionFont
      ,  min );

   grplot_axis_output_val_inscription_init(
         &(pAxisOutput->axisSpec)
      ,  &(pAxisOutput->upperInscription)
      ,  inscriptionFont
      ,  max );

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
         ,  &((pAxisOutput->upperInscription).inscription)
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
