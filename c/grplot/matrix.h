#ifndef GRPLOT_MATRIX_H
#define GRPLOT_MATRIX_H

#include <Imlib2.h>

#include "axis.h"
#include "axis_output.h"
#include "diagram.h"

typedef struct {
   grplot_axis_output_t axis;
   unsigned positionPerPixel; } grplot_matrix_positional_axis_t;

typedef struct {
   unsigned nrX, nrY;
   unsigned nrAxis, nrDiagram;
   unsigned maxX, maxY;
   unsigned xDistance, yDistance;
   unsigned originX, originY;
   grplot_matrix_positional_axis_t *pAxisBuf;
   grplot_diagram_t *pDiagramBuf; } grplot_matrix_t;

int
grplot_matrix_init(
      grplot_matrix_t *
   ,  unsigned
   ,  unsigned
   ,  unsigned
   ,  unsigned );

int
grplot_matrix_get_positional_x_axis(
      const grplot_matrix_t *
   ,  grplot_matrix_positional_axis_t **
   ,  unsigned );

int
grplot_matrix_get_positional_y_axis(
      const grplot_matrix_t *
   ,  grplot_matrix_positional_axis_t **
   ,  unsigned );

int
grplot_matrix_get_diagram(
      const grplot_matrix_t *
   ,  grplot_diagram_t **
   ,  unsigned
   ,  unsigned );

int
grplot_matrix_x_axis_init(
      grplot_matrix_t *
   ,  unsigned
   ,  grplot_axis_scale_type_t
   ,  Imlib_Font
   ,  DATA32
   ,  Imlib_Font
   ,  DATA32
   ,  unsigned
   ,  DATA32
   ,  grplot_axis_val_t
   ,  grplot_axis_val_t
   ,  char * );

int
grplot_matrix_y_axis_init(
      grplot_matrix_t *
   ,  unsigned
   ,  grplot_axis_scale_type_t
   ,  Imlib_Font
   ,  DATA32
   ,  Imlib_Font
   ,  DATA32
   ,  unsigned
   ,  DATA32
   ,  grplot_axis_val_t
   ,  grplot_axis_val_t
   ,  char * );

int
grplot_matrix_diagram_init(
      grplot_matrix_t *
   ,  DATA32
   ,  Imlib_Font
   ,  unsigned
   ,  unsigned
   ,  unsigned );

int
grplot_matrix_prepare(
      grplot_matrix_t * );

void
grplot_matrix_destroy(
      grplot_matrix_t * );

#endif
