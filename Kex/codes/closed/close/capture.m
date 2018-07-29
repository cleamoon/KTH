function out = capture()
global xyp xye;
%% one pursuer is enough to capture
for i = 1:3
    if norm(xyp(i,:)-xye) < 1
        out = true;
        return;
    end
end
out = false;

% %% all three need to capture
% for i = 1:3
%     if  norm( xyp(i,:)-xye) > 1
%         out = false;
%         return;
%     end
% end
% out = true;