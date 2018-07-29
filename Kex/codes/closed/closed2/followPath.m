function followPath()
global pos ds vmax ne nn;
for k = 1:nn+1
    l = vmax(k)/4;
    for i = 1:ne-1
        p1 = ds(k, i+1, 1)-ds(k, i, 1);
        p2 = ds(k, i+1, 2)-ds(k, i, 2);
        l = l - norm([p1, p2]);
        if l < 0
            break;
        end
    end
    pos(k, :) = ds(k, i, :);
end
memorize();
for k = 1:nn+1
    l = vmax(k)/4;
    for i = 1:ne-1
        p1 = ds(k, i+1, 1)-ds(k, i, 1);
        p2 = ds(k, i+1, 2)-ds(k, i, 2);
        l = l - norm([p1, p2]);
        if l < 0
            break;
        end
    end
    pos(k, :) = ds(k, i, :);
end
memorize();
for k = 1:nn+1
    l = vmax(k)/4;
    for i = 1:ne-1
        p1 = ds(k, i+1, 1)-ds(k, i, 1);
        p2 = ds(k, i+1, 2)-ds(k, i, 2);
        l = l - norm([p1, p2]);
        if l < 0
            break;
        end
    end
    pos(k, :) = ds(k, i, :);
end
memorize();
for k = 1:nn+1
    l = vmax(k)/4;
    for i = 1:ne-1
        p1 = ds(k, i+1, 1)-ds(k, i, 1);
        p2 = ds(k, i+1, 2)-ds(k, i, 2);
        l = l - norm([p1, p2]);
        if l < 0
            break;
        end
    end
    pos(k, :) = ds(k, i, :);
end
memorize();