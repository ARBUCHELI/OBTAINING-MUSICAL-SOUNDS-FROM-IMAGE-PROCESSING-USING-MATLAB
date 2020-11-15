function varargout = finalproyect(varargin)
% FINALPROYECT M-file for finalproyect.fig
%      FINALPROYECT, by itself, creates a new FINALPROYECT or raises the existing
%      singleton*.
%
%      H = FINALPROYECT returns the handle to a new FINALPROYECT or the handle to
%      the existing singleton*.
%
%      FINALPROYECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FINALPROYECT.M with the given input arguments.
%
%      FINALPROYECT('Property','Value',...) creates a new FINALPROYECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before finalproyect_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to finalproyect_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help finalproyect

% Last Modified by GUIDE v2.5 27-Nov-2010 18:57:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @finalproyect_OpeningFcn, ...
                   'gui_OutputFcn',  @finalproyect_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before finalproyect is made visible.
function finalproyect_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to finalproyect (see VARARGIN)

% Choose default command line output for finalproyect
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes finalproyect wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = finalproyect_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global fdpv;
global fdps;
global nota;

folder=uigetdir;
files=dir(folder);

tam=size(files);
k=1;
ref=imread(strcat(folder,'\',files(3).name));
s=size(ref);
clear ref
global vec;
z=1;
%Se puede comentar el for siguiente y descomentar el que le sigue a este
%se puede variar el número de notas a procesar cambiando el final del for
for i=3:11
%for i=3:tam(1)
vec=imresize(imread(strcat(folder,'\',files(i).name)),[s(1)/4,s(2)/4]);
s2=size(vec);
hsv=rgb2hsv(vec);
for i=1:s2(1)
    for j=1:s2(2)
        if(hsv(i,j,2)==0)
            hsv(i,j,2)=1;
            
            
   nuevas(i,j)=fdps(im2uint8(hsv(i,j,2)));     
        
        elseif(hsv(i,j,3)==0)
            
            hsv(i,j,2)=1;
          nuevav(i,j)=fdpv(im2uint8(hsv(i,j,2)));  
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
while(i<=s(2) && flag==0)
if(dil1(557,i)==0)
dil1(557,i)=1;
 cont=cont+1;
else
 flag=1;  
end
i=i+1;
end
if cont==157
  nota(z)=1;
elseif cont==231
    nota(z)=2;
elseif cont==310
    nota(z)=3;
    elseif cont==390
    nota(z)=4;
elseif cont==466
    nota(z)=5;
    elseif cont==544
    nota(z)=6;
    elseif cont==623
    nota(z)=7;
elseif cont==705
    nota(z)=8;
else
    nota(z)=0;
   
    
end
dedo(:,:,1)=im2double(vec(:,:,1)).*dil;
dedo(:,:,2)=im2double(vec(:,:,2)).*dil;
dedo(:,:,3)=im2double(vec(:,:,3)).*dil;
figure
imshow(dedo)
z=z+1;
end
nota
stringNota=strcat(num2str(nota(:)));
set(handles.notes,'String',stringNota);
set(handles.progress,'String','Proceso completo');



%leer procesar


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[File,Path] = uigetfile({'*.bmp';'*.jpg';'*.png'},'Seleccionar imagen de referencia');
global fdps;
global fdpv;
ref=imread(strcat(Path,File));
axes(handles.axes2)
imshow(ref)
hsvp=rgb2hsv(ref);
hists=imhist(hsvp(:,:,2),256);
histv=imhist(hsvp(:,:,3),256);
fdps=hists/sum(hists);
fdpv=histv/sum(histv);
axes(handles.axes3)
stem(fdps)
axes(handles.axes4)
stem(fdpv)


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox3.
function listbox3_Callback(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox3


% --- Executes during object creation, after setting all properties.
function listbox3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global nota;
global do1;
global re;
global mi;
global fa;
global sol;
global la;
global si;
global do2;
dim=size(nota);

Fs=44100;
for i=1:dim(2)
    
   if nota(i)==1
       wavplay(do1,Fs);
   elseif nota(i)==2
       wavplay(re,Fs);
   elseif nota(i)==3
       wavplay(mi,Fs);
   elseif nota(i)==4
       wavplay(fa,Fs);
   elseif nota(i)==5
       wavplay(sol,Fs);
   elseif nota(i)==6
       wavplay(la,Fs);
   elseif nota(i)==7
       wavplay(si,Fs);
   elseif nota(i)==8
       wavplay(do2,Fs);
   else
       msgbox('Nota no reconocida')
      
   end
end
% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder=uigetdir;
files=dir(folder);

global do1;
global re;
global mi;
global fa;
global sol;
global la;
global si;
global do2;

do1=wavread(strcat(folder,'\',files(3).name));
do2=wavread(strcat(folder,'\',files(4).name));
fa=wavread(strcat(folder,'\',files(5).name));
la=wavread(strcat(folder,'\',files(6).name));
mi=wavread(strcat(folder,'\',files(7).name));
re=wavread(strcat(folder,'\',files(8).name));
si=wavread(strcat(folder,'\',files(9).name));
sol=wavread(strcat(folder,'\',files(10).name));

msgbox('Las notas musicales han sido cargadas')


