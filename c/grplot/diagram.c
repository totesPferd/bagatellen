#include <assert.h>

#include "color_diff.h"
#include "diagram.h"
#include "input_buf_by_mgmt.h"
#include "output_buf_by_mgmt.h"

static int
normalize(
      grplot_input_buf_mgmt_t * );

int
grplot_diagram_init(
      grplot_diagram_t *pDiagram
   ,  DATA32 color
   ,  Imlib_Font legendFont
   ,  unsigned nrItem
   ,  grplot_axis_output_t *pXAxis
   ,  grplot_axis_output_t *pYAxis ) {
   assert(pDiagram);

   int retval =  0;

   pDiagram->pXAxis =  pXAxis;
   pDiagram->pYAxis =  pYAxis;
   pDiagram->backgroundColor =  color;

   grplot_input_buf_mgmt_init(
         &(pDiagram->inputBufMgmt)
      ,  (pXAxis->axisSpec).nrPixels
      ,  (pYAxis->axisSpec).nrPixels
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
      double *pColor;
      grplot_input_buf_mgmt_get_color(&(pDiagram->inputBufMgmt), &pColor, index);
      grplot_color_diff_encode(pColor, pDiagram->backgroundColor, color);
   }
   {
      double *pPixel;
      grplot_input_buf_mgmt_get_pixels(&(pDiagram->inputBufMgmt), &pPixel, index);
      for (unsigned long i =  0; i < (pDiagram->inputBufMgmt).bufLen; i++) {
         pPixel[i] =  0.0;
      }
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
   grplot_axis_is_inRange(&(pDiagram->pXAxis->axisSpec), &isInRange, x);
   if (isInRange) {
      grplot_axis_is_inRange(&(pDiagram->pYAxis->axisSpec), &isInRange, y);
   }

   if (isInRange) {
      grplot_input_buf_t inpBuf;
      grplot_input_buf_by_mgmt_init(
            &(pDiagram->inputBufMgmt)
         ,  &inpBuf
         ,  index );
      double xDouble, yDouble;
      grplot_axis_get_double(&(pDiagram->pXAxis->axisSpec), &xDouble, x);
      grplot_axis_get_double(&(pDiagram->pYAxis->axisSpec), &yDouble, y);
      grplot_input_buf_plot_point(&inpBuf, xDouble, yDouble, w, radius);
   }

   return retval;
}


int
grplot_diagram_prepare(
      grplot_diagram_t *pDiagram ) {
   assert(pDiagram);

   int retval =  0;

   normalize(&(pDiagram->inputBufMgmt));
   grplot_legend_prepare(&(pDiagram->legend));

   {
      unsigned height =  (pDiagram->legend).height + (pDiagram->pYAxis->axisSpec).nrPixels;
      unsigned width =  (pDiagram->legend).width + (pDiagram->pXAxis->axisSpec).nrPixels;
      pDiagram->height =
            pDiagram->pYAxis->length > height
         ?  pDiagram->pYAxis->length
         :  height;
      pDiagram->width =
            pDiagram->pXAxis->width > width
         ?  pDiagram->pXAxis->width
         :  width;
   }

   return retval;
}


int
grplot_diagram_draw(
      grplot_diagram_t *pDiagram
   ,  DATA32 *out_buf
   ,  unsigned width
   ,  unsigned originX
   ,  unsigned originY ) {
   assert(pDiagram);

   int retval =  0;

   grplot_output_buf_by_mgmt_set_buf(
         out_buf
      ,  &(pDiagram->inputBufMgmt)
      ,  originX
      ,  originY
      ,  width
      ,  pDiagram->backgroundColor );
   {
      unsigned x =  originX + (pDiagram->pXAxis->axisSpec).nrPixels;
      unsigned y =  originY - (pDiagram->pYAxis->axisSpec).nrPixels;
      grplot_legend_draw_LB_horizontal(&(pDiagram->legend), x, y);
   }

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

