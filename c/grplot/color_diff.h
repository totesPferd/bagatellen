#ifndef GRPLOT_COLOR_DIFF_H
#define GRPLOT_COLOR_DIFF_H

#include <Imlib2.h>

typedef enum {
      grplot_color_diff_ok = 0
} grplot_color_diff_status_t;

grplot_color_diff_status_t
grplot_color_diff_encode(double *, DATA32, DATA32);

grplot_color_diff_status_t
grplot_color_diff_decode(DATA32 *, const double *, DATA32);

#endif
