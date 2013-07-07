function rectifyImages(xml_set)
addpath(genpath('U:/archives/NIFTI_20110921'));
%%% touch all images (check existence)
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

rotateMat = [0 0 1 0; 0 1 0 0; -1 0 0 0; 0 0 0 1];

% scale & rotate
savingSeg = 'C:/OPT_dataset/Annotation/%s%s';
savingOri = 'C:/OPT_dataset/Image/%s%s';
for i = 1:size(xml_filenames, 1)

    rec = VOCreadxml([xml_set, xml_filenames(i).name]);
    desc = rec.annotation;
    name = rec.annotation.index;
    for p = 1:size(rec.annotation.part,2)
        try
            part = rec.annotation.part{p};
        catch e
            part = rec.annotation.part;
        end
        % load segmentation
        segFile = sprintf(annotation_str,...
            desc.dataset, desc.type, name, part);
        segFile = load_nii(segFile);
        segImg = segFile.img;
        clear segFile;
        % scale segmentation
        fprintf('%s scaling %s%s\n', datestr(now), name, part);
        tempImg = zeros(size(segImg,1)*2, size(segImg,2)*2, size(segImg,3));
        for n = 1:size(segImg, 3)
            tempImg(:,:,n) = imresize(segImg(:,:,n), 2);
        end
        segImg = tempImg;
        clear tempImg;
        % rotate segmentation if needed
        try
            if rec.annotation.needRotate{p} == '1'
                fprintf('%s rotating %s%s\n', datestr(now), name, part);
                %segImg = affine(segImg, rotateMat);
                segImg = affineImage(segImg);
            end
        catch e
            if rec.annotation.needRotate == '1'
                fprintf('%s rotating %s%s\n', datestr(now), name, part);
                %segImg = affine(segImg, rotateMat);
                segImg = affineImage(segImg);
            end
        end
        % to binary image
        tempImg = zeros(size(segImg));
        for n = 1:size(tempImg, 3)
            tempImg(:,:,n) = im2bw(segImg(:,:,n), 0.5);
        end
        segImg = tempImg;
        clear tempImg;
        segImg = uint8(segImg); %% caution!!! avoid large size
        % save segmentation to disk
        savingSegFile = sprintf(savingSeg, name, part);
        save(savingSegFile, 'segImg');
        clear segImg;

        % load original image
%image_str = 'U:/OPTannotation/%s/Images/%s/%s/%s%s';
        oriFile = sprintf(image_str,...
            desc.dataset, desc.type, name, name, part);
        oriFile = load_nii([oriFile '/Stack']);
        oriImg = oriFile.img;
        clear oriFile;

        % rotate image if needed
        try
            if rec.annotation.needRotate{p} == '1'
                fprintf('%s rotating %s%s\n', datestr(now), name, part);
                %oriImg = affine(oriImg, rotateMat);
                oriImg = affineImage(oriImg);
            end
        catch e
            if rec.annotation.needRotate == '1'
                fprintf('%s rotating %s%s\n', datestr(now), name, part);
                %oriImg = affine(oriImg, rotateMat);
                oriImg = affineImage(oriImg);
            end
        end
        oriImg = uint8(oriImg);
        % save image to disk
        savingOriFile = sprintf(savingOri, name, part);
        save(savingOriFile, 'oriImg');
        clear oriImg;
    end
end

%% update xml files
for i = 1:size(xml_filenames, 1)
    rec = VOCreadxml([xml_set, xml_filenames(i).name]);
    name = rec.annnotation.index;
    for p = 1:size(rec.annotation.part, 2)
        try
            part = rec.annotation.part{p};
        catch e
            part = rec.annotation.part;
        end

        fprintf('%s re-checking %s%s\n', datestr(now), name, part);
        segFile = sprintf(savingSeg, name, part);
        segFile = load_nii(segFile);
        segImg = segFile.img;
        try
            scanForPositiveSampleLocations(segImg, [15, 15, 15], [5, 5, 5]);
            clear segImg;
        catch e
            fprintf('error: %s\n', e.identifier);
            if strcmp(e.identifier, 'OPT:nolocation')
                fprintf('error file: %s', segFile);
            end
        end
    end
end
