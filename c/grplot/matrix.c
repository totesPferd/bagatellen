#include <assert.h>
#include <stdlib.h>

#include "matrix.h"

int
grplot_matrix_init(
      grplot_matrix_t *pMatrix
   ,  unsigned nrX
   ,  unsigned nrY
   ,  unsigned xDistance
   ,  unsigned yDistance ) {
   assert(pMatrix);

   int retval =  0;

   pMatrix->xDistance =  xDistance;
   pMatrix->yDistance =  yDistance;
   pMatrix->nrX =  nrX;
   pMatrix->nrY =  nrY;
   pMatrix->nrAxis =  nrX + nrY;
   pMatrix->nrDiagram =  nrX * nrY;

   pMatrix->pAxisBuf =  (grplot_matrix_positional_axis_t *) malloc(sizeof(grplot_matrix_positional_axis_t) *
      (pMatrix->nrAxis));
   pMatrix->pDiagramBuf =  (grplot_diagram_t *) malloc(sizeof(grplot_diagram_t) * (pMatrix->nrDiagram));

   return retval;
}

int
grplot_matrix_get_positional_x_axis(
      const grplot_matrix_t *pMatrix
   ,  grplot_matrix_positional_axis_t **ppAxis
   ,  unsigned nr ) {
   assert(pMatrix);
   assert(nr < pMatrix->nrX);

   int retval =  0;

   *ppAxis =  &((pMatrix->pAxisBuf)[nr]);

   assert(((*ppAxis)->axis).axisSpec.axisType == grplot_axis_x_axis);

   return retval;
}

int 
grplot_matrix_get_positional_y_axis(
      const grplot_matrix_t *pMatrix
   ,  grplot_matrix_positional_axis_t **ppAxis
   ,  unsigned nr ) {
   assert(pMatrix);
   assert(nr < pMatrix->nrY);

   int retval =  0;

   *ppAxis =  &((pMatrix->pAxisBuf)[nr + (pMatrix->nrX)]);

   assert(((*ppAxis)->axis).axisSpec.axisType == grplot_axis_y_axis);

   return retval;
}

int
grplot_matrix_get_diagram(
      const grplot_matrix_t *pMatrix
   ,  grplot_diagram_t **ppDiagram
   ,  unsigned x
   ,  unsigned y ) {
   assert(pMatrix);
   assert(x < pMatrix->nrX);
   assert(y < pMatrix->nrY);

   *ppDiagram =  &((pMatrix->pDiagramBuf)[x + y * (pMatrix->nrX)]);

   int retval =  0;

   return retval;
}

int
grplot_matrix_x_axis_init(
      grplot_matrix_t *pMatrix
   ,  unsigned nr
   ,  grplot_axis_scale_type_t scaleType
   ,  Imlib_Font inscriptionFont
   ,  DATA32 inscriptionColor
   ,  Imlib_Font labelFont
   ,  DATA32 labelColor
   ,  unsigned nrPixels
   ,  DATA32 lineColor
   ,  grplot_axis_val_t min
   ,  grplot_axis_val_t max
   ,  char *label ) {
   assert(pMatrix);
   assert(nr < pMatrix->nrX);

   grplot_matrix_positional_axis_t *pPositionalAxis;
   grplot_matrix_get_positional_x_axis(pMatrix, &pPositionalAxis, nr);

   return grplot_axis_output_init(
         &(pPositionalAxis->axis)
      ,  grplot_axis_x_axis
      ,  scaleType
      ,  inscriptionFont
      ,  inscriptionColor
      ,  labelFont
      ,  labelColor
      ,  nrPixels
      ,  lineColor
      ,  min
      ,  max
      ,  label );
}

int
grplot_matrix_y_axis_init(
      grplot_matrix_t *pMatrix
   ,  unsigned nr
   ,  grplot_axis_scale_type_t scaleType
   ,  Imlib_Font inscriptionFont
   ,  DATA32 inscriptionColor
   ,  Imlib_Font labelFont
   ,  DATA32 labelColor
   ,  unsigned nrPixels
   ,  DATA32 lineColor
   ,  grplot_axis_val_t min
   ,  grplot_axis_val_t max
   ,  char *label ) {
   assert(pMatrix);
   assert(nr < pMatrix->nrY);

   grplot_matrix_positional_axis_t *pPositionalAxis;
   grplot_matrix_get_positional_y_axis(pMatrix, &pPositionalAxis, nr);

   return grplot_axis_output_init(
         &(pPositionalAxis->axis)
      ,  grplot_axis_y_axis
      ,  scaleType
      ,  inscriptionFont
      ,  inscriptionColor
      ,  labelFont
      ,  labelColor
      ,  nrPixels
      ,  lineColor
      ,  min
      ,  max
      ,  label );
}

int
grplot_matrix_diagram_init(
      grplot_matrix_t *pMatrix
   ,  DATA32 color
   ,  Imlib_Font legendFont
   ,  unsigned nrItem
   ,  unsigned nrX
   ,  unsigned nrY ) {
   assert(pMatrix);

   grplot_matrix_positional_axis_t *pPositionalXAxis;
   grplot_matrix_get_positional_x_axis(pMatrix, &pPositionalXAxis, nrX);

   grplot_matrix_positional_axis_t *pPositionalYAxis;
   grplot_matrix_get_positional_y_axis(pMatrix, &pPositionalYAxis, nrY);

   grplot_diagram_t *pDiagram;
   grplot_matrix_get_diagram(pMatrix, &pDiagram, nrX, nrY);

   return grplot_diagram_init(
         pDiagram
      ,  color
      ,  legendFont
      ,  nrItem
      ,  &(pPositionalXAxis->axis)
      ,  &(pPositionalYAxis->axis) );
}

int
grplot_matrix_prepare(
      grplot_matrix_t *pMatrix ) {
   assert(pMatrix);

   int retval =  0;

   for (unsigned i =  0; i < pMatrix->nrDiagram; i++) {
      grplot_diagram_prepare(&((pMatrix->pDiagramBuf)[i]));
   }

   return retval;
}

void
grplot_matrix_destroy(
      grplot_matrix_t *pMatrix ) {
   assert(pMatrix);

   for (unsigned i =  0; i < pMatrix->nrAxis; i++) {
      grplot_axis_output_destroy(&((pMatrix->pAxisBuf)[i].axis));
   }
   for (unsigned i =  0; i < pMatrix->nrDiagram; i++) {
      grplot_diagram_destroy(&((pMatrix->pDiagramBuf)[i]));
   }

   free(pMatrix->pAxisBuf);
   free(pMatrix->pDiagramBuf);
}
