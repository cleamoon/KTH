function res = checkCapture()
global pp exy;
%% one pursuer is enough to capture
for i = 1:3
    if dis(pp(i,1), pp(i,2), exy(1), exy(2)) <= 1
        res = true;
        return;
    end
end
res = false;

%% all three need to capture
% for i = 1:3
%     if dis(pp(i,1), pp(i,2), exy(1), exy(2)) > 1
%         res = false;
%         return;
%     end
% end
% res = true;