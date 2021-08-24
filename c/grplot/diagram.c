#include <assert.h>

#include "color_diff.h"
#include "diagram.h"

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
   ,  double x
   ,  double y
   ,  double w
   ,  unsigned index ) {
   assert(pDiagram);

   int retval =  0;

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



