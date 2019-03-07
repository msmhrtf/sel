%  ==============================================================================
%  This file is part of the MSM-HRTF Selection application.
%                    
%               Copyright (c) 2019 by Michele Geronazzo, 
%  Department of Information Engineering, University of Padova - Italy
%                         https://dei.unipd.it
% 
%  The MSM-HRTF Selection application is free software: you can redistribute it and/or modify
%  it under the terms of the GNU General Public License as published by
%  the Free Software Foundation, either version 3 of the License, or
%  (at your option) any later version.
% 
%  The MSM-HRTF Selection application is distributed in the hope that it will be useful,
%  but WITHOUT ANY WARRANTY; without even the implied warranty of
%  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%  GNU General Public License for more details.
% 
%  You should have received a copy of the GNU General Public License
%  along with this software.  If not, see <https://www.gnu.org/licenses/>.
% 
%  If you use MSM-HRTF Selection:
%  - Provide credits:
%    "MSM-HRTF Selection, M. Geronazzo, DEI, UNIPD (https://github.com/msmhrtf/sel)"
%  - In your publication, do not forget to cite this article:
%    M. Geronazzo, E. Peruch, F. Prandoni, and F. Avanzini, 
%    “Applying a single-notch metric to image-guided head-related transfer function selection 
%    for improved vertical localization,” Journal of the Audio Engineering Society, 2019.
% 
%  Authors: Alberto Bedin, Michele Geronazzo, Fabio Prandoni and Enrico Peruch
% ==============================================================================


function varargout = drawParameters(varargin)
% DRAWPARAMETERS MATLAB code for drawParameters.fig
%      DRAWPARAMETERS, by itself, creates a new DRAWPARAMETERS or raises the existing
%      singleton*.
%
%      H = DRAWPARAMETERS returns the handle to a new DRAWPARAMETERS or the handle to
%      the existing singleton*.
%
%      DRAWPARAMETERS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DRAWPARAMETERS.M with the given input arguments.
%
%      DRAWPARAMETERS('Property','Value',...) creates a new DRAWPARAMETERS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before drawParameters_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to drawParameters_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help drawParameters

% Last Modified by GUIDE v2.5 06-Feb-2017 16:28:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @drawParameters_OpeningFcn, ...
                   'gui_OutputFcn',  @drawParameters_OutputFcn, ...
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





% --- Executes just before drawParameters is made visible.
function drawParameters_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to drawParameters (see VARARGIN)

% Choose default command line output for drawParameters
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%LOAD

defPars=load('defaultParameters.mat');
set(handles.NEditText, 'String', defPars.N);
set(handles.MEditText, 'String', defPars.M);
set(handles.KEditText, 'String', defPars.K);
set(handles.PixEditText, 'String', defPars.Pix);


% --- Outputs from this function are returned to the command line.
function varargout = drawParameters_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function NEditText_Callback(hObject, eventdata, handles)
% hObject    handle to NEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NEditText as text
%        str2double(get(hObject,'String')) returns contents of NEditText as a double


% --- Executes during object creation, after setting all properties.
function NEditText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function KEditText_Callback(hObject, eventdata, handles)
% hObject    handle to KEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of KEditText as text
%        str2double(get(hObject,'String')) returns contents of KEditText as a double


% --- Executes during object creation, after setting all properties.
function KEditText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to KEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MEditText_Callback(hObject, eventdata, handles)
% hObject    handle to MEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MEditText as text
%        str2double(get(hObject,'String')) returns contents of MEditText as a double


% --- Executes during object creation, after setting all properties.
function MEditText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3


% --- Executes on button press in confirmButton.
function confirmButton_Callback(hObject, eventdata, handles)


%WRITE
N = get(handles.NEditText, 'String');
M = get(handles.MEditText, 'String');
K = get(handles.KEditText, 'String');
Pix=get(handles.PixEditText, 'String');
save('defaultParameters.mat','N');
save('defaultParameters.mat','K','-append');
save('defaultParameters.mat','M','-append');
save('defaultParameters.mat','Pix','-append');

hand=getappdata(0,'hand');
set(hand.NEditText, 'String', N);
set(hand.KEditText, 'String', K);
set(hand.MEditText, 'String', M);
set(drawParameters,'visible','off');



% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%set(subjects,'visible','on');
%set(drawParameters,'visible','off');
%Hint: delete(hObject) closes the figure
delete(hObject);



function PixEditText_Callback(hObject, eventdata, handles)
% hObject    handle to PixEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PixEditText as text
%        str2double(get(hObject,'String')) returns contents of PixEditText as a double


% --- Executes during object creation, after setting all properties.
function PixEditText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PixEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
