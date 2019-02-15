function [left,right,top,buttom]=calFaceBox(shape)
%寻找边缘并返回，左右上下
top=min(shape(:,2));
buttom=max(shape(:,2));
left=min(shape(:,1));
right=max(shape(:,1));
length=buttom-top;
if top-length<0
    top=0;
else
    top=top-length;
end
