function [loc] = int_loc(in, arr)
    for i = 1:1:length(arr)
        if arr(i) <= in
            if i == length(arr)
                loc = i+1;
                return ;
            else 
                if in <=arr(i+1)
                    loc = i;
                    return ;
                end
            end
        end
    end
end
                