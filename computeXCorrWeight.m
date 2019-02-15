function ret=computeXCorrWeight(Api,Bpi,N)
    Size=size(Api);
    if Size~=size(Bpi)
        disp('WRONG!');
    end
    sizeX=floor(Size(1)/N);
    sizeY=floor(Size(2)/N);
    %N is the density of filter
    %N=12 default
    ret=ones(N,N);
    for i=1:N
        for j=1:N
            if i==1 && j==1
                matrix=Api(1:(i+1)*sizeX,1:(j+1)*sizeY,1);
            elseif i==1 && j==N 
                matrix=Api(1:(i+1)*sizeX,(j-2)*sizeY+1:(j)*sizeY,1);
            elseif i==N && j==1
                matrix=Api((i-2)*sizeX+1:(i)*sizeX,1:(j+1)*sizeY,1);
            elseif i==N && j==N
                matrix=Api((i-2)*sizeX+1:(i)*sizeX,(j-2)*sizeY+1:(j)*sizeY,1);
            elseif i==1
                matrix=Api(1:(i+1)*sizeX,(j-2)*sizeY+1:(j+1)*sizeY,1);
            elseif i==N
                matrix=Api((i-2)*sizeX+1:(i)*sizeX,(j-2)*sizeY+1:(j+1)*sizeY,1);
            elseif j==1
                matrix=Api((i-2)*sizeX+1:(i+1)*sizeX,1:(j+1)*sizeY,1);
            elseif j==N
                matrix=Api((i-2)*sizeX+1:(i+1)*sizeX,(j-2)*sizeY+1:(j)*sizeY,1);
            else
                matrix=Api((i-2)*sizeX+1:(i+1)*sizeX,(j-2)*sizeY+1:(j+1)*sizeY,1);
            end
            target=Bpi((i-1)*sizeX+1:i*sizeX,(j-1)*sizeY+1:j*sizeY);
            if (numel(target)>=2)&&(numel(matrix)>=2)
                ret(i,j)=1-max(max((abs(normxcorr2(target,matrix)))));
            else
                ret(i,j)=0;
            end
        end
    end
end