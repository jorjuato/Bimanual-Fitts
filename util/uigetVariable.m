function varargout = uigetVariable(varargin)

% shows a dialogue box that lists variables in workspace
% and returns the selected variable

% varargin{1} specifies which variables to display: 
% numeric ('isnumeric') or cell ('iscell')...

% written by r.schleicher (at uni-koeln.de)

% UIGETVARIABLE M-file for uigetVariable.fig
%      UIGETVARIABLE, by itself, creates a new UIGETVARIABLE or raises the existing
%      singleton*.
%
%      H = UIGETVARIABLE returns the handle to a new UIGETVARIABLE or the handle to
%      the existing singleton*.
%
%      UIGETVARIABLE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UIGETVARIABLE.M with the given input arguments.
%
%      UIGETVARIABLE('Property','Value',...) creates a new UIGETVARIABLE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before uigetVariable_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to uigetVariable_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help uigetVariable

% Last Modified by GUIDE v2.5 22-Sep-2005 16:33:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uigetVariable_OpeningFcn, ...
                   'gui_OutputFcn',  @uigetVariable_OutputFcn, ...
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


% --- Executes just before uigetVariable is made visible.
function uigetVariable_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to uigetVariable (see VARARGIN)

% Choose default command line output for uigetVariable
% varargin{1} specifies which variables to display numeric ('isnumeric') or cell ('iscell')
handles.output = hObject;

%display variables of a certain type only
%{
vars = evalin('base','who');
    flag=[]; 
    for i=1:size(vars,1) %select only numerical variables...
        flag=[flag evalin('base',[varargin{1} '(' vars{i} ')'])];
        %flag=[flag evalin('base',['isnumeric' '(' vars{i} ')'])];
    end;
    vars=vars(logical(flag),:);
    set(handles.lbVariables,'String',vars) 
%}
vars = evalin('base','whos');
    flag=[]; 
    for i=1:size(vars,1) %select only numerical variables...
        flag=[flag evalin('base',[varargin{1} '(' vars(i).name ')'])];
        %flag=[flag evalin('base',['isnumeric' '(' vars{i} ')'])];
    end;
    vars=vars(logical(flag),:); 
    
    for i=1:size(vars,1) %make new string that also shows variable size and type...
        vars2{i}=[vars(i).name ' :   ' '<' num2str(vars(i).size(1)) 'x' num2str(vars(i).size(2))...
                    ' ' vars(i).class '>'];
    end
    set(handles.lbVariables,'String',vars2) 

% Update handles structure
if nargin>4 %first user-defined input argument (varargin{1}) is 4th in nargin
    set(gcf,'Name',varargin{2})
end
guidata(hObject, handles);

% UIWAIT makes uigetVariable wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = uigetVariable_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

% gibt es das feld ?
if(isfield(handles,'output'))  
    varargout{1} = handles.output;  
    close();
else
    varargout{1} = -1;
end

% --- Executes on selection change in lbVariables.
function lbVariables_Callback(hObject, eventdata, handles)
% hObject    handle to lbVariables (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns lbVariables contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lbVariables


% --- Executes during object creation, after setting all properties.
function lbVariables_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lbVariables (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pbOK.
function pbOK_Callback(hObject, eventdata, handles)
% hObject    handle to pbOK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
list_entries = get(handles.lbVariables,'String');
index_selected = get(handles.lbVariables,'Value');
variable=list_entries{index_selected}; %copy complete listbox entry
trimlimit=findstr(variable,' ');
variable=variable(1:(trimlimit(1)-1)); %trim string from list box until it only contains variable name
variable=evalin('base',variable); %copy workspace variable in local variable
handles.output=variable;
guidata(hObject,handles);
uiresume()



% --- Executes on button press in pbCancel.
function pbCancel_Callback(hObject, eventdata, handles)
% hObject    handle to pbCancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
varargout{1}=-1;
delete(gcf)



