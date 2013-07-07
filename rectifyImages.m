function rectifyImages(xml_set)
addpath(genpath('U:/archives/NIFTI_20110921'));

% xml indexes
if isempty(xml_set)
    xml_set = 'F:/OPT_dataset/Description/';
end
xml_filenames = dir([xml_set, '*.xml']);
fprintf('%d xml files\n', length(xml_filenames));

% ../dataset/Annotated/type/index_block/
annotation_str = 'U:/OPTannotation/%s/Annotated/%s/%s%s';
% ../dataset/Images/type/index/index_block/
image_str = 'U:/OPTannotation/%s/Images/%s/%s/%s%s';

% scale & rotate
savingSeg = 'C:/OPT_dataset/Annotation/%s%s';
savingOri = 'C:/OPT_dataset/Image/%s%s';
for i = 1:size(xml_filenames, 1)

    rec = VOCreadxml([xml_set, xml_filenames(i).name]);
    desc = rec.annotation;
    name = rec.annotation.index;
    for p = 1:size(rec.annotation.part,2)

        if size(rec.annotation.part,2) == 1
            part = rec.annotation.part;
        else
            part = rec.annotation.part{p};
        end

        % load segmentation
        segFile = sprintf(annotation_str,...
            desc.dataset, desc.type, name, part);
        segFile = load_nii(segFile);
        segImg = segFile.img;
        clear segFile;
        % scale segmentation
        fprintf('%s scaling %s%s\n', datestr(now), name, part);
        tempImg = zeros(size(segImg).*2);
        for n = 1:size(segImg, 3)
            tempImg(:,:,n) = uint8(im2bw(imresize(segImg(:,:,n), 2), 0.5));
        end
        segImg = tempImg;
        clear tempImg;

        % rotate segmentation if needed
        if size(rec.annotation.part,2) == 1
            segImg = affineImage(segImg, str2num(rec.annotation.needRotate));
        else
            segImg = affineImage(segImg, str2num(rec.annotation.needRotate{p}));
        end
        savingSegFile = sprintf(savingSeg, name, part);
        save(savingSegFile, 'segImg');
        clear segImg;


        % load original image
        oriFile = sprintf(image_str,...
            desc.dataset, desc.type, name, name, part);
        oriFile = load_nii([oriFile '/Stack']);
        oriImg = oriFile.img;
        clear oriFile;

        oriImg = uint8(oriImg);
        % rotate image if needed
        if size(rec.annotation.part,2) == 1
            oriImg = affineImage(oriImg, str2num(rec.annotation.needRotate));
        else
            oriImg = affineImage(oriImg, str2num(rec.annotation.needRotate{p}));
        end
        % save image to disk
        savingOriFile = sprintf(savingOri, name, part);
        save(savingOriFile, 'oriImg');
        clear oriImg;
    end
end
