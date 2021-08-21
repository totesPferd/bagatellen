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

   return retval;
}

