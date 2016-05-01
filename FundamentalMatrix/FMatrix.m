function varargout = FMatrix(varargin)
% FMATRIX MATLAB code for FMatrix.fig
%      FMATRIX, by itself, creates a new FMATRIX or raises the existing
%      singleton*.
%
%      H = FMATRIX returns the handle to a new FMATRIX or the handle to
%      the existing singleton*.
%
%      FMATRIX('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FMATRIX.M with the given input arguments.
%
%      FMATRIX('Property','Value',...) creates a new FMATRIX or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FMatrix_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FMatrix_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FMatrix

% Last Modified by GUIDE v2.5 01-May-2016 23:41:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FMatrix_OpeningFcn, ...
                   'gui_OutputFcn',  @FMatrix_OutputFcn, ...
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


% --- Executes just before FMatrix is made visible.
function FMatrix_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FMatrix (see VARARGIN)

% Choose default command line output for FMatrix
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FMatrix wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FMatrix_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbuttonImg1.
function pushbuttonImg1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonImg1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Open a new image
[fn, pn] = uigetfile({'*.jpg;*.tif;*.png;*.gif','All Image Files';...
        '*.*','All Files'},'mytitle');
complete = strcat(pn,fn);
I = imread(complete);
axes = handles.axes1;

%Display the image
imshow(I,[],'Parent',axes);
hold on;

%Save handle
handles.img1 = I;
guidata(hObject,handles);

% --- Executes on button press in pushbuttonImg2.
function pushbuttonImg2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonImg2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Open a new image
[fn, pn] = uigetfile({'*.jpg;*.tif;*.png;*.gif','All Image Files';...
        '*.*','All Files'},'mytitle');
complete = strcat(pn,fn);
I = imread(complete);
axes = handles.axes2;

%Display the image
imshow(I,[],'Parent',axes);
hold on;

%Save handle
handles.img2 = I;
guidata(hObject,handles);

% --- Executes on button press in pushbuttonWcam1.
function pushbuttonWcam1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonWcam1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
caminfo = imaqhwinfo('winvideo',1);
vidobj = videoinput('winvideo',caminfo.DeviceID,'YUY2_320x240');
vidobj.ReturnedColorSpace = 'rgb';
I = getsnapshot(vidobj);
axes = handles.axes1;

%Display the image
imshow(I,[],'Parent',axes);
hold on;

%Save handle
handles.img1 = I;
guidata(hObject,handles);

% --- Executes on button press in pushbuttonWcam2.
function pushbuttonWcam2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonWcam2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
caminfo = imaqhwinfo('winvideo',1);
vidobj = videoinput('winvideo',caminfo.DeviceID,'YUY2_320x240');
vidobj.ReturnedColorSpace = 'rgb';
I = getsnapshot(vidobj);

axes = handles.axes2;

%Display the image
imshow(I,[],'Parent',axes);
hold on;

%Save handle
handles.img2 = I;
guidata(hObject,handles);

% --- Executes on button press in pushbuttonHomo.
function pushbuttonHomo_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonHomo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Get handles info
I1 = handles.img1;
I2 = handles.img2;
axes1 = handles.axes1;
axes2 = handles.axes2;
rbt1 = handles.radiobutton7pts;
rbt2 = handles.radiobutton8pts;
rbt3 = handles.radiobuttonRansac;

%Pick the points
n = 4;

xL = ginput(n);
hold on;
for i=1:n
    plot(axes1,xL(i,1),xL(i,2),'*r','MarkerSize',15);
%     hold on;
    h=text(axes1,xL(i,1)+5,xL(i,2),num2str(i));
    h.FontSize=15;
end

xR = ginput(n);
hold on;
for i=1:n
    plot(axes2,xR(i,1),xR(i,2),'*r','MarkerSize',15);
%     hold on;
    h=text(axes2,xR(i,1)+5,xR(i,2),num2str(i));
    h.FontSize=15;
end

%Change to homogeneous coordinates
xL(:,3) = ones(n,1);
xR(:,3) = ones(n,1);
xL = xL';
xR = xR';

H = estimateHomography(xL,xR);

%Display in GUI
set(handles.uitableH,'Data',H);
guidata(hObject,handles);

% --- Executes on button press in pushbuttonEpipoles.
function pushbuttonEpipoles_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonEpipoles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Get handles info
I1 = handles.img1;
I2 = handles.img2;
axes1 = handles.axes1;
axes2 = handles.axes2;
F = get(handles.uitableF,'Data');

checkEpipolarLine(F, 3, I1, I2, axes1, axes2);

% --- Executes on button press in pushbuttonF.
function pushbuttonF_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Get handles info
I1 = handles.img1;
I2 = handles.img2;
axes1 = handles.axes1;
axes2 = handles.axes2;
rbt1 = handles.radiobutton7pts;
rbt2 = handles.radiobutton8pts;
rbt3 = handles.radiobuttonRansac;

%Pick the points
if(rbt2.Value == 1)
    n = 8;
end
xL = ginput(n);
hold on;
for i=1:n
    plot(axes1,xL(i,1),xL(i,2),'*r','MarkerSize',15);
%     hold on;
    h=text(axes1,xL(i,1)+5,xL(i,2),num2str(i));
    h.FontSize=15;
end

xR = ginput(n);
hold on;
for i=1:n
    plot(axes2,xR(i,1),xR(i,2),'*r','MarkerSize',15);
%     hold on;
    h=text(axes2,xR(i,1)+5,xR(i,2),num2str(i));
    h.FontSize=15;
end

%Change to homogeneous coordinates
xL(:,3) = ones(n,1);
xR(:,3) = ones(n,1);
xL = xL';
xR = xR';

%%LLS with unit constraint on one entry of F 
%Change for 'entry' if you wanna use the first method
F = estimateFondamentalMat(xL, xR, 'norm'); 

%Display in GUI
set(handles.uitableF,'Data',F);
guidata(hObject,handles);


% --- Executes on button press in pushbuttonWarp.
function pushbuttonWarp_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonWarp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Get handles info
I1 = handles.img1;

H = get(handles.uitableH,'Data');

newI = vgg_warp_H(I1, H, 'linear', 'fit');
figure;
imshow(newI);

guidata(hObject,handles);
