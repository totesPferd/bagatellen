#ifndef OPTIONS_H
#define OPTIONS_H

#include <plplot.h>


typedef enum {
        grjsonplplot_arithmetic,
        grjsonplplot_logarithmic
} grjsonplplot_scale_type_t;

typedef struct {
        grjsonplplot_scale_type_t xdim;
        grjsonplplot_scale_type_t ydim;
} grjsonplplot_scale_option_t;

int
grjsonplplot_set_x(grjsonplplot_scale_option_t *, PLFLT *, PLFLT);

int
grjsonplplot_set_y(grjsonplplot_scale_option_t *, PLFLT *, PLFLT);

#endif
