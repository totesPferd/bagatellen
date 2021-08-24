#ifndef GRPLOT_DIAGRAM_H
#define GRPLOT_DIAGRAM

#include <Imlib2.h>

#include "axis_output.h"
#include "input_buf_mgmt.h"
#include "legend.h"

typedef struct {
   grplot_axis_output_t *pXAxis, *pYAxis;
   DATA32 backgroundColor;
   unsigned height, width;
   grplot_input_buf_mgmt_t inputBufMgmt;
   grplot_legend_t legend; } grplot_diagram_t;

int
grplot_diagram_init(
      grplot_diagram_t *
   ,  DATA32
   ,  Imlib_Font
   ,  unsigned
   ,  grplot_axis_output_t *
   ,  grplot_axis_output_t * );

int
grplot_diagram_item_init(
      grplot_diagram_t *
   ,  DATA32
   ,  char *
   ,  unsigned );

int
grplot_diagram_plot_point(
      grplot_diagram_t *
   ,  grplot_axis_val_t
   ,  grplot_axis_val_t
   ,  double
   ,  unsigned
   ,  double );

int
grplot_diagram_prepare(
      grplot_diagram_t * );

int
grplot_diagram_draw(
      grplot_diagram_t *
   ,  DATA32 *
   ,  unsigned
   ,  unsigned
   ,  unsigned );

void
grplot_diagram_destroy(
      grplot_diagram_t * );

#endif
