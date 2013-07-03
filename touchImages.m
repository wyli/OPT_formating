% touch all images (check existence)

% xml indexes
xml_set = 'U:/OPTannotation/desc/';
xml_filenames = dir([xml_set, '*.xml']);
fprintf('%d xml files\n', length(xml_filenames));

% ../dataset/Annotated/type/index_block/
annotation_str = 'U:/OPTannotation/%s/Annotated/%s/%s%s';
% ../dataset/Images/type/index/index_block/
image_str = 'U:/OPTannotation/%s/Images/%s/%s/%s%s';

for i = 1:size(xml_filenames, 1)
    rec = VOCreadxml([xml_set, xml_filenames(i).name]);
    desc = rec.annotation;
    for p = 1:size(desc.part, 2)
        try
            part = desc.part{p};
        catch
            part = desc.part;
        end

        annotation_str = sprintf(annotation_str,...
            desc.dataset, desc.type, desc.index, desc.part);
        image_str = sprintf(images_str,...
            desc.dataset, desc.type, desc.index, desc.index, desc.part);

        if exist([annotation_str '.img'], 'file') ~= 2 ||...
                exist([annotation_str '.hdr'], 'file') ~= 2 ||...
        end
    end
end
