function finishingCheck(xml_set)
addpath(genpath('U:/archives/NIFTI_20110921'));

% xml indexes
if isempty(xml_set)
    xml_set = 'F:/OPT_dataset/Description/';
end
xml_filenames = dir([xml_set, '*.xml']);
fprintf('%d xml files\n', length(xml_filenames));

segString = 'C:/OPT_dataset/Annotation/%s%s';
imgString = 'C:/OPT_dataset/Image/%s%s';

for i = 1:size(xml_filenames, 1)
    
    rec = VOCreadxml([xml_set, xml_filenames(i).name]);
    name = rec.annotation.index;
    for p = 1:size(rec.annotation.part,2)
        
        if size(rec.annotation.part,2) == 1
            part = rec.annotation.part;
        else
            part = rec.annotation.part{p};
        end
        
        segFile = sprintf(segString, name, part);
        imgFile = sprintf(imgString, name, part);
        
        x = load(segFile);
        y = load(imgFile);
        assert(size(x.segImg) == size(y.oriImg));
        %if size(x.segImg) ~= size(y.oriImg)
        %    fprintf('size not match: %s%s\n',  name, part);
        %end
        clear y;
        
        loc = findPatch(x.segImg, [5 5 5], [5 5 5]);
        assert(~isempty(loc));
        %if isempty(loc)
        %    fprintf('annotation not continuous: %s', name, part);
        %end
        clear x;
        fprintf('%s%s pass\n', name, part);
    end
end
