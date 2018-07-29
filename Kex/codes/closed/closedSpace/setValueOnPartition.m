function M = setValueOnPartition(M, x1, y1, x2, y2, v)
% Set the value v on a partition on map M
% The left-lower corner of partion has coordinate (x1, y1) and the
% right-upper corner has coordinate (x2, y2);
M(x1:x2, y1:y2) = v;
