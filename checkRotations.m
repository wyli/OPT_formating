function checkRotations(xml_set)
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

 % update xml files
for i = 1:size(xml_filenames, 1)
    rec = VOCreadxml([xml_set, xml_filenames(i).name]);
    desc = rec.annotation;
    name = desc.index;
    for p = 1:size(rec.annotation.part, 2)
        try
            part = rec.annotation.part{p};
        catch e
            part = rec.annotation.part;
        end

        fprintf('%s checking %s%s\n', datestr(now), name, part);
        segFile = sprintf(annotation_str,...
            desc.dataset, desc.type, name, part);
        segFile = load_nii(segFile);
        segFile.img = segFile.img;
        loc = findPatch(segFile.img, [15, 15, 15], [5, 5, 5]);

        if isempty(loc)

            try
                rec.annotation.needRotate{p} = 1;
            catch e
                rec.annotation.needRotate = 1;
            end
            VOCwritexml(rec, [xml_set, xml_filenames(i).name]);
        else

            try
                rec.annotation.needRotate{p} = 0;
            catch e
                rec.annotation.needRotate = 0;
            end
            VOCwritexml(rec, [xml_set, xml_filenames(i).name]);
        end
        clear segFile;
    end
end
