#ifndef GRPLOT_AXIS_OUTPUT_H
#define GRPLOT_AXIS_OUTPUT_H

#include <Imlib2.h>

#include "axis.h"

#define MAX_NR_INSCRIPTIONS 64

typedef struct {
   const char *text;
   int width, height; } grplot_axis_output_inscription_t;

typedef struct {
   grplot_axis_output_inscription_t inscription;
   unsigned valPerPixel, realValPerPixel; } grplot_axis_output_val_inscription_t;

typedef struct {
   grplot_axis_t axisSpec;
   Imlib_Font inscriptionFont;
   Imlib_Font labelFont;
   unsigned nrInscriptions; 
   grplot_axis_output_inscription_t label;
   grplot_axis_output_val_inscription_t upperInscription;
   grplot_axis_output_val_inscription_t inscriptions[MAX_NR_INSCRIPTIONS]; } grplot_axis_output_t;

int
grplot_axis_output_inscription_init(grplot_axis_output_inscription_t *, Imlib_Font, const char *);

int
grplot_axis_output_val_inscription_init(const grplot_axis_t *, grplot_axis_output_val_inscription_t *, Imlib_Font, grplot_axis_val_t);

int
grplot_axis_output_init(
      grplot_axis_output_t *
   ,  grplot_axis_type_t
   ,  grplot_axis_scale_type_t
   ,  Imlib_Font
   ,  Imlib_Font
   ,  unsigned
   ,  grplot_axis_val_t
   ,  grplot_axis_val_t
   ,  const char * );


#endif
