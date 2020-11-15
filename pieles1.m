clear
clc
x1=imread('3.jpg');
pieles=imread('pieles.bmp');
tam1=size(x1);
x2=imresize(x1,[tam1(1)/4 tam1(2)/4]);

tam2=size(x2);
hsvp=rgb2hsv(pieles);
hsv=rgb2hsv(x2);
hists=imhist(hsvp(:,:,2),256);
histv=imhist(hsvp(:,:,3),256);

fdps=hists/sum(hists);
fdpv=histv/sum(histv);




for i=1:tam2(1)
    for j=1:tam2(2)
        if(hsv(i,j,2)==0)
            hsv(i,j,2)=1;
            
            
   nuevas(i,j)=fdps(im2uint8(hsv(i,j,2)));     
        
        elseif(hsv(i,j,3)==0)
            
            hsv(i,j,3)=1;
          nuevav(i,j)=fdpv(im2uint8(hsv(i,j,3)));  
        else
            nuevas(i,j)=fdps(im2uint8(hsv(i,j,2)));  
            nuevav(i,j)=fdpv(im2uint8(hsv(i,j,3)));
        end
            
    end
    
end



ms=max(max(nuevas));
mv=max(max(nuevav));
imgs=nuevas./ms;
imgv=nuevav./mv;

final=min(imgs,imgv);

u=graythresh(final);
bin=im2bw(final,u);
se1=strel('disk',2);
ero=imerode(bin,se1);
se2=strel('rectangle',[35 40]);
dil=imdilate(ero,se2);


flag=0;
cont=0;
i=1;
dil1=dil;
while(i<=tam2(2) && flag==0)
if(dil1(557,i)==0)
dil1(557,i)=1;
 cont=cont+1;
else
 flag=1;  
end
i=i+1;
end

dedo(:,:,1)=im2double(x2(:,:,1)).*dil;
dedo(:,:,2)=im2double(x2(:,:,2)).*dil;
dedo(:,:,3)=im2double(x2(:,:,3)).*dil;

%se ha detectado la piel falta el sticker naranja

 