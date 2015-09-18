function finishingCheck(xml_set)
addpath(genpath('U:/archives/NIFTI_20110921'));

% xml indexes
if isempty(xml_set)
    xml_set = 'C:/OPT_dataset/Description/';
end
xml_filenames = dir([xml_set, '*.xml']);
fprintf('%d xml files\n', length(xml_filenames));

segString = '/home/wenqili/Desktop/auntie/OPT_dataset/Annotation/%s%s';
imgString = '/home/wenqili/Desktop/auntie/OPT_dataset/Image/%s%s';

for i = 1:size(xml_filenames, 1)
    
    rec = VOCreadxml([xml_set, xml_filenames(i).name]);
    name = rec.annotation.index;
    for p = 1:size(rec.annotation.part,2)
        
        if size(rec.annotation.part,2) == 1
            part = rec.annotation.part;
        else
            part = rec.annotation.part{p};
        end
        fprintf('%s%s: ', name, part);
        
        segFile = sprintf(segString, name, part);
        imgFile = sprintf(imgString, name, part);
        
        x = load(segFile);
        y = load(imgFile);
        if isequal(size(x.segImg), size(y.oriImg))
            fprintf(' size pass,');
        else
            fprintf('seg: %dx%dx%d\n', size(x.segImg));
            fprintf('img: %dx%dx%d\n', size(y.oriImg));
            fprintf(' size error,');
        end
        if sum(sum(sum(x.segImg))) > 0
            fprintf(' segImg pass,');
        else
            fprintf(' seg error,');
        end
        if sum(sum(sum(y.oriImg))) > 0
            fprintf(' oriImg pass,');
        else
            fprintf(' oriImg error,');
        end
        clear y;
        
        loc = findPatch(x.segImg, [5 5 5], [5 5 5]);
        if ~isempty(loc)
            fprintf(' continuity pass.\n');
        else
            fprintf(' continuity error.\n');
        end
        clear x;
    end
end
