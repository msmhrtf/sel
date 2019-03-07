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


function varargout = subjects(varargin)
% SUBJECTS M-file for subjects.fig
%      SUBJECTS, by itself, creates a new SUBJECTS or raises the existing
%      singleton*.
%
%      H = SUBJECTS returns the handle to a new SUBJECTS or the handle to
%      the existing singleton*.
%
%      SUBJECTS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SUBJECTS.M with the given input arguments.
%
%      SUBJECTS('Property','Value',...) creates a new SUBJECTS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before subjects_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to subjects_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help subjects

% Last Modified by GUIDE v2.5 09-May-2017 14:33:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @subjects_OpeningFcn, ...
                   'gui_OutputFcn',  @subjects_OutputFcn, ...
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


% --- Executes just before subjects is made visible.
function subjects_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to subjects (see VARARGIN)
    firstTime=getappdata(0,'firstTime');
    if(exist('defaultParameters.mat', 'file') && firstTime==1 )
        defPars=load('defaultParameters.mat');
        loadedK=defPars.K;
        loadedN=defPars.N;
        loadedM=defPars.M;
        set(handles.NEditText, 'String', loadedN);
        set(handles.KEditText, 'String', loadedK);
        set(handles.MEditText, 'String', loadedM);
        firstTime=0;
        setappdata(0,'firstTime',firstTime);
    end
    % Choose default command line output for subjects
    handles.output = hObject;
    
    
    %set(handles.addButton,'Enable','off');
    % Update handles structure
    guidata(hObject, handles);

    % Import data from subjects.mat files
    subjectsStruct = load('subjects');
    subjects = subjectsStruct.subjects;

    subjectsIdStruct = load('subjects_id');
    id = subjectsIdStruct.id;

    % Save variables for this application
    handles.subjects = subjects;
    handles.id = id;
    handles.dirty = 0;
    if ( ~isempty(subjects(:,1)) )
        handles.gender = subjects{1, 3};
    else
        handles.gender = 'M';
    end
    
    handles.trialsOrder = 'randomOrder';
%     set(handles.trialsOrderGroup,'selectedobject',handles.randomOrderButton)

    guidata(hObject,handles);

    subjectsListBox_Callback(hObject, eventdata, handles)
    drawListBox(hObject, handles);


% UIWAIT makes subjects wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = subjects_OutputFcn(~, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes during object creation, after setting all properties.
function subjectsListBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subjectsListBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in deleteButton.
function deleteButton_Callback(hObject, eventdata, handles)
% hObject    handle to deleteButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    selected = get(handles.subjectsListBox,'Value');
    subjects = handles.subjects;
    if ( isempty(subjects(:,1)) ),
        return;
    else
        numOfRecords = length(subjects(:,1));
        if ( selected > numOfRecords )
            return;
        end
        subjects(selected,:) = [];
    end
    
    handles.subjects = subjects;
    handles.dirty = 1;
    guidata(hObject,handles);
    drawListBox(hObject, handles);
        
% --- Updates ListBox content.    
function drawListBox(hObject, handles)
% hObject    handle to deleteButton (see GCBO)
% handles    structure with handles and user data (see GUIDATA)
    subjects = handles.subjects;
    selected = get(handles.subjectsListBox,'Value');
    if ( isempty(subjects(:,1))),
        recordsAsStrings = {'Database empty'};
        set(handles.lastNameText, 'String', '');
        set(handles.firstNameText, 'String', '');
        set(handles.ageText, 'String', '');
        set(handles.maleRB,'Value',1);
        handles.gender = 'M';
        set(handles.chooseImgButton,'Enable','off');
        set(handles.traceEarButton,'Enable','off');
        set(handles.TraceDistance,'Enable','off');
        set(handles.scaleMenu,'Enable','off');
        set(handles.cropMenu,'Enable','off');
        set(handles.rotateMenu,'Enable','off');
        set(handles.pixelToMeterMenu,'Enable','off');
        set(handles.revertImageMenu,'Enable','off');
        set(handles.deleteButton,'Enable','off');
        set(handles.updateButton,'Enable','off');
        set(handles.startExperimentButton,'Enable','off');
    else
        subjects = sortrows(subjects, [1, 2]);
        numOfRecords = length(subjects(:,1));
        numOfFields = length(subjects(1,:));
        recordsAsStrings = cell(numOfRecords, numOfFields);
        for i = 1:numOfRecords,
            recordsAsStrings{i} = horzcat(recordsAsStrings{i}, subjects{i,1},' ', ...
                                          subjects{i,2}, ' ', subjects{i,3}, ' ', ...
                                          subjects{i,4}, ' (id: ', int2str(subjects{i,6}) ,')');
        end
    end
    set(handles.subjectsListBox,'String',recordsAsStrings(:), 'Value',1);
    if ( ~isempty(subjects(:,1)) && selected > numOfRecords )
        selected = numOfRecords;
    end
    set(handles.subjectsListBox,'Value', selected);
    
    if ( ~isempty(subjects(:,1)) ),
        drawEarImage(handles, 0);
    end
    
    % Save variables for this application
    handles.subjects = subjects;
    guidata(hObject,handles);
    
    % Debug purpose
    assignin('base','handles',handles)




% --- Executes during object creation, after setting all properties.
function lastNameText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lastNameText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in addButton.
function addButton_Callback(hObject, eventdata, handles)
% hObject    handle to addButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    subjects = handles.subjects;
    lastName = get(handles.lastNameText, 'String');
    firstName = get(handles.firstNameText, 'String');
    age = get(handles.ageText, 'String');
    
    if ( isempty(lastName) || isempty(firstName) || isempty(age) ),
        msgbox('In order to add a new subject, please insert all required data.', ...
                'Empty field','warn');
        return;
    end
    
    [~, status] = str2num(age);
    if ( ~status ),
        msgbox('Age must be a numeric value.', ...
                'Bad input','warn');
        return;
    end
    
    numOfRecords = length(subjects(:,1));
    subjects{numOfRecords+1,1} = lastName;
    subjects{numOfRecords+1,2} = firstName;
    subjects{numOfRecords+1,3} = handles.gender;
    subjects{numOfRecords+1,4} = age;
    subjects{numOfRecords+1,5} = '';
    subjects{numOfRecords+1,6} = handles.id + 1 ;
    
    set(handles.chooseImgButton,'Enable','on');
    set(handles.deleteButton,'Enable','on');
    set(handles.updateButton,'Enable','on');
 
    % Save variables for this application
    handles.id = handles.id + 1 ;
    handles.subjects = subjects;
    handles.dirty = 1;
    guidata(hObject,handles);
    drawListBox(hObject, handles);

% --- Executes during object creation, after setting all properties.
function firstNameText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to firstNameText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function ageText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ageText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes when selected object is changed in genderButtonGroup.
function genderButtonGroup_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in genderButtonGroup 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
    guidata(hObject, handles);
    if ( hObject == handles.maleRB )
        gender = 'M';
    else
        gender = 'F';
    end
    handles.gender = gender;
    guidata(hObject,handles);
    
% --- Executes on button press in chooseImgButton.
function chooseImgButton_Callback(hObject, eventdata, handles)
% hObject    handle to chooseImgButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    [fn, pn] = uigetfile({'*.jpg;*.tif;*.png;*.gif;*.bmp','All Image Files';...
          '*.*','All Files' },'Choose ear image');
    if ( (isnumeric(fn) && fn == 0) || (isnumeric(pn) && pn == 0) )
        return;
    end;
    cd img;
    if ( ~exist(fn, 'file') ),
        msgbox('Please place the ear image in the img folder.', ...
                    'Invalid image path','warn');
        cd ..;
        return;
    end
    cd ..;
    selected = get(handles.subjectsListBox,'Value');
    subjects = handles.subjects;
    if ( strcmpi(fn,'blank.png') )
        subjects{selected,5} = '';
        set(handles.traceEarButton,'Enable','off');
        set(handles.TraceDistance,'Enable','off');
        set(handles.scaleMenu,'Enable','off');
        set(handles.cropMenu,'Enable','off');
        set(handles.rotateMenu,'Enable','off');
        set(handles.pixelToMeterMenu,'Enable','off');
        set(handles.revertImageMenu,'Enable','off');
    else
        subjects{selected,5} = fn;
        sep = filesep;
        [path, name, ext] = fileparts([pn sep fn]);
        image= imread([path, name, ext]);
        imwrite(image, [path sep name '_orig' ext])
        set(handles.traceEarButton,'Enable','on');
        set(handles.TraceDistance,'Enable','on');
        set(handles.scaleMenu,'Enable','on');
        set(handles.cropMenu,'Enable','on');
        set(handles.rotateMenu,'Enable','on');
        set(handles.pixelToMeterMenu,'Enable','on');
        set(handles.revertImageMenu,'Enable','on');
    end
    handles.subjects = subjects;
    handles.dirty = 1;
    guidata(hObject,handles);
    
    drawEarImage(handles, 0);


% --- Executes on button press in updateButton.
function updateButton_Callback(hObject, eventdata, handles)
% hObject    handle to updateButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    subjects = handles.subjects;
    selected = get(handles.subjectsListBox,'Value');
    numOfRecords = length(subjects(:,1));
    if ( selected > numOfRecords ),
        return;
    end
    
    lastName = get(handles.lastNameText, 'String');
    firstName = get(handles.firstNameText, 'String');
    age = get(handles.ageText, 'String');
    
    if ( isempty(lastName) || isempty(firstName) || isempty(age) ),
        msgbox('In order to edit a subject, please insert all required data.', ...
                'Empty field','warn');
        return;
    end
    
    [~, status] = str2num(age);
    if ( ~status ),
        msgbox('Age must be a numeric value.', ...
                'Bad input','warn');
        return;
    end
    
    subjects{selected,1} = lastName;
    subjects{selected,2} = firstName;
    subjects{selected,3} = handles.gender;
    subjects{selected,4} = age;
    
    % Save variables for this application
    handles.subjects = subjects;
    handles.dirty = 1;
    guidata(hObject,handles);
    drawListBox(hObject, handles);


% --------------------------------------------------------------------
function saveMenu_Callback(hObject, eventdata, handles)
% hObject    handle to saveMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    saveToFileSystem(hObject, handles, 1);
    handles.dirty = 0;
    guidata(hObject, handles);

% --------------------------------------------------------------------
function closeMenu_Callback(hObject, eventdata, handles)
% hObject    handle to closeMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    close(handles.figure1);


% --- Executes on selection change in subjectsListBox.
function subjectsListBox_Callback(hObject, eventdata, handles)
    subjects = handles.subjects;
    selected = get(handles.subjectsListBox,'Value');
    numOfRecords = length(subjects(:,1));
    
    if ( selected > numOfRecords ),
        set(handles.lastNameText, 'String', '');
        set(handles.firstNameText, 'String', '');
        set(handles.ageText, 'String', '');
        set(handles.maleRB,'Value',1);
        handles.gender = 'M';
        set(handles.addButton,'Enable','on');
        set(handles.chooseImgButton,'Enable','off')
        set(handles.traceEarButton,'Enable','off')
        set(handles.TraceDistance,'Enable','off');
        set(handles.scaleMenu,'Enable','off');
        set(handles.rotateMenu,'Enable','off');
        set(handles.cropMenu,'Enable','off');
        set(handles.pixelToMeterMenu,'Enable','off');
        set(handles.revertImageMenu,'Enable','off');
        set(handles.deleteButton,'Enable','off');
        set(handles.updateButton,'Enable','off');
        set(handles.startExperimentButton,'Enable','off');
        set(handles.AvgMismatchView,'Enable','off');
        set(handles.AvgRankView,'Enable','off');
        set(handles.MRankAppearanceView,'Enable','off');
        set(handles.AllResultsView,'Enable','off');
        set(handles.ScoreView,'Enable','off');
        drawEarImage(handles, 1);
              
        return;
    else
        set(handles.deleteButton,'Enable','on');
        set(handles.updateButton,'Enable','on');
        
    end
    
    set(handles.lastNameText, 'String', subjects{selected,1});
    set(handles.firstNameText, 'String', subjects{selected,2});
    set(handles.ageText, 'String', subjects{selected,4});
    if ( strcmpi( subjects{selected,3}, 'M' ) )
        set(handles.maleRB,'Value',1);
        handles.gender = 'M';
    else
        set(handles.femaleRB,'Value',1);
        handles.gender = 'F';
    end
    
    drawEarImage(handles, 0);
    
    set(handles.chooseImgButton,'Enable','on');
    set(handles.deleteButton,'Enable','on');
    set(handles.updateButton,'Enable','on');
    set(handles.startExperimentButton,'Enable','on');
    if ( isempty(subjects{selected,5}) ),
        set(handles.traceEarButton,'Enable','off')
        set(handles.TraceDistance,'Enable','off');
        set(handles.startExperimentButton,'Enable','off');
        set(handles.scaleMenu,'Enable','off');
        set(handles.rotateMenu,'Enable','off');
        set(handles.cropMenu,'Enable','off');
        set(handles.pixelToMeterMenu,'Enable','off');
        set(handles.revertImageMenu,'Enable','off');
    else
        set(handles.traceEarButton,'Enable','on')
        set(handles.TraceDistance,'Enable','on');
        set(handles.scaleMenu,'Enable','on');
        set(handles.rotateMenu,'Enable','on');
        set(handles.cropMenu,'Enable','on');
        set(handles.pixelToMeterMenu,'Enable','on');
        set(handles.revertImageMenu,'Enable','on');
    end
    
    cd img;
    if ( exist(subjects{selected,5}, 'file') )
        [~, earDataFile, ~] = fileparts(subjects{selected,5}); 
        if ( ~exist( [earDataFile '.mat'], 'file') )
            set(handles.startExperimentButton,'Enable','off');
        end
    end
    cd ..;
    
    handles.subjects = subjects;
    guidata(hObject,handles);
    
%   Check results presence for view menu
    id = handles.subjects{selected,6};
    
    if (exist(['./results/' int2str(id) '/Overview.pdf']))
        set(handles.AllResultsView,'Enable','on');
    else
        set(handles.AllResultsView,'Enable','off');
    end
    


% --- Executes during object creation, after setting all properties.
function subjectListBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subjectsListBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function saveToFileSystem(hObject, handles, displayMsg)
    guidata(hObject, handles);
    subjects = handles.subjects;
    id = handles.id;
    save('subjects.mat' , 'subjects');
    save('subjects_id.mat', 'id');
    if (displayMsg)
        msgbox('Saved successfully.', ...
                    'Save','none');
    end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)

    if ( handles.dirty == 0 )
        delete(hObject);
        return;
    end
    choice = questdlg('The list has been edited. Do you want to save changes?', ...
        'Confirm changes', ...
        'Yes', 'No', 'Cancel', 'Cancel');
    switch choice
        case 'Yes'
            guidata(hObject, handles);
            saveToFileSystem(hObject, handles, 0);
            delete(hObject)
        case 'No'
            guidata(hObject, handles);
            delete(hObject)
        case 'Cancel'
            return;
    end
        
function drawEarImage(handles, blank)

    if ( blank ),
        cd img;
        absolutePath = which('blank.png');
        imshow(absolutePath,'Parent',gca);
        cd ..;
        return;
    end
    
    selected = get(handles.subjectsListBox,'Value');
    cd img;
    earImageName = handles.subjects{selected,5};
    if ( ~exist(earImageName, 'file') ),
        absolutePath = which('blank.png');
    else
        absolutePath = which(earImageName);
    end
    cd ..;
    imshow(absolutePath,'Parent',gca);


% --- Executes on button press in traceEarButton.
function traceEarButton_Callback(hObject, ~, handles)
% hObject    handle to traceEarButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    if (get(handles.C1Checkbox,'Value')==0 && get(handles.C2Checkbox,'Value')==0 && get(handles.C3Checkbox,'Value')==0)
        uiwait(msgbox('Select at least one contour before tracing!','Error','none'));
        return
    end
    selected = get(handles.subjectsListBox,'Value');
    cd img
    earImage = which(handles.subjects{selected,5}); % which give the path to the name of the image
    cd ..;
    
    setappdata(0,'row',selected);
    setappdata(0,'showDynamic',get(handles.showDynamic,'Value'));
    setappdata(0,'pathImage',earImage);
    setappdata(0,'C1Checkbox',get(handles.C1Checkbox,'Value'));
    setappdata(0,'C2Checkbox',get(handles.C2Checkbox,'Value'));
    setappdata(0,'C3Checkbox',get(handles.C3Checkbox,'Value'));
%     set(subjects,'visible','off');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if ( handles.dirty == 1 )
        guidata(hObject, handles);
        saveToFileSystem(hObject, handles, 0);
        
        %delete(hObject)
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    N=get(handles.NEditText,'String');
    N=str2num(N);
    K=get(handles.KEditText,'String');
    K=str2num(K);
    contour_trace(earImage, N,K);  %START CONTOUR TRACE 
        
    set(handles.startExperimentButton,'Enable','on');
    cd img;
        if ( exist(handles.subjects{selected,5}, 'file') )
            [~, earDataFile, ~] = fileparts(handles.subjects{selected,5}); 
            if ( ~exist( [earDataFile '.mat'], 'file') )
                set(handles.startExperimentButton,'Enable','off');
            end
        end
    cd ..;


function startExperimentButton_Callback(hObject, eventdata, handles)

    if ( handles.dirty == 1 )  
        choice = questdlg(['In order to proceed with this experiment, you need', ...
                            ' to save current changes. Do you want to continue? '], ...
            'Confirm changes', ...
            'Yes', 'Cancel', 'Cancel');
        switch choice
            case 'Yes'
                guidata(hObject, handles);
                saveToFileSystem(hObject, handles, 0);
                handles.dirty = 0;
                guidata(hObject, handles);
            case 'Cancel'
                return;
        end
    end
   
    
    %Find current selected ID
    selected = get(handles.subjectsListBox,'Value');
    id = handles.subjects{selected,6};  % 6 is the column ID of the struct "subjects"
    
    %Shared data between GUIs
    setappdata(0,'subjectsHandler',hObject);
    subjectsHandler = getappdata(0,'subjectsHandler');
    setappdata(subjectsHandler,'sharedID',id); 
    setappdata(0,'experimentConfigHandler',hObject);
    experimentConfigHandler = getappdata(0,'experimentConfigHandler');
    if ( ~(isfield(handles,'enablePureData')))
        setappdata(experimentConfigHandler,'enablePureData',1); 
    elseif ( handles.enablePureData == 1 )
        setappdata(experimentConfigHandler,'enablePureData',1); 
    else
        setappdata(experimentConfigHandler,'enablePureData',0); 
    end
    setappdata(experimentConfigHandler,'trialsOrder',handles.trialsOrder); 
   
    %saving checkboxes
    
    setappdata(0,'mediumMismatch',get(handles.mediumMismatch,'Value'));
    setappdata(0,'mediumRanked',get(handles.mediumRanked,'Value'));
    setappdata(0,'rankedPresence',get(handles.rankedPresence,'Value'));
    setappdata(0,'M',get(handles.MEditText, 'string'));
    setappdata(0,'C1Checkbox',get(handles.C1Checkbox,'Value'));
    setappdata(0,'C2Checkbox',get(handles.C2Checkbox,'Value'));
    setappdata(0,'C3Checkbox',get(handles.C3Checkbox,'Value'));
    setappdata(0,'ExtCheckbox',get(handles.ExtCheckbox,'Value'));
    setappdata(0,'IntCheckbox',get(handles.IntCheckbox,'Value'));
    experiment;
    
    id = handles.subjects{selected,6};
    
    if (exist(['./results/' int2str(id) '/Overview.pdf']))
        set(handles.AllResultsView,'Enable','on');
    else
        set(handles.AllResultsView,'Enable','off');
    end

    

% --------------------------------------------------------------------
function clearDBMenu_Callback(hObject, eventdata, handles)
% hObject    handle to clearDBMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    choice = questdlg(['All subject database entries will be removed. ', ...
                       'This action cannot be undone. Experiments results and ', ...
                       'ear tracing data will not be removed. ', ...
                        'Are you sure that you want to continue? '], ...
        'Confirm deletion', ...
        'Yes', 'No', 'No');
    switch choice
        case 'Yes'
            guidata(hObject, handles);
            handles.subjects = cell(0,6);
            saveToFileSystem(hObject, handles, 0);
            handles.dirty = 0;
            handles.selected = 1;
            set(handles.subjectsListBox,'Value', 1);
            guidata(hObject, handles);
            drawListBox(hObject, handles);
            drawEarImage(handles, 1)
        case 'No'
            return;
    end



function genderButtonGroup_CreateFcn(hObject, eventdata, handles)
%LEAVE THIS 


% --- Executes during object creation, after setting all properties.
function repetitionsText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to repetitionsText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --------------------------------------------------------------------

function scaleMenu_Callback(hObject, eventdata, handles)
% hObject    handle to scaleMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    selected = get(handles.subjectsListBox,'Value');
    cd img
    earImage = which(handles.subjects{selected,5});
    cd ..;
    imageEdit(earImage, 'scale');
    subjectsListBox_Callback(hObject, eventdata, handles);


% --------------------------------------------------------------------
function cropMenu_Callback(hObject, eventdata, handles)
% hObject    handle to cropMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    selected = get(handles.subjectsListBox,'Value');
    cd img
    earImage = which(handles.subjects{selected,5});
    cd ..;
    imageEdit(earImage, 'crop');
    subjectsListBox_Callback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function rotateMenu_Callback(hObject, eventdata, handles)
% hObject    handle to rotateMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    selected = get(handles.subjectsListBox,'Value');
    cd img
    earImage = which(handles.subjects{selected,5});
    cd ..;
    imageEdit(earImage, 'rotate');
    subjectsListBox_Callback(hObject, eventdata, handles);


% --------------------------------------------------------------------
function pixelToMeterMenu_Callback(hObject, eventdata, handles)
% hObject    handle to pixelToMeterMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    selected = get(handles.subjectsListBox,'Value');
    cd img
    earImage = which(handles.subjects{selected,5});
    cd ..;
    imageEdit(earImage, 'pixelToMeter');
    subjectsListBox_Callback(hObject, eventdata, handles);
    


% --------------------------------------------------------------------
function revertImageMenu_Callback(hObject, eventdata, handles)
% hObject    handle to revertImageMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    choice = questdlg(['Revert the image to its original state? All traces will be lost.'], ...
        'Confirm deletion', ...
        'Yes', 'No', 'No');
    switch choice
        case 'Yes'
            % Nothing to do here
        case 'No'
            return;
    end
    selected = get(handles.subjectsListBox,'Value');
    cd img
    earImage = which(handles.subjects{selected,5});
    [path, name, ext] = fileparts(earImage);
    sep = filesep;
    delete(earImage);
    if ( exist([path sep name '.mat'], 'file') )
        delete([path sep name '.mat']);
    end
    copyfile([path sep name '_orig' ext], [path sep name ext])
    cd ..;
    subjectsListBox_Callback(hObject, eventdata, handles);
    
   


% --- Executes during object creation, after setting all properties.
function partText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to partText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
    

% --------------------------------------------------------------------
function AllResultsView_Callback(hObject, eventdata, handles)
% hObject    handle to AllResultsView (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    selected = get(handles.subjectsListBox,'Value');
    id = handles.subjects{selected,6};
    open (['./results/' int2str(id) '/Overview.pdf'])


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


%Do NOT remove callbacks
function MEditText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to KEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function lastNameText_Callback(hObject, eventdata, handles)

function firstNameText_Callback(hObject, eventdata, handles)

function ageText_Callback(hObject, eventdata, handles)

function mediumMismatch_Callback(hObject, eventdata, handles)

function mediumRanked_Callback(hObject, eventdata, handles)

function rankedPresence_Callback(hObject, eventdata, handles)

function NEditText_Callback(hObject, eventdata, handles)

function MEditText_Callback(hObject, eventdata, handles)

function KEditText_Callback(hObject, eventdata, handles)

function showContoursCheckbox_Callback(hObject, eventdata, handles)

function Untitled_2_Callback(hObject, eventdata, handles)

function imageMenu_Callback(hObject, eventdata, handles)

function editMenu_Callback(hObject, eventdata, handles)

function ChangeDefPar_Callback(hObject, eventdata, handles)
setappdata(0,'hand',handles);
drawParameters;

function figure1_CreateFcn(hObject, eventdata, handles)
firstTime=1;
setappdata(0,'firstTime',firstTime);

%Creating DefaultPar
if ( ~exist('defaultParameters.mat', 'file') )
        N='10'; K='10'; M='3'; Pix='0.00026458333';
        save('defaultParameters.mat','N');
        save('defaultParameters.mat','K','-append');
        save('defaultParameters.mat','M','-append');
        save('defaultParameters.mat','Pix','-append');
end 




% --- Executes on button press in showDynamic.
function showDynamic_Callback(hObject, eventdata, handles)
% hObject    handle to showDynamic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of showDynamic


% --------------------------------------------------------------------
function ScoreView_Callback(hObject, eventdata, handles)
% hObject    handle to ScoreView (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    selected = get(handles.subjectsListBox,'Value');
    id = handles.subjects{selected,6};
    open (['./results/' int2str(id) '/Score.pdf'])


% --------------------------------------------------------------------
function trackDistance_Callback(hObject, eventdata, handles)
% hObject    handle to trackDistance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selected = get(handles.subjectsListBox,'Value');
    cd img
    earImage = which(handles.subjects{selected,5});
    cd ..;
    imageEdit(earImage, 'distance');
    subjectsListBox_Callback(hObject, eventdata, handles);


% --- Executes on button press in TraceDistance.
function TraceDistance_Callback(hObject, eventdata, handles)
% hObject    handle to TraceDistance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    selected = get(handles.subjectsListBox,'Value');
    cd img
    earImage = which(handles.subjects{selected,5}); % which give the path to the name of the image
    cd ..;
    
    setappdata(0,'row',selected);
    setappdata(0,'pathImage',earImage);
    setappdata(0,'ExtCheckbox',get(handles.ExtCheckbox,'Value'));
    setappdata(0,'IntCheckbox',get(handles.IntCheckbox,'Value'));
%     set(subjects,'visible','off');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if ( handles.dirty == 1 )
        guidata(hObject, handles);
        saveToFileSystem(hObject, handles, 0);
        
        %delete(hObject)
    end
    distance_trace(earImage)
    


% --- Executes on button press in C1Checkbox.
function C1Checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to C1Checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of C1Checkbox


% --- Executes on button press in C2Checkbox.
function C2Checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to C2Checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of C2Checkbox


% --- Executes on button press in C3Checkbox.
function C3Checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to C3Checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of C3Checkbox


% --- Executes on button press in ExtCheckbox.
function ExtCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to ExtCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ExtCheckbox


% --- Executes on button press in IntCheckbox.
function IntCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to IntCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of IntCheckbox
