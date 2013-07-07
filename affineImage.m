function original = affineImage(original, flag)

    if flag == 0

        return original;
    elseif flag == 1

        original = permute(original, [3 2 1]);
        original = flipdim(original, 3);
        return original;
    elseif flag == 2

        original = permute(original, [1 3 2]);
        return original;
    end
end
