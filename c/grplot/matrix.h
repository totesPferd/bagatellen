#ifndef GRPLOT_MATRIX_H
#define GRPLOT_MATRIX_H

#include <Imlib2.h>

#include "axis.h"
#include "axis_output.h"
#include "diagram.h"

typedef enum {
   grplot_matrix_diagram_ok =  0,
   grplot_matrix_diagram_invalid } grplot_matrix_diagram_status_t;

typedef struct {
   grplot_axis_output_t axis;
   unsigned positionPerPixel; } grplot_matrix_positional_axis_t;

typedef struct {
   int isValid;
   grplot_diagram_t diagram; } grplot_matrix_diagram_t;

typedef struct {
   unsigned nrX, nrY;
   unsigned nrAxis, nrDiagram;
   unsigned maxX, maxY;
   unsigned xDistance, yDistance;
   unsigned originX, originY;
   unsigned xTotal, yTotal;
   grplot_matrix_positional_axis_t *pAxisBuf;
   grplot_matrix_diagram_t *pDiagramBuf;
   DATA32 baseColor;
   unsigned nrOutPixel; } grplot_matrix_t;

int
grplot_matrix_init(
      grplot_matrix_t *
   ,  unsigned
   ,  unsigned
   ,  unsigned
   ,  unsigned );

int
grplot_matrix_get_positional_axis(
      const grplot_matrix_t *
   ,  grplot_axis_type_t
   ,  grplot_matrix_positional_axis_t **
   ,  unsigned );

grplot_matrix_diagram_status_t
grplot_matrix_get_diagram(
      const grplot_matrix_t *
   ,  grplot_diagram_t **
   ,  unsigned
   ,  unsigned );

void
grplot_matrix_get_diagram_set_valid(
      const grplot_matrix_t *pMatrix
   ,  grplot_diagram_t **ppDiagram
   ,  unsigned x
   ,  unsigned y );

void grplot_matrix_set_diagram_invalid(
      const grplot_matrix_t *pMatrix
   ,  unsigned x
   ,  unsigned y );

grplot_axis_output_status_t
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
   ,  const char * );

grplot_axis_output_status_t
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
   ,  const char * );

void
grplot_matrix_x_axis_init_as_invalid(
      grplot_matrix_t *
   ,  unsigned );

void
grplot_matrix_y_axis_init_as_invalid(
      grplot_matrix_t *
   ,  unsigned );

grplot_diagram_status_t
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

int
grplot_matrix_draw(
      grplot_matrix_t *
   ,  DATA32 * );

void
grplot_matrix_destroy(
      grplot_matrix_t * );

#endif
