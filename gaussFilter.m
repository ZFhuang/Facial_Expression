function ret=gaussFilter(origin,weight,line1,line2)
    %line1=.35 default
    %line2=.15 default
    ret=origin;
    Size=size(origin);
    N=size(weight);
    N=N(1);
    sizeX=floor(Size(1)/N);
    sizeY=floor(Size(2)/N);
    for i=1:N
        for j=1:N
            if weight(i,j)<line1 && weight(i,j)>=line2
                target=ret((i-1)*sizeX+1:i*sizeX,(j-1)*sizeY+1:j*sizeY);
                ret((i-1)*sizeX+1:i*sizeX,(j-1)*sizeY+1:j*sizeY)=imgaussfilt(target,2);
            elseif weight(i,j)<line2
                target=ret((i-1)*sizeX+1:i*sizeX,(j-1)*sizeY+1:j*sizeY);
                ret((i-1)*sizeX+1:i*sizeX,(j-1)*sizeY+1:j*sizeY)=imgaussfilt(target,10);
            end
        end
    end
end