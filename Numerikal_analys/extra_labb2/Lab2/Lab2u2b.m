for i = 1:4
    load(['eiffel', int2str(i) ,'.mat'])
    tic
    [e, v, n] = inversePowerIteration(A, ones(size(A, 1), 1), 0.5*10^-11);
    fprintf(['eiffel', int2str(i), '\n'])
    fprintf('lambda = %.10f\n', e)
    fprintf('n = %i\n', n)
    fprintf('frekvens = %.10f\n', sqrt(e)/(2*pi))
    toc
    fprintf('\n')
end