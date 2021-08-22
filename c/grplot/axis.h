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

typedef enum {
      grplot_axis_linear_step_one
   ,  grplot_axis_linear_step_two
   ,  grplot_axis_linear_step_five } grplot_axis_linear_step_mantissa_t;

typedef enum {
      grplot_axis_logarithm_step_zero
   ,  grplot_axis_logarithm_step_sixty
   ,  grplot_axis_logarithm_step_twelve
   ,  grplot_axis_logarithm_step_six } grplot_axis_logarithm_step_mantissa_t;

typedef enum {
      grplot_axis_time_step_sec
   ,  grplot_axis_time_step_min
   ,  grplot_axis_time_step_hour
   ,  grplot_axis_time_step_day
   ,  grplot_axis_time_step_month
   ,  grplot_axis_time_step_year } grplot_axis_time_step_t;

typedef struct {
   unsigned exponent;
   grplot_axis_linear_step_mantissa_t mantissa; } grplot_axis_linear_step_t;

typedef struct {
   unsigned base;
   grplot_axis_logarithm_step_mantissa_t mantissa; } grplot_axis_logarithm_step_t;

typedef union {
   grplot_axis_linear_step_t linear;
   grplot_axis_logarithm_step_t logarithm;
   grplot_axis_time_step_t time; } grplot_axis_step_t;

int
grplot_axis_init(grplot_axis_t *, grplot_axis_type_t, grplot_axis_scale_type_t, unsigned, grplot_axis_val_t, grplot_axis_val_t);

int
grplot_axis_getRawDistancePerPixel(const grplot_axis_t *, unsigned *, double);

int
grplot_axis_getDistancePerPixel(const grplot_axis_t *, unsigned *, double);

int
grplot_axis_get_double(const grplot_axis_t *, double *, grplot_axis_val_t);

int
grplot_axis_get_string(const grplot_axis_t *, char **, grplot_axis_val_t);

int
grplot_axis_step_init(const grplot_axis_t *, grplot_axis_step_t *);

int
grplot_axis_step_next(const grplot_axis_t *, grplot_axis_step_t *);

int
grplot_axis_next_val(const grplot_axis_t *, const grplot_axis_step_t *, grplot_axis_val_t *);

#endif
