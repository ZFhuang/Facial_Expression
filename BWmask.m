function ret=BWmask(BW,target)
    %with BW=roipoly()
	if size(BW)~=size(target)
        disp('WRONG!');
    end
    ret=target;
    for i=1:numel(BW)
        if BW(i)==0
            ret(i)=1;
        end
    end
end