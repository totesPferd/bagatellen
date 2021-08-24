#include <assert.h>

#include "color_diff.h"
#include "diagram.h"
#include "input_buf_by_mgmt.h"

static int
normalize(
      grplot_input_buf_mgmt_t * );

int
grplot_diagram_init(
      grplot_diagram_t *pDiagram
   ,  DATA32 color
   ,  Imlib_Font legendFont
   ,  unsigned nrItem
   ,  grplot_axis_t *pXAxis
   ,  grplot_axis_t *pYAxis ) {
   assert(pDiagram);

   int retval =  0;

   pDiagram->pXAxis =  pXAxis;
   pDiagram->pYAxis =  pYAxis;
   pDiagram->backgroundColor =  color;

   grplot_input_buf_mgmt_init(
         &(pDiagram->inputBufMgmt)
      ,  pXAxis->nrPixels
      ,  pYAxis->nrPixels
      ,  nrItem );
   grplot_legend_init(
         &(pDiagram->legend)
      ,  legendFont
      ,  nrItem );

   return retval;
}

int
grplot_diagram_item_init(
      grplot_diagram_t *pDiagram
   ,  DATA32 color
   ,  char *text
   ,  unsigned index ) {
   assert(pDiagram);

   int retval =  0;

   {
      double *p_color;
      grplot_input_buf_mgmt_get_color(&(pDiagram->inputBufMgmt), &p_color, index);
      grplot_color_diff_encode(p_color, pDiagram->backgroundColor, color);
   }
   grplot_legend_inscription_init(
         &(pDiagram->legend)
      ,  text
      ,  color
      ,  index );

   return retval;
}

int
grplot_diagram_plot_point(
      grplot_diagram_t *pDiagram
   ,  grplot_axis_val_t x
   ,  grplot_axis_val_t y
   ,  double w
   ,  unsigned index
   ,  double radius ) {
   assert(pDiagram);

   int retval =  0;

   int isInRange;
   grplot_axis_is_inRange(pDiagram->pXAxis, &isInRange, x);
   if (isInRange) {
      grplot_axis_is_inRange(pDiagram->pYAxis, &isInRange, y);
   }

   if (isInRange) {
      grplot_input_buf_t inpBuf;
      grplot_input_buf_by_mgmt_init(
            &(pDiagram->inputBufMgmt)
         ,  &inpBuf
         ,  index );
      double xDouble, yDouble;
      grplot_axis_get_double(pDiagram->pXAxis, &xDouble, x);
      grplot_axis_get_double(pDiagram->pYAxis, &yDouble, y);
      grplot_input_buf_plot_point(&inpBuf, xDouble, yDouble, w, radius);
   }

   return retval;
}


int
grplot_diagram_prepare(
      grplot_diagram_t *pDiagram ) {
   assert(pDiagram);

   int retval =  0;

   return retval;
}


int
grplot_diagram_draw(
      grplot_diagram_t *pDiagram
   ,  unsigned originX
   ,  unsigned originY ) {
   assert(pDiagram);

   int retval =  0;

   return retval;
}

void
grplot_diagram_destroy(
      grplot_diagram_t *pDiagram ) {
   assert(pDiagram);

   grplot_legend_destroy(&(pDiagram->legend));
   grplot_input_buf_mgmt_destroy(&(pDiagram->inputBufMgmt));
}

static int
normalize(
     grplot_input_buf_mgmt_t *pInpBufMgmt) {
   assert(pInpBufMgmt);

   int retval =  0;

   for (unsigned index =  0;  index < pInpBufMgmt->nrInpBufs; index++) {
      grplot_input_buf_t inpBuf;
      grplot_input_buf_by_mgmt_init(
            pInpBufMgmt
         ,  &inpBuf
         ,  index );
      {
         double minVal;
         grplot_input_buf_get_min(&inpBuf, &minVal);
   
         double maxVal;
         grplot_input_buf_get_max(&inpBuf, &maxVal);
   
         grplot_input_buf_normalize(&inpBuf, minVal, maxVal);
      }
   }

   return retval;
}

