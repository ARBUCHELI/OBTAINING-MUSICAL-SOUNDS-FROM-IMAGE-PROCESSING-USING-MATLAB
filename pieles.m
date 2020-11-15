clear
clc
x1=imread('1.jpg');
pieles=imread('pieles.bmp');
tam1=size(x1);
x2=imresize(x1,[tam1(1)/4 tam1(2)/4]);

tam2=size(x2);
hsv=rgb2hsv(pieles);
hsvp=rgb2hsv(x2);
hists=imhist(hsv(:,:,2),256);
histv=imhist(hsv(:,:,3),256);

fdps=hists/sum(hists);
fdpv=hists/sum(histv);

% for i=1:tam2(1)
%     for j=1:tam2(2)
%         if(hsvp(i,j,2)==0)
%             hsvp(i,j,2)=1;
%             
%             
%    nueva(i,j)=hist(hsvp(i,j,2));     
%         
%         else
%             nueva(i,j)=fdp(im2uint8(hsvp(i,j,2)));  
%         end
%             
%     end
%     
% end