#include <float.h>
#include <math.h>

#include "options.h"

int
grjsonplplot_set_x(grjsonplplot_scale_option_t *p_scale_option, PLFLT *p_x, PLFLT value) {
        int retval =  0;

        if (p_scale_option -> xdim == grjsonplplot_arithmetic) {
                *p_x =  value;
        } else {
                *p_x =  log10(value);
                if (isnan(*p_x) || isinf(*p_x)) {
                        *p_x =  FLT_MIN;
                }
        }

        return retval;
}

int
grjsonplplot_set_y(grjsonplplot_scale_option_t *p_scale_option, PLFLT *p_y, PLFLT value) {
        int retval =  0;

        if (p_scale_option -> ydim == grjsonplplot_arithmetic) {
                *p_y =  value;
        } else {
                *p_y =  log10(value);
                if (isnan(*p_y) || isinf(*p_y)) {
                        *p_y =  FLT_MIN;
                }
        }

        return retval;
}


