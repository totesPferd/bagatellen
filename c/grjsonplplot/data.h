#ifndef DATA_H
#define DATA_H

#include <jansson.h>
#include <plplot.h>

#include "options.h"


typedef struct {
	PLINT nr;
        PLFLT *xdim;
	PLFLT *ydim;
} grjsonplplot_points_t;

typedef struct {
	PLINT nr;
        PLFLT *xmin;
        PLFLT *xmax;
	PLFLT *ydim;
} grjsonplplot_xbars_t;

typedef struct {
	PLINT nr;
        PLFLT *xdim;
	PLFLT *ymin;
	PLFLT *ymax;
} grjsonplplot_ybars_t;

int
grjsonplplot_data_parse_points(grjsonplplot_scale_option_t *, grjsonplplot_points_t *, json_t *);

int
grjsonplplot_data_parse_xbars(grjsonplplot_scale_option_t *, grjsonplplot_xbars_t *, json_t *);

int
grjsonplplot_data_parse_ybars(grjsonplplot_scale_option_t *, grjsonplplot_ybars_t *, json_t *);

int
grjsonplplot_data_parse(grjsonplplot_scale_option_t *, json_t *);

int
grjsonplplot_data_parse_array(grjsonplplot_scale_option_t *, json_t *);

#endif
