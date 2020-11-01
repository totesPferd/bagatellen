# icor -  convert and resize (8bit RGBA) pixmap files.

`icor`
* converts pixmap files to other file formats,
* converts pixmaps to pixmaps with other resolution

## Installation.

Make sure you have installed [Imlib2 lib](https://docs.enlightenment.org/api/imlib2/html/) as well as [FFTW3 lib](http://www.fftw.org/) and [help2man util](https://www.gnu.org/software/help2man/).  Suppose `${SRC_DIR}` is the dir where source code were checked out.  Cd to a build dir and run:

	"${SRC_DIR}/configure"
	make
	make install

`make install` needs root privileges.

## Sample usage.

	icor -i OriginalPhoto.jpg -o ProcessedPhoto.png -x 512 -y 768

converts a JPEG file `OriginalPhoto.jpg` to a PNG file `ProcessedPhoto.png`.
The pixmap in latter file has 512 pixel columns and 768 pixel rows.

If you cannot derive pixmap file type from file name then you can give additional options `--iformat` and `--oformat`, resp., e.g.

	icor                                    \
	   -i Photo.jpg.orig --iformat jpg      \
	   -o Photo.png.processed --oformat png \
	   -x 512 -y 768

