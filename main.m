xml_set = 'F:\OPT_dataset\Description\';
%touchImages(xml_set); % check existence of images and annotations
%checkRotations(xml_set); % write xml, indicate whether rotation is needed
rectifyImages(xml_set, 1, 0); % rotate and scale images to consistent size&orientation
finishingCheck(xml_set);
