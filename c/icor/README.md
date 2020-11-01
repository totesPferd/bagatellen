# icor -  convert and resize picture files.

`icor`
* converts pixmap files to other file formats,
* converts pixmaps to pixmaps with other resolution

## Sample usage.

	icor -i OriginalPhoto.jpg -o ProcessedPhoto.png -x 512 -y 768

converts a JPEG file ^OriginalPhoto.jpg` to a PNG file `ProcessedPhoto.png`.
The pixmap in latter file has 512 pixel columns and 768 pixel rows.

If you cannot derive picture file type from file name then you can give additional options `--iformat` and `--oformat`, resp., e.g.

	icor                                    \
	   -i Photo.jpg.orig --iformat jpg      \
	   -o Photo.png.processed --oformat png \
	   -x 512 -y 768

