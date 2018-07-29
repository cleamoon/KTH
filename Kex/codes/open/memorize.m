function memorize(j)
    % Memorize the state S at the time j within the state list LS
    global nr S LS fd;
    for i = 1:nr
        LS((i-1)*fd+1:(i-1)*fd+fd, j) = S(:, i);
    end
end