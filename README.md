Using matlab with NIFTI toolbox, converting files into consistent formats.

1. mv annotations in the annotations folder, make sure names are consistent. The names take the form:
`[0-9]{3}.img` and `[0-9]{3].hdr`.

2. mv images in the the image folder, make sure names are the same: `Stack.img` and `Stack.hdr`
(related code: `renameFiles.sh`).

3. generate xml files using `makexml.py`.

4. `rectifyImages.m`: change scale/rotation of the images, save them in organised folder.
- - -
##### note:
First make sure NIFTI in on matlab path and the file `load_nii_img.m` ould be fixed.
