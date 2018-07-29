function sierpinski (x, y, n)
    hold on
    if n > 0
        fill (x, y, 'b')
        m1 = (x(1) + x(2))/2;
        m2 = (x(1) + x(3))/2;
        m3 = (x(2) + x(3))/2;
        n1 = (y(1) + y(2))/2;
        n2 = (y(1) + y(3))/2;
        n3 = (y(2) + y(3))/2;
        xm = [m1, m2, m3];
        ym = [n1, n2, n3];
        fill (xm, ym, 'r')
        axis equal
        node_x = [x(1), m1, m2, x(2), m1, m3, x(3), m2, m3];
        node_y = [y(1), n1, n2, y(2), n1, n3, y(3), n2, n3];
        for i = 1:3
            sierpinski(node_x(3*i-2:3*i), node_y(3*i-2:3*i), n-1);
        end
    end

