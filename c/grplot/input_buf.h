#ifndef INPUT_BUF
#define INPUT_BUF

typedef struct {
   int nrRows;
   int nrCols;
   double radius;
   double *buf;
} grplot_input_buf_t;

int
grplot_input_buf_init(grplot_input_buf_t *, int, int, double);

int
grplot_input_buf_plot_point(grplot_input_buf_t *, double, double, double);

void
grplot_input_buf_destroy(grplot_input_buf_t *);

#endif
