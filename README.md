Using matlab with NIFTI toolbox, converting files into consistent formats.

1. mv annotations into the annotations folder, make sure names are consistent. The names take the form:
`[0-9]{3}.img` and `[0-9]{3}.hdr`.
2. [optional 1]. generate Stack.img for images using ImageJ.`IMG_to_stack_eval.txt`
2. [optional 2]. mv images in the the image folder, make sure names are the same: `Stack.img` and `Stack.hdr` using bash script. `rename_image.sh`
3. prepare a checklist, examples in `checklist`.
4. generate xml files `makexml.py`.
5. `main.m`: change scale/rotation of the images, save them in organised folder.

- - -
##### note:

First make sure NIFTI in on matlab path and the file `load_nii_img.m` should be fixed.   
Some image blocks have no corresponding annotations.  
notice file path delimiter
dataset file (Image) path format:   

`[DatasetIndex]/Images/[Type]/[ImageIndex]/[ImageBlockIndex]/*.bmp`   
`[DatasetIndex]/Images/[Type]/[ImageIndex]/[ImageBlockIndex]/Stack.img`   
`[DatasetIndex]/Images/[Type]/[ImageIndex]/[ImageBlockIndex]/Stack.hdr`   

dataset file (Annotation) path format:   

`[DatasetIndex]/Annotated/[Type]/[ImageBlockIndex].img`   
`[DatasetIndex]/Annotated/[Type]/[ImageBlockIndex].hdr`   

Output structures:   

`[dataset]/Annotation/[ImageBlockIndex].mat`   
`[dataset]/Image/[ImageBlockIndex].mat`   
`[dataset]/Description/[ImageIndex].xml`   

##### !

447C removed (size not consistent).   
193A removed (not scaled).   
476C not consistent frames, removed
