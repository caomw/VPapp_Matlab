function varargout = app(varargin)
% APP MATLAB code for app.fig
%      APP, by itself, creates a new APP or raises the existing
%      singleton*.
%
%      H = APP returns the handle to a new APP or the handle to
%      the existing singleton*.
%
%      APP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in APP.M with the given input arguments.
%
%      APP('Property','Value',...) creates a new APP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before app_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to app_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help app

% Last Modified by GUIDE v2.5 01-May-2016 22:14:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @app_OpeningFcn, ...
                   'gui_OutputFcn',  @app_OutputFcn, ...
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


% --- Executes just before app is made visible.
function app_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to app (see VARARGIN)

% Choose default command line output for app
handles.output = hObject;

h1 = handles.uipanelBasic;
h2 = handles.uipanelFiltering;
h3 = handles.uipanelOthers;
h4 = handles.uipanelFeatures;

% state = get(h1,'Visible');
set(h1,'Visible','on');
set(h2,'Visible','off');
set(h3,'Visible','off');
set(h4,'Visible','off');


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes app wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = app_OutputFcn(hObject, eventdata, handles) 
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
handles.output=hObject;
list = handles.popupmenu1;
item = get(list,'Value');
handles.itemSel=item;

if(item==1)
    %Select an image
    [fn pn] = uigetfile({'*.jpg;*.tif;*.png;*.gif','All Image Files';...
        '*.*','All Files'},'mytitle');
    complete = strcat(pn,fn);

    %Open the image
    I = imread(complete);
    
%     %Display the input image
%     fig_inp = figure('Name','input','Position',[0,0,400,600]);
%     imshow(I,[]);
%     handles.inImg = I;
%     
%     %Display the output image
%     fig_img = figure('Name','output','Position',[1400,0,400,600]);
%     handles.himg = fig_img;
%     handles.img = I;
%     imshow(I,[]);
%     hold on;
%     
%     %Display the size
%     set(handles.textSize,'String',...
%         [num2str(size(I,1)),' x ',num2str(size(I,2))]);

elseif(item==2)
    caminfo = imaqhwinfo('winvideo',1);
    vidobj = videoinput('winvideo',caminfo.DeviceID,'YUY2_320x240');
    I = getsnapshot(vidobj);

%     vidobj = imaq.VideoDevice('winvideo', 1, 'YUY2_320x240');
%     vidobj.ReturnedColorSpace = 'rgb';
%     I = step(vidobj);
    
    %Save the handle of the video in handles to use this object in an other
    %function    
    handles.video = vidobj;
   
end

    %Display the input image
    %fig_inp = figure('Name','input','Position',[0,0,400,600]);
    imshow(I,'Parent',handles.axesOriginal);
    handles.inImg = I;
    
    %Display the output image
    fig_img = figure('Name','output','Position',[1400,0,400,600]);
    handles.himg = fig_img;
    handles.img = I;
    imshow(I);
    hold on;
    
    %Display the size
    set(handles.textSize,'String',...
        [num2str(size(I,1)),' x ',num2str(size(I,2))]);
set(list,'Enable','off');

guidata(hObject,handles);



% --- Executes on button press in pushbuttonCloseCam.
function pushbuttonCloseCam_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonCloseCam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

list = handles.popupmenu1;
item = get(list,'Value');

if(item==1)
    himg = handles.himg;
    close(himg);
elseif(item==2)
    %Get the video obj using the handles data
    camframe = handles.video;
    %camframe = findobj('Tag', 'vidobj');
    stop(camframe);
%     release(camframe);
    delete(camframe);
end



set(list,'Enable','on');
%save the change made on the handles
guidata(hObject,handles);





% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbuttonreset.
function pushbuttonreset_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonreset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Get the modified and original image
Ip = handles.img;
I = handles.inImg;
h = handles.himg;
axes = findobj(h,'Type','axes');

%change the modified by the original image
Ip = I;
imshow(Ip, 'Parent', axes);

%Display the new size
set(handles.textSize,'String',...
    [num2str(size(Ip,1)),' x ',num2str(size(Ip,2))]);

%Save in the handles
handles.img = Ip;
guidata(hObject,handles);

% --- Executes on selection change in listboxflip.
function listboxflip_Callback(hObject, eventdata, handles)
% hObject    handle to listboxflip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listboxflip contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listboxflip



% --- Executes during object creation, after setting all properties.
function listboxflip_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listboxflip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonlfip.
function pushbuttonlfip_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonlfip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get the value of the list box for choosing the flip
list = handles.listboxflip;
item = get(list,'Value');

%get the image and its axes
Ip = handles.img;
h = handles.himg;
axes = findobj(h,'Type','axes');

%Flip the image according the list box
if(size(Ip,3)==1)
    if(item == 1)
        Ip = fliplr(Ip);
    elseif(item == 2)
        Ip = flipud(Ip);
    end
elseif(size(Ip,3)==3)
    if(item == 1)
        Ip(:,:,1) = fliplr(Ip(:,:,1));
        Ip(:,:,2) = fliplr(Ip(:,:,2));
        Ip(:,:,3) = fliplr(Ip(:,:,3));
    elseif(item == 2)
        Ip(:,:,1) = flipud(Ip(:,:,1));
        Ip(:,:,2) = flipud(Ip(:,:,2));
        Ip(:,:,3) = flipud(Ip(:,:,3));
    end        
end

%Display and record the modified image
imshow(Ip, 'Parent', axes);
handles.img = Ip;
guidata(hObject,handles);



% --- Executes on button press in pushbuttonSP.
function pushbuttonSP_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonSP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get the image and its axes
Ip = handles.img;
h = handles.himg;
axes = findobj(h,'Type','axes');

%get the slider value for tuning the noise 
slider = handles.slider1;
value = get(slider,'Value');

%Add noise to the image
Ip = imnoise(Ip,'salt & pepper',value);

%Display the modified image
imshow(Ip, 'Parent', axes);
handles.img = Ip;
guidata(hObject,handles);




% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbuttonOpenLogo.
function pushbuttonOpenLogo_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonOpenLogo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Get the axes
axes = handles.axes1;

%Choose a logo
[fn pn] = uigetfile({'*.jpg;*.tif;*.png;*.gif','All Image Files';...
'*.*','All Files'},'mytitle');
complete = strcat(pn,fn);

%Read and display the logo
logo1 = imread(complete);
handles.logo = logo1;
imshow(logo1,'Parent',axes);

%Save the handles
guidata(hObject,handles);






% --- Executes on button press in pushbuttonLogo.
function pushbuttonLogo_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonLogo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get the image and its axes
Ip = handles.img;
h = handles.himg;
axes = findobj(h,'Type','axes');

%Get the logo
logo1 = handles.logo;

%Insert the logo into the image
if(size(Ip,3)==1)
    logo1 = rgb2gray(logo1);
    Ip(end-size(logo1,1)+1:end,end-size(logo1,2)+1:end)=logo1;
elseif(size(Ip,3)==3)
    Ip(end-size(logo1,1)+1:end,end-size(logo1,2)+1:end,1)=logo1(:,:,1);
    Ip(end-size(logo1,1)+1:end,end-size(logo1,2)+1:end,2)=logo1(:,:,2);            
    Ip(end-size(logo1,1)+1:end,end-size(logo1,2)+1:end,3)=logo1(:,:,3);            
end

%Display the modified image
imshow(Ip, 'Parent', axes);
handles.img = Ip;
guidata(hObject,handles);


% --- Executes on button press in pushbuttonInvert.
function pushbuttonInvert_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonInvert (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get the image and its axes
Ip = handles.img;
h = handles.himg;
axes = findobj(h,'Type','axes');

%Invert the image
Ip = 255-Ip;

%Display the modified image
imshow(Ip, [], 'Parent', axes);
handles.img = Ip;
guidata(hObject,handles);


% --- Executes on button press in pushbuttonHist.
function pushbuttonHist_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonHist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get the image
Ip = handles.img;

%Create a new figure
hhist = figure('Name', 'Histogram');
handles.hhist = hhist;

%Display the histogram
if(size(Ip,3)==1)
    imhist(Ip), title('Histogram of the image');
elseif(size(Ip,3)==3)
    subplot(131); imhist(Ip(:,:,1), 255), title('Histogram of the red layer');
    subplot(132); imhist(Ip(:,:,2), 255), title('Histogram of the green layer');
    subplot(133); imhist(Ip(:,:,3), 255), title('Histogram of the blue layer');
end

guidata(hObject,handles);

% --- Executes on button press in pushbuttonEq.
function pushbuttonEq_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonEq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get the image and its axes
Ip = handles.img;
h = handles.himg;
axes = findobj(h,'Type','axes');

%Equalize the histogram, display the new image and the histogram 
Ip(:,:,1) = histeq(Ip(:,:,1));
Ip(:,:,2) = histeq(Ip(:,:,2));
Ip(:,:,3) = histeq(Ip(:,:,3));

%Display the equalized image
imshow(Ip, [], 'Parent', axes);

%get the handle of the histograms figure
hhist = handles.hhist;

%Display the equalized histogram
if(size(Ip,3)==1)
    imhist(Ip), title('Histogram of the image');
elseif(size(Ip,3)==3)
    subplot(1,3,1,'Parent',hhist), imhist(Ip(:,:,1), 255), 
        title('Histogram of the red layer');
    subplot(1,3,2,'Parent',hhist), imhist(Ip(:,:,2), 255), 
        title('Histogram of the green layer');
    subplot(1,3,3,'Parent',hhist), imhist(Ip(:,:,3), 255), 
        title('Histogram of the blue layer');
end

%Save the new image
handles.img = Ip;
guidata(hObject,handles);


% --- Executes on slider movement.
function sliderMorph_Callback(hObject, eventdata, handles)
% hObject    handle to sliderMorph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function sliderMorph_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMorph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in listboxMorph.
function listboxMorph_Callback(hObject, eventdata, handles)
% hObject    handle to listboxMorph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listboxMorph contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listboxMorph


% --- Executes during object creation, after setting all properties.
function listboxMorph_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listboxMorph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonMorph.
function pushbuttonMorph_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonMorph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%get the image and its axes
Ip = handles.img;
h = handles.himg;
axes = findobj(h,'Type','axes');

%get the slider value
size_se = get(handles.sliderMorph,'Value')*10;
size_se = size_se - mod(size_se,1);
display(size_se);

%get the type of morphological operation and the shape of the SE
itemType = get(handles.listboxMorph,'Value');
itemShape = get(handles.listboxShape,'Value');

%Create the SE
switch(itemShape)
    case 1
        SE = strel('disk',size_se);
    case 2
        SE = strel('square',size_se);
    case 3
        SE = strel('rectangle',[size_se, size_se*2]);
    case 4
        SE = strel('diamond',size_se);
    otherwise
        SE = strel('disk',size_se);
end

%Apply the morphological operation
switch(itemType)
    case 1
        Ip = imdilate(Ip,SE);
    case 2
        Ip = imerode(Ip,SE);
    case 3
        Ip = imopen(Ip,SE);
    case 4
        Ip = imclose(Ip,SE);
    otherwise
        Ip = imdilate(Ip,SE);        
end

%Display the modified image
imshow(Ip, [], 'Parent', axes);
handles.img = Ip;
guidata(hObject,handles);


% --- Executes on selection change in listboxShape.
function listboxShape_Callback(hObject, eventdata, handles)
% hObject    handle to listboxShape (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listboxShape contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listboxShape


% --- Executes during object creation, after setting all properties.
function listboxShape_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listboxShape (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function sliderBlur_Callback(hObject, eventdata, handles)
% hObject    handle to sliderBlur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function sliderBlur_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderBlur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbuttonBlur.
function pushbuttonBlur_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonBlur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get the image and its axes
Ip = handles.img;
h = handles.himg;
axes = findobj(h,'Type','axes');

%get the slider value
size_ker = get(handles.sliderBlur,'Value');
size_ker = size_ker - mod(size_ker,1);
display(size_ker);

%Blur the image
%kernel = ones(size_ker)/(size_ker^2);
kernel=fspecial('average',[size_ker,size_ker]);
if(size(Ip,3)==1)
    Ip2 = filter2(kernel,Ip,'valid');
elseif(size(Ip,3)==3)
    Ip2(:,:,1) = filter2(kernel,Ip(:,:,1),'valid');
    Ip2(:,:,2) = filter2(kernel,Ip(:,:,2),'valid');
    Ip2(:,:,3) = filter2(kernel,Ip(:,:,3),'valid');
end
Ip2 = uint8(Ip2);

%Display the modified image
imshow(Ip2, [], 'Parent', axes);
handles.img = Ip2;
guidata(hObject,handles);



function editHeight_Callback(hObject, eventdata, handles)
% hObject    handle to editHeight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editHeight as text
%        str2double(get(hObject,'String')) returns contents of editHeight as a double


% --- Executes during object creation, after setting all properties.
function editHeight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editHeight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editWidth_Callback(hObject, eventdata, handles)
% hObject    handle to editWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editWidth as text
%        str2double(get(hObject,'String')) returns contents of editWidth as a double


% --- Executes during object creation, after setting all properties.
function editWidth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonResize.
function pushbuttonResize_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonResize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get the image and its axes
Ip = handles.img;
h = handles.himg;
axes = findobj(h,'Type','axes');

%Get height and width
height = str2num(get(handles.editHeight,'String'));
width = str2num(get(handles.editWidth,'String'));

%Resize the image
Ip = imresize(Ip, [height, width]);

%Display the new size
set(handles.textSize,'String',...
    [num2str(size(Ip,1)),' x ',num2str(size(Ip,2))]);

%Display the modified image
imshow(Ip, [], 'Parent', axes);
handles.img = Ip;
guidata(hObject,handles);


% --- Executes on button press in pushbuttonSobel.
function pushbuttonSobel_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonSobel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get the image and its axes
Ip = handles.img;
h = handles.himg;
axes = findobj(h,'Type','axes');

%Compute the gradient
h=fspecial('sobel');
Ip=imfilter(Ip,h,'replicate');

%Display the modified image
%imshowpair(GSob,Gdir2,'montage');
imshow(Ip, [], 'Parent', axes);
handles.img = Ip;
guidata(hObject,handles);

% --- Executes on button press in pushbuttonLapl.
function pushbuttonLapl_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonLapl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get the image and its axes
Ip = handles.img;
h = handles.himg;
axes = findobj(h,'Type','axes');

%Apply laplacian
h=fspecial('laplacian');
Ip=imfilter(Ip,h,'replicate');

%Display the modified image
imshow(Ip, [], 'Parent', axes);
handles.img = Ip;
guidata(hObject,handles);


% --- Executes on button press in pushbuttonKernel.
function pushbuttonKernel_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonKernel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get the image and its axes
Ip = handles.img;
h = handles.himg;
axes = findobj(h,'Type','axes');

%Get kernel from the table
kernel = get(handles.uitable1,'Data')/9;

%Apply the filter
if(size(Ip,3)==1)
    Ip2 = filter2(kernel,Ip,'valid');
elseif(size(Ip,3)==3)
    Ip2(:,:,1) = filter2(kernel,Ip(:,:,1),'valid');
    Ip2(:,:,2) = filter2(kernel,Ip(:,:,2),'valid');
    Ip2(:,:,3) = filter2(kernel,Ip(:,:,3),'valid');
end
Ip2 = uint8(Ip2);

%Display the modified image
imshow(Ip2, [], 'Parent', axes);
handles.img = Ip2;
guidata(hObject,handles);


% --- Executes on button press in pushbuttonCanny.
function pushbuttonCanny_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonCanny (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get the image and its axes
Ip = handles.img;
h = handles.himg;
axes = findobj(h,'Type','axes');

%Apply Canny
Ip = rgb2gray(Ip);
Ip = edge(Ip,'canny');

%Display the modified image
imshow(Ip, [], 'Parent', axes);
handles.img = Ip;
guidata(hObject,handles);



function editMinR_Callback(hObject, eventdata, handles)
% hObject    handle to editMinR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editMinR as text
%        str2double(get(hObject,'String')) returns contents of editMinR as a double


% --- Executes during object creation, after setting all properties.
function editMinR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editMinR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editMaxR_Callback(hObject, eventdata, handles)
% hObject    handle to editMaxR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editMaxR as text
%        str2double(get(hObject,'String')) returns contents of editMaxR as a double


% --- Executes during object creation, after setting all properties.
function editMaxR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editMaxR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonCircle.
function pushbuttonCircle_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonCircle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get the image and its axes
Ip = handles.img;
h = handles.himg;
axes = findobj(h,'Type','axes');

%Get the radius
minR = str2num(get(handles.editMinR, 'String'));
maxR = str2num(get(handles.editMaxR, 'String'));

%Detect circles and display on the image
[centers, radii, metric] = imfindcircles(Ip,[minR maxR]);
viscircles(axes,centers, radii,'EdgeColor','b');

%Display the number of detected circles
set(handles.textCirc,'String',num2str(size(centers,1)));
guidata(hObject,handles);


% --- Executes on button press in pushbuttonLine.
function pushbuttonLine_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonLine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get the image and its axes
Ip = handles.img;
h = handles.himg;
axes = findobj(h,'Type','axes');

%Detect Lines
Ip = rgb2gray(Ip);
BW = edge(Ip,'canny');
[H, T, R] = hough(BW);
P = houghpeaks(H, 10);
lines = houghlines(BW, T, R, P);


%Display the lines on the image
for k = 1:length(lines)
    xy = [lines(k).point1; lines(k).point2];
    plot(axes,xy(:,1), xy(:,2),'LineWidth',2,'Color','green');
end

%Display the number of lines
set(handles.textLine,'String',num2str(length(lines)));
guidata(hObject,handles);


% --- Executes on button press in pushbuttonG1.
function pushbuttonG1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonG1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get handles of all panels
h1 = handles.uipanelBasic;
h2 = handles.uipanelFiltering;
h3 = handles.uipanelOthers;
h4 = handles.uipanelFeatures;

%Set the state of each panel
set(h1,'Visible','on');
set(h2,'Visible','off');
set(h3,'Visible','off');
set(h4,'Visible','off');

guidata(hObject,handles);


% --- Executes on button press in pushbuttonG2.
function pushbuttonG2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonG2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get handles of all panels
h1 = handles.uipanelBasic;
h2 = handles.uipanelFiltering;
h3 = handles.uipanelOthers;
h4 = handles.uipanelFeatures;

%Set the state of each panel
set(h1,'Visible','off');
set(h2,'Visible','on');
set(h3,'Visible','off');
set(h4,'Visible','off');

guidata(hObject,handles);


% --- Executes on button press in pushbuttonG3.
function pushbuttonG3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonG3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get handles of all panels
h1 = handles.uipanelBasic;
h2 = handles.uipanelFiltering;
h3 = handles.uipanelOthers;
h4 = handles.uipanelFeatures;

%Set the state of each panel
set(h1,'Visible','off');
set(h2,'Visible','off');
set(h3,'Visible','on');
set(h4,'Visible','off');

guidata(hObject,handles);


% --- Executes on button press in pushbuttonG4.
function pushbuttonG4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonG4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get handles of all panels
h1 = handles.uipanelBasic;
h2 = handles.uipanelFiltering;
h3 = handles.uipanelOthers;
h4 = handles.uipanelFeatures;

%Set the state of each panel
set(h1,'Visible','off');
set(h2,'Visible','off');
set(h3,'Visible','off');
set(h4,'Visible','on');

guidata(hObject,handles);



function editCorner_Callback(hObject, eventdata, handles)
% hObject    handle to editCorner (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editCorner as text
%        str2double(get(hObject,'String')) returns contents of editCorner as a double


% --- Executes during object creation, after setting all properties.
function editCorner_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editCorner (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonHarris.
function pushbuttonHarris_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonHarris (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get the image and its axes
Ip = handles.img;
h = handles.himg;
axes = findobj(h,'Type','axes');

%get number of corners to display
nCorn = str2num(get(handles.editCorner,'String'));

%compute harris corners using non max suppression
[cornersx, cornersy, ~] = harris(Ip,nCorn);
pts(:,1) = cornersx;
pts(:,2) = cornersy;

%Insert markers in the image
Ip = insertMarker(Ip,pts,'x');
% plot(axes,cornersx,cornersy,'xr');

%Display the modified image
imshow(Ip, [], 'Parent', axes);
handles.img = Ip;
guidata(hObject,handles);



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonSIFT.
function pushbuttonSIFT_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonSIFT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get the image and its axes
Ip = handles.img;
h = handles.himg;
axes = findobj(h,'Type','axes');

%detect SIFT keypoints
corners = detectSIF


% --- Executes on button press in pushbuttonSurf.
function pushbuttonSurf_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonSurf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get the image and its axes
Ip = handles.img;
h = handles.himg;
axes = findobj(h,'Type','axes');

%detect SURF keypoints and add it to the image
points = detectSURFFeatures(rgb2gray(Ip));
Ip = insertMarker(Ip,points.Location,'circle');

%Display the modified image
imshow(Ip, [], 'Parent', axes);
handles.img = Ip;
guidata(hObject,handles);


% --- Executes on button press in pushbuttonFast.
function pushbuttonFast_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonFast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get the image and its axes
Ip = handles.img;
h = handles.himg;
axes = findobj(h,'Type','axes');

%detect FAST keypoints and add it to the image
points = detectFASTFeatures(rgb2gray(Ip),'MinContrast',0.1);
Ip = insertMarker(Ip,points,'circle','color','red');

%Display the modified image
imshow(Ip, [], 'Parent', axes);
handles.img = Ip;
guidata(hObject,handles);


% --- Executes on button press in pushbuttonMosaic.
function pushbuttonMosaic_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonMosaic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
run MosaicApp.m


% --- Executes on button press in pushbuttonMatch.
function pushbuttonMatch_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonMatch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get the image and its axes
Ip = handles.img;
h = handles.himg;
axes = findobj(h,'Type','axes');

%Get features of original image
grayImage1 = rgb2gray(Ip);
points1 = detectSURFFeatures(grayImage1);
[features1, valid_points1] = extractFeatures(grayImage1, points1);

%Open a new image
[fn, pn] = uigetfile({'*.jpg;*.tif;*.png;*.gif','All Image Files';...
        '*.*','All Files'},'mytitle');
complete = strcat(pn,fn);
I2 = imread(complete);

%Get features of the new image
grayImage2 = rgb2gray(I2);
points2 = detectSURFFeatures(grayImage2);
[features2, valid_points2] = extractFeatures(grayImage2, points2);

%Match the features
indexPairs = matchFeatures(features1,features2);

matchedPoints1 = valid_points1(indexPairs(:,1),:);
matchedPoints2 = valid_points2(indexPairs(:,2),:);

%Display on superposed image
figure; showMatchedFeatures(Ip,I2,matchedPoints1,matchedPoints2);

%Save handle
guidata(hObject,handles);


% --- Executes on button press in pushbuttonG5.
function pushbuttonG5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonG5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
run FMatrix.m
