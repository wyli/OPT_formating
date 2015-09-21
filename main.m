addpath(genpath('/home/wenqili/textures/github/OPTAnalyse/NIFTI_20110921'));
xml_set = '/home/wenqili/Desktop/auntie/OPT_dataset/desc/';
diary('/home/wenqili/Desktop/auntie/OPT_dataset/OPT.log');
fprintf('check existence\n');
touchImages(xml_set); % check existence of images and annotations
fprintf('check rotations\n');
checkRotations(xml_set); % write xml, indicate whether rotation is needed
fprintf('make rotations\n');
rectifyImages(xml_set, 1, 1); % rotate and scale images to consistent size&orientation
fprintf('finalising\n');
finishingCheck(xml_set);
diary off;
