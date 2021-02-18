#ifndef CONFIGURATION_H
#define CONFIGURATION_H

#include <jansson.h>

#include "options.h"

int
grjsonplplot_config_parse(grjsonplplot_scale_option_t *, json_t *);

#endif
