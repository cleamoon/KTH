function writemesh(filename, p, e, t)

% Write the mesh (p,e,t) to a given file.
% Copyright (C) 2003 Johan Hoffman and Anders Logg.
% Licensed under the GNU GPL Version 2.

fp = fopen(filename, 'w');

fprintf(fp, 'p = [ %.3f %.3f', p(1,1), p(2,1));
for i=2:size(p,2)
  fprintf(fp, '\n%.3f %.3f', p(1,i), p(2,i));
end
fprintf(fp, ']'';\n\n');

fprintf(fp, 'e = [ %d %d %.3f %.3f %d %d %d', ...
		  e(1,1), e(2,1), e(3,1), e(4,1), e(5,1), e(6,1));
for i=2:size(e,2)
  fprintf(fp, '\n%d %d %.3f %.3f %d %d %d', ...
	  e(1,i), e(2,i), e(3,i), e(4,i), e(5,i), e(6,i));
end
fprintf(fp, ']'';\n\n');

fprintf(fp, 't = [ %d %d %d %d', ...
		  t(1,1), t(2,1), t(3,1), t(4,1));
for i=2:size(t,2)
  fprintf(fp, '\n%d %d %d %d', ...
	  t(1,i), t(2,i), t(3,i), t(4,i));
end
fprintf(fp, ']'';\n');

fprintf(fp, 'pdemesh(p,e,t)\n');
fprintf(fp, 'axis equal\n');

fclose(fp);
