function original = affineImage(original)
    original = permute(original, [3 2 1]);
    original = flipdim(original, 3);
end
