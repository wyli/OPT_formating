function re-checking(xml_set)
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

%% update xml files
for i = 1:size(xml_filenames, 1)
    rec = VOCreadxml([xml_set, xml_filenames(i).name]);
    name = rec.annnotation.index;
    for p = 1:size(rec.annotation.part, 2)
        if size(rec.annotation.part, 2) == 1
            part = rec.annotation.part{p};
        else
            part = rec.annotation.part;
        end

        fprintf('%s re-checking %s%s\n', datestr(now), name, part);
        segFile = sprintf(savingSeg, name, part);
        segFile = load_nii(segFile);
        segImg = segFile.img;
        loc = findPatch(segImg, [5, 5, 5], [5, 5, 5]);
        clear segImg;
        if isempty(loc)
            fprintf('error: %s\n', e.identifier);
            if strcmp(e.identifier, 'OPT:nolocation')
                fprintf('error file: %s', segFile);
            end
        end
    end
end

end
