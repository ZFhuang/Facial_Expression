%读取图片
img1=imread('faces/01.png');
img2=imread('faces/02.png');
img3=imread('faces/03.png');

%对齐
img4=imresize(img1,[size(img2,1),size(img2,2)]);
img3=imresize(img3,[size(img2,1),size(img2,2)]);

%标定68特征点
[~,shape1]=landmarksDetection(img4,'shape_predictor_68_face_landmarks.dat');
[~,shape2]=landmarksDetection(img2,'shape_predictor_68_face_landmarks.dat');
[~,shape3]=landmarksDetection(img3,'shape_predictor_68_face_landmarks.dat');

%加锚点
for i=1:4
    shape1(68+i,:)=[size(img2,1)/i,0];
    shape2(68+i,:)=[size(img2,1)/i,0];
    shape3(68+i,:)=[size(img2,1)/i,0];
end
for i=1:4
    shape1(72+i,:)=[size(img2,1)/i,size(img2,2)];
    shape2(72+i,:)=[size(img2,1)/i,size(img2,2)];
    shape3(72+i,:)=[size(img2,1)/i,size(img2,2)];
end
for i=1:4
    shape1(76+i,:)=[0,size(img2,2)/i];
    shape2(76+i,:)=[0,size(img2,2)/i];
    shape3(76+i,:)=[0,size(img2,2)/i];
end
for i=1:4
    shape1(80+i,:)=[size(img2,1),size(img2,2)/i];
    shape2(80+i,:)=[size(img2,1),size(img2,2)/i];
    shape3(80+i,:)=[size(img2,1),size(img2,2)/i];
end

%计算偏移矩阵并叠加
shapeDelta=shape3-shape2;
shapeAfter=shape1+shapeDelta;

%形变及恢复尺寸
tform = fitgeotrans(shape1,shapeAfter,'lwm',12);
img4 = imwarp(img4,tform);
img4=imresize(img4,[size(img1,1),size(img1,2)]);
%保存加皱纹前图
imwrite(img4,'faces/04.png');

%先利用变形简单对齐两张脸
tform = fitgeotrans(shape3,shape2,'lwm',84);
img5 = imwarp(img3,tform);
img5 = imresize(img5,[size(img2,1),size(img2,2)]);

%提取ycbcr，取y值
img6=imresize(img4,[size(img2,1),size(img2,2)]);
ycbcr1 = rgb2ycbcr(img6);
ycbcr2 = rgb2ycbcr(img2);
ycbcr3 = rgb2ycbcr(img5);

%计算比率R
R=double(ycbcr3(:,:,1))./double(ycbcr2(:,:,1));
% imshow(R);
% pause;

%计算相关度
weight1=computeXCorrWeight(img2,img5,15);
% surf(weight);
% pause;

%利用相关度进行高斯过滤
resultR=gaussFilter(R,weight,0.2,0.1);

%裁剪不需要的部分
[left,right,top,~]=calFaceBox(shapeAfter(1:68,:));
%1-17是脸的轮廓
I=[[left,top];shapeAfter(1:17,:);[right,top]];
BW = roipoly(resultR,I(:,1),I(:,2));
resultR=BWmask(BW,resultR);
imwrite(resultR,'faces/05.png')

%皱纹图对齐
tform = fitgeotrans(shape3,shapeAfter,'lwm',40);
resultR = imwarp(resultR,tform);
resultR(resultR>=0.99)=1;
resultR(resultR<0.3)=1;
% imshow(resultR);
% pause;

%应用皱纹到目标图上
resultR=imresize(resultR,[size(img2,1),size(img2,2)]);
ycbcr1(:,:,1)=uint8(double(ycbcr1(:,:,1)).*resultR);
img6=ycbcr2rgb(ycbcr1);
img6=imresize(img6,[size(img1,1),size(img1,2)]);
imshow(img6);
%加皱纹后
imwrite(img6,'faces/06.png')
