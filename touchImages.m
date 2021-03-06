function touchImages(xml_set)
%%% touch all images (check existence)
% xml indexes

if isempty(xml_set)
    xml_set = 'C:/OPT_dataset/Description/';
end

xml_filenames = dir([xml_set, '*.xml']);
fprintf('%d xml files\n', length(xml_filenames));

% ../dataset/Annotated/type/index_block/
%annotation_str = 'F:/OPT_original/%s/Annotated/%s/%s%s';
annotation_str = '/home/wenqili/Desktop/auntie/OPTannotation/%s/Annotated/%s/%s%s';
% ../dataset/Images/type/index/index_block/
%image_str = 'F:/OPT_original/%s/Images/%s/%s/%s%s';
%image_str = '/home/wenqili/Desktop/auntie/OPTannotation/%s/Images/%s/%s/%s%s';
image_str = '/home/wenqili/textures/OPT_stacks/%s/Images/%s/%s/%s%s';

for i = 1:size(xml_filenames, 1)
    rec = VOCreadxml([xml_set, xml_filenames(i).name]);
    desc = rec.annotation;
    name = desc.index;
    for p = 1:size(desc.part, 2)
        if size(desc.part, 2) == 1
            part = desc.part;
        else
            part = desc.part{p};
        end

        annotation_name = sprintf(annotation_str,...
            desc.dataset, desc.type, name, part);
        image_name = sprintf(image_str,...
            desc.dataset, desc.type, desc.index, desc.index, part);
        if exist([annotation_name '.img'], 'file') ~= 2
            fprintf('Missing: %s.img\n', annotation_name);
        end
        if exist([annotation_name '.hdr'], 'file') ~= 2
            fprintf('Missing: %s.hdr\n', annotation_name);
        end
        if exist([image_name '/Stack_1024x1024.img'], 'file') ~= 2
            fprintf('Missing: %s/Stack.img\n', image_name);
        end
        if exist([image_name '/Stack_1024x1024.hdr'], 'file') ~= 2
            fprintf('Missing: %s/Stack.hdr\n', image_name);
        end
    end
    fprintf('%s pass\n', xml_filenames(i).name);
end

end
