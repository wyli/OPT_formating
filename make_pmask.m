%data_folder = '/home/wenqili/Desktop/auntie/OPT_dataset/';
data_folder = '/home/wenqili/OPT_dataset/';
img_str = [data_folder, 'Image/'];
output_str = [data_folder, 'Objmask/'];
mkdir(output_str);

file_list = dir([img_str, '*.mat']);
close all;
h = figure('position', [0,4000,800,400]);
%for j = 5:length(file_list)
%j = 25;
    in_ = [img_str, file_list(j).name];
    out_ = [output_str, file_list(j).name];
    fprintf('\n%d, looking at %s,\n saving at %s\n',...
        j, in_, out_);

    load(in_);
    objMask = false(size(oriImg));
    w_h = size(oriImg(:,:,1));
    win = floor(w_h./200);
    win(1) = max(win(1),1);
    win(2) = max(win(2),1);
    win = win*2;
    %pause;
    for i = 1:size(oriImg,3)
        I = oriImg(:,:,i);
        level = graythresh(I);
        BW = im2bw(I, level);

        m = medfilt2(BW, win);
        m = bwconvhull(m);
        objMask(:,:,i) = m;


        clf;
        subplot(1,2,1); imagesc(I); axis image;
        title(sprintf('%d %s', i, in_));
        subplot(1,2,2); imagesc(m); axis image;

        
        pause(0.01);
        drawnow;
    end
    %save(out_, 'objMask');
    fprintf('saving %s\n', out_);

%end
