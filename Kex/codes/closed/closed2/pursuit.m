function pursuit()
if ~observing()
    search();
else
    chase();
end
