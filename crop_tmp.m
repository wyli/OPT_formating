% identify slices and save images again.
xx = 370;
yy = 640;
if xx > 0
    objMask(:,:,1:xx) = false;
    objMask(:,:,yy:end) = false;
end
fprintf('%d, saved %s\n', j, out_);
save(out_,'objMask');
