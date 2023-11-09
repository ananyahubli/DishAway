function varargout = Begin(varargin)
% BEGIN MATLAB code for Begin.fig
%      BEGIN, by itself, creates a new BEGIN or raises the existing
%      singleton*.
%
%      H = BEGIN returns the handle to a new BEGIN or the handle to
%      the existing singleton*.
%
%      BEGIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BEGIN.M with the given input arguments.
%
%      BEGIN('Property','Value',...) creates a new BEGIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Begin_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Begin_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2014 The MathWorks, Inc.

% Edit the above text to modify the response to help Begin

% Last Modified by GUIDE v2.5 02-Nov-2023 21:18:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Begin_OpeningFcn, ...
                   'gui_OutputFcn',  @Begin_OutputFcn, ...
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


% --- Executes just before Begin is made visible.
function Begin_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Begin (see VARARGIN)

% Choose default command line output for Begin
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Begin wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Begin_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btn_Begin.
% This is the button that acutally starts the simulation 
function btn_Begin_Callback(hObject, eventdata, handles)
% hObject    handle to btn_Begin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close Begin; 
Decide
