function [img1,img2,img3]=alignFaces(img1,img2,img3)
width=size(img1,1);
length=size(img1,2);

img2=imresize(img2,[width,length]);
img3=imresize(img3,[width,length]);

end