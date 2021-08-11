#ifndef GRPLOT_COLOR_DIFF_H
#define GRPLOT_COLOR_DIFF_H

#include <Imlib2.h>

int
grplot_color_diff_encode(double *, DATA32, DATA32);

int
grplot_color_diff_decode(DATA32 *, const double *, DATA32);

#endif
