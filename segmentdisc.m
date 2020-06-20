function varargout = segmentdisc(varargin)
% SEGMENTDISC MATLAB code for segmentdisc.fig
%      SEGMENTDISC, by itself, creates a new SEGMENTDISC or raises the existing
%      singleton*.
%
%      H = SEGMENTDISC returns the handle to a new SEGMENTDISC or the handle to
%      the existing singleton*.
%
%      SEGMENTDISC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SEGMENTDISC.M with the given input arguments.
%
%      SEGMENTDISC('Property','Value',...) creates a new SEGMENTDISC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before segmentdisc_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to segmentdisc_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help segmentdisc

% Last Modified by GUIDE v2.5 08-Feb-2013 13:07:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @segmentdisc_OpeningFcn, ...
                   'gui_OutputFcn',  @segmentdisc_OutputFcn, ...
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


% --- Executes just before segmentdisc is made visible.
function segmentdisc_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to segmentdisc (see VARARGIN)

% Choose default command line output for segmentdisc
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes segmentdisc wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = segmentdisc_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in loaddata.
function loaddata_Callback(hObject, eventdata, handles)
% hObject    handle to loaddata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile;
datapath = 'D:\Sudhakar\spinecode\save\3Dcubedata';
%datapath = 'D:\Sudhakar\spinecode\save\L4L5segmentations';
savepath = 'D:\Sudhakar\spinecode\save\L4L5segmentations';

if ~exist(savepath, 'dir')
    mkdir(savepath);
end

handles.savepath = savepath;
handles.file = file;
load([datapath, '\', file]);
handles.lspine = lspine;

sliderMax = size(handles.lspine.vol, 1);
binaryIm = false(sliderMax, 512, 512);
if ~exist('disccontours', 'var')
    disccontours = cell(1, sliderMax);
    handles.disccontours = disccontours;
else
    disccontours
    handles.disccontours = disccontours;
end
handles.binaryIm = binaryIm;
clear lspine binaryIm

h = imshow(reshape(handles.lspine.vol(1, :, :), 512, 512));
set(h, 'CDataMapping', 'direct');
set(handles.viewSlider, 'Min', 1,'Max', sliderMax, 'SliderStep', [1,1]/(sliderMax-1), 'Value', 1);
%set(handles.figure1, 'toolbar', 'figure');
guidata(hObject, handles);


% --- Executes on button press in saveSegmentation.
function saveSegmentation_Callback(hObject, eventdata, handles)
% hObject    handle to saveSegmentation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Starts segmentaion slicewise

% Save
binaryIm = handles.binaryIm; lspine = handles.lspine; disccontours = handles.disccontours;
save([handles.savepath, '\', handles.file], 'binaryIm', 'lspine', 'disccontours');
fprintf('DiscSegmentationSaved\n\n');

% --- Executes on slider movement.
function trackSlice_Callback(hObject, eventdata, handles)
% hObject    handle to trackSlice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
sliderMin = get(hObject, 'Min'); % correct
sliderMax = get(hObject, 'Max'); % correct
sliderStep = get(hObject, 'SliderStep'); % correct
currentSliderStep = get(hObject, 'Value'); % correct, 1 at start

handles.step = round(currentSliderStep);
fprintf('Slice %d/%d\n\n', round(currentSliderStep), sliderMax);

% Plots the current MR Slice
slice = reshape(handles.lspine.vol(handles.step, :, :), 512, 512);
h = imshow(slice);
set(h, 'CDataMapping', 'direct');

% Plots the contours if exist already
po = handles.disccontours{handles.step};
if ~isempty(po)
    hold on
    plot(po(1,:), po(2,:), '-r');
end

% Get points from segmentations
[x, y] = getpoints(gca);
handles.disccontours{handles.step} =[x; y];
handles.disccontours
% handles.binaryIm(handles.step, :, :) = roipoly(slice, x, y);
clear slice x y
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function trackSlice_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trackSlice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in visualize.
function visualize_Callback(hObject, eventdata, handles)
% hObject    handle to visualize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

binaryIm = smooth3(single(handles.binaryIm), 'gaussian', 1);
figure
patch(isosurface(binaryIm, 0.5), 'FaceColor', [0.8 0.5 0.8], 'EdgeColor', 'none');
axis tight off
lighting gouraud

function [xs,ys] = getpoints(axishandle)

%============================================================================
% Find parent figure for the argument axishandle
%============================================================================
axes(axishandle);
figure(get(axishandle, 'Parent'));
%===========================================================================
% Change pointer shape
%===========================================================================
oldpointershape = get(gcf,'Pointer');

ptrc =  ones(16)+1;
ptrc( 1, :) = 1; 
ptrc(16, :) = 1; 
ptrc(: , 1) = 1; 
ptrc(: ,16) = 1; 
ptrc(1:4,8:9) = 1;
ptrc(8:9,1:4) = 1;
ptrc(13:16, 8:9 ) = 1;
ptrc( 8:9 ,13:16) = 1;
ptrc(5:12,5:12) = NaN;
%set(gcf,'Pointer', 'custom', 'PointerShapeCData', 	ptrc, 'PointerShapeHotSpot',[8 8]);

%===========================================================================
% Prepare for interactive collection of ROI boundary points
%===========================================================================
hold on
pointhandles = [];
xpts = [];
ypts = [];
splinehandle= [];
n = 0;
but = 1;
BUTN = 0;
KEYB = 1;
done =0;
%===========================================================================
% Loop until right hand mouse button or keayboard is pressed
%===========================================================================
while ~done;  
  %===========================================================================
  % Analyze each buttonpressed event
  %===========================================================================
  keyb_or_butn = waitforbuttonpress;
  if keyb_or_butn == BUTN;
    currpt = get(axishandle, 'CurrentPoint');
    seltype = get(gcf,'SelectionType');
    switch seltype 
    case 'normal',
      but = 1;
    case 'open',
      but = 1;
    case 'alt',
      but = 2;
    otherwise,
      but = 2;
    end;          
  elseif keyb_or_butn == KEYB
    but = 2;
  end; 
  if (n<4 && but==2)
      xs=[];
      ys=[];
      return;
  end
  %===========================================================================
  % Get coordinates of the last buttonpressed event
  %===========================================================================
  xi = currpt(2,1);
  yi = currpt(2,2);
  %===========================================================================
  % Start a spline throught the points or 
  % update the line through the points with a new spline
  %===========================================================================
  if but ==1
        if ~isempty(splinehandle)
           delete(splinehandle);
        end;
    	%pointhandles(n+1) = plot(xi,yi,'ro');
	n = n+1;
	xpts(n,1) = xi;
	ypts(n,1) = yi;
	%===========================================================================
	% Draw a spline line through the points
    %===========================================================================
	if n > 1
	  t = 1:n;
	  ts = 1: 0.1 : n;
	  xs = spline(t, xpts, ts);
	  ys = spline(t, ypts, ts);
      plot(xpts, ypts, '-o','LineStyle','none', 'MarkerEdgeColor','none','MarkerFaceColor', [.49 1 .63],'MarkerSize',4);
      hold on
	  splinehandle = plot(xs,ys,'-r');
	end;
  elseif but > 1
      %===========================================================================
	  % Exit for right hand mouse button or keyboard input
      %===========================================================================
      done = 1;
  end;
end;

%===========================================================================
% Add first point to the end of the vector for spline 
%===========================================================================
xpts(n+1,1) = xpts(1,1);
ypts(n+1,1) = ypts(1,1);

%===========================================================================
% (re)draw the final spline 
%===========================================================================
if ~ isempty(splinehandle)
    delete(splinehandle);
end;    

t = 1:n+1;
ts = 1: 0.25 : n+1;
xs = spline(t, xpts, ts);
ys = spline(t, ypts, ts);

plot(xpts, ypts, '-o','LineStyle', 'none', 'MarkerEdgeColor','none','MarkerFaceColor', [.49 1 .63], 'MarkerSize',4);
hold on
linehandle = plot(xs,ys,'-r');
drawnow;
%===========================================================================
% Delete the point markers 
%===========================================================================
if ~isempty(pointhandles)
    delete(pointhandles)
end;
%===========================================================================
% Reset pointershape 
%===========================================================================
set(gcf,'Pointer',oldpointershape);


% --- Executes on slider movement.
function viewSlider_Callback(hObject, eventdata, handles)
% hObject    handle to viewSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
sliderMin = get(hObject, 'Min'); % correct
sliderMax = get(hObject, 'Max'); % correct
sliderStep = get(hObject, 'SliderStep'); % correct
currentSliderStep = get(hObject, 'Value'); % correct, 1 at start

handles.step = round(currentSliderStep);
fprintf('Slice %d/%d\n\n', round(currentSliderStep), sliderMax);

% Plots the current MR Slice
slice = reshape(handles.lspine.vol(handles.step, :, :), 512, 512);
h = imshow(slice);
set(h, 'CDataMapping', 'direct');

po = handles.disccontours{handles.step};
if ~isempty(po)
    hold on
    plot(po(1,:), po(2,:), '-r');
end

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function viewSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to viewSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in rangeSegment.
function rangeSegment_Callback(hObject, eventdata, handles)
% hObject    handle to rangeSegment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
prompt = {'Enter start slice:','Enter end slice:'};
dlg_title = 'Range for Seg';
num_lines = 1;
def = {'1','200'};
answer = inputdlg(prompt,dlg_title,num_lines,def);
start = str2double(answer{1}); last = str2double(answer{2});
set(handles.trackSlice, 'Min', start,'Max', last, 'SliderStep', [1,1]/(last-1), 'Value', start);
guidata(hObject, handles);
