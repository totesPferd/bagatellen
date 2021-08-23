#ifndef GRPLOT_INSCRIPTION_H
#define GRPLOT_INSCRIPTION_H

typedef struct {
   char *text;
   int width, height; } grplot_inscription_t;

typedef struct {
   grplot_inscription_t inscription;
   unsigned positionPerPixel; } grplot_inscription_positional_inscription_t;

int
grplot_inscription_init(
      grplot_inscription_t *
   ,  char *
   ,  int
   ,  int );

int
grplot_inscription_position_inscription_init(
      grplot_inscription_positional_inscription_t *
   ,  char *
   ,  int
   ,  int
   ,  unsigned );

#endif
