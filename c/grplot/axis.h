#ifndef GRPLOT_AXIS_H
#define GRPLOT_AXIS_H


#include <time.h>

typedef enum {
      grplot_axis_x_axis
   ,  grplot_axis_y_axis } grplot_axis_type_t;

typedef enum {
      grplot_axis_linear
   ,  grplot_axis_logarithm
   ,  grplot_axis_time } grplot_axis_scale_type_t;

typedef union {
   double numeric;
   time_t time; } grplot_axis_val_t;

typedef struct {
   grplot_axis_type_t axisType;
   grplot_axis_scale_type_t scaleType;
   unsigned nrPixels;
   grplot_axis_val_t min;
   grplot_axis_val_t max; } grplot_axis_t;

int
grplot_axis_get_double(grplot_axis_t *, double *, grplot_axis_val_t);

int
grplot_axis_get_string(grplot_axis_t *, char **, grplot_axis_val_t);

#endif
