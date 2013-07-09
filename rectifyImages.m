function rectifyImages(xml_set, doSeg, doImg)
addpath(genpath('U:/archives/NIFTI_20110921'));

% xml indexes
if isempty(xml_set)
    xml_set = 'C:/OPT_dataset/Description/';
end
xml_filenames = dir([xml_set, '*.xml']);
fprintf('%d xml files\n', length(xml_filenames));

% ../dataset/Annotated/type/index_block/
annotation_str = 'F:/OPT_original/%s/Annotated/%s/%s%s';
% ../dataset/Images/type/index/index_block/
image_str = 'F:/OPT_original/%s/Images/%s/%s/%s%s';

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
        
        if doSeg
            % load segmentation
            segFile = sprintf(annotation_str,...
                desc.dataset, desc.type, name, part);
            segFile = load_nii(segFile);
            segImg = segFile.img;
            clear segFile;
            % scale segmentation
            fprintf('%s scaling %s%s\n', datestr(now), name, part);
            tempImg = uint8(zeros(...
                size(segImg, 1)*2, size(segImg, 2)*2, size(segImg, 3)));
            for n = 1:size(segImg, 3)
                %tempImg(:,:,n) = imresize(segImg(:,:,n), 2);
                tempImg(:,:,n) = uint8(imresize(segImg(:,:,n), 2) > 0.5);
            end
            segImg = uint8(tempImg);
            clear tempImg;
            
            % rotate segmentation if needed
            if size(rec.annotation.part,2) == 1
                segImg = uint8(...
                    affineImage(segImg, str2num(rec.annotation.needRotate)));
            else
                segImg = uint8(...
                    affineImage(segImg, str2num(rec.annotation.needRotate{p})));
            end
            savingSegFile = sprintf(savingSeg, name, part);
            save(savingSegFile, 'segImg');
            clear segImg;
        end
        
        
        if doImg
            % load original image
            oriFile = sprintf(image_str,...
                desc.dataset, desc.type, name, name, part);
            oriFile = load_nii([oriFile '/Stack']);
            oriImg = uint8(oriFile.img);
            %oriImg = uint8(oriImg);
            clear oriFile;
            
            % rotate image if needed
            if size(rec.annotation.part,2) == 1
                oriImg = uint8(affineImage(...
                    oriImg, str2num(rec.annotation.needRotate)));
            else
                oriImg = uint8(affineImage(...
                    oriImg, str2num(rec.annotation.needRotate{p})));
            end
            % save image to disk
            savingOriFile = sprintf(savingOri, name, part);
            save(savingOriFile, 'oriImg');
            clear oriImg;
        end
    end
end
