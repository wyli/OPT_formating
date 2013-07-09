function checkRotations(xml_set)
addpath(genpath('U:/archives/NIFTI_20110921'));
%%% touch all images (check existence)
% xml indexes
if isempty(xml_set)
    xml_set = 'C:/OPT_dataset/Description/';
end
xml_filenames = dir([xml_set, '*.xml']);
fprintf('%d xml files\n', length(xml_filenames));

% ../dataset/Annotated/type/index_block/
annotation_str = 'U:/OPTannotation/%s/Annotated/%s/%s%s';
% ../dataset/Images/type/index/index_block/
image_str = 'U:/OPTannotation/%s/Images/%s/%s/%s%s';

 % update xml files
for i = 1:size(xml_filenames, 1)
    rec = VOCreadxml([xml_set, xml_filenames(i).name]);
    desc = rec.annotation;
    name = desc.index;
    for p = 1:size(rec.annotation.part, 2)
        if size(rec.annotation.part, 2) == 1
            part = rec.annotation.part;
        else
            part = rec.annotation.part{p};
        end

        fprintf('%s checking %s%s\n', datestr(now), name, part);
        segFile = sprintf(annotation_str,...
            desc.dataset, desc.type, name, part);
        segFile = load_nii(segFile);
        segFile.img = segFile.img;
        flag = 0;
        loc = findPatch(...
            affineImage(segFile.img, flag), [5, 5, 5], [5, 5, 5]);

        while flag < 3 && isempty(loc)

            flag = flag + 1;
            loc = findPatch(...
                affineImage(segFile.img, flag), [5, 5, 5], [5, 5, 5]);
            if size(rec.annotation.part, 2) == 1
                rec.annotation.needRotate = flag;
            else
                rec.annotation.needRotate{p} = flag;
            end
        end
        VOCwritexml(rec, [xml_set, xml_filenames(i).name]);
        clear segFile;
    end
end
