#ifndef GRPLOT_JSON_H
#define GRPLOT_JSON_H

#include <Imlib2.h>
#include <jansson.h>

const int grplot_json_error_red_integer =  2;
const int grplot_json_error_green_integer =  4;
const int grplot_json_error_blue_integer =  8;
const int grplot_json_error_alpha_integer =  16;
const int grplot_json_error_red_range =  32;
const int grplot_json_error_green_range =  64;
const int grplot_json_error_blue_range =  128;
const int grplot_json_error_alpha_range =  256;
int
grplot_json_color(json_t *, DATA32 *);

#endif
