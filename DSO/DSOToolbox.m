%______________________________________________________________________________________________
%  DRONE SQUADRON OPTIMIZATION Algorithm (DSO) toolbox                                                            
%  Source codes demo version 1.0
%                                                                                                     
%  Developed in Octave 3.8. Compatible with MATLAB 2011
%                                                                                                     
%  Author and programmer: Vinicius Veloso de Melo
%                                                                                                     
%         e-Mail: dr.vmelo@gmail.com                                                             
%                 vinicius.melo@unifesp.br                                               
%                                                                                                     
%       Homepage: http://www.sjc.unifesp.br/docente/vmelo/                                                         
%                                                                                                     
%  Main paper:                                                                                        
%  de Melo, V.V. & Banzhaf, W. Neural Comput & Applic (2017). doi:10.1007/s00521-017-2881-3
%  link.springer.com/article/10.1007/s00521-017-2881-3
%_______________________________________________________________________________________________


function varargout = DSOToolbox(varargin)
% DSOTOOLBOX MATLAB code for DSOToolbox.fig
%      DSOTOOLBOX, by itself, creates a new DSOTOOLBOX or raises the existing
%      singleton*.
%
%      H = DSOTOOLBOX returns the handle to a new DSOTOOLBOX or the handle to
%      the existing singleton*.
%
%      DSOTOOLBOX('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DSOTOOLBOX.M with the given input arguments.
%
%      DSOTOOLBOX('Property','Value',...) creates a new DSOTOOLBOX or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the DSOTOOLBOX before DSOToolbox_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DSOToolbox_OpeningFcn via varargin.
%
%      *See DSOTOOLBOX Options on GUIDE's Tools menu.  Choose "DSOTOOLBOX allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DSOToolbox

% Last Modified by GUIDE v2.5 26-Jun-2017 22:51:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'DSOToolbox_OpeningFcn', @DSOToolbox_OpeningFcn, ...
                   'DSOToolbox_OutputFcn',  @DSOToolbox_OutputFcn, ...
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


% --- Executes just before DSOToolbox is made visible.
function DSOToolbox_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DSOToolbox (see VARARGIN)

% Choose default command line output for DSOToolbox
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DSOToolbox wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DSOToolbox_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Run.
function Run_Callback(hObject, eventdata, handles)
% hObject    handle to Run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% OBJECTIVE FUNCTION CONFIGURATION 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    nDim = str2num(get(handles.txt_DIM,'String'));                    % number of variables
    UB = ones(1, nDim) .* str2num(get(handles.txt_UB,'String'));   % upper bounds
    LB = ones(1, nDim) .* str2num(get(handles.txt_LB,'String'));   % lower bounds

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% DSO CONFIGURATION
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    setup.C1 = str2num(get(handles.txt_C1,'String'));             % constants to be used in the formulas
    setup.C2 = str2num(get(handles.txt_C2,'String'));
    setup.C3 = str2num(get(handles.txt_C3,'String'));

    setup.N_Teams = str2num(get(handles.txt_N_Teams,'String'));          % number of teams
    setup.N = str2num(get(handles.txt_N,'String'));                % number of drones per team
    setup.checkBounds = get(handles.rb_Check_Bounds,'Value');      % shall it check for violations and correct the solutions?

    setup.Command_Center_Iter = str2num(get(handles.txt_Command_Center_Iter,'String')); % the Command Center updates the firmware at every 10 iterations
    setup.MaxStagnation = str2num(get(handles.txt_MaxStagnation,'String'));  % The maximum iterations without improvement to consider not stagnated
    setup.Pacc = str2num(get(handles.txt_Pacc,'String'));           % The probability of accepting a worse solution when search stagnates
    setup.ConvThres = 1e-200;    % Threshold to restart if there is a population convergence according to the objective function values


    setup.VTR = str2num(get(handles.txt_VTR,'String'));          % value-to-reach
    setup.ReportLag = str2num(get(handles.txt_ReportLag,'String'));       % report at every 10 iterations
    setup.MaxEvaluations = str2num(get(handles.txt_MaxEvaluations,'String'));  % stopping criterion
    setup.MaxIterations = floor(setup.MaxEvaluations / (setup.N * setup.N_Teams)); % maximum number of iterations. This does not consider the possible restarts
    
    setup.Toolbox = true;
    setup.handles = handles;
    
    set(handles.txt_LOG,'String', 'Starting DSO...');
    set(handles.txt_LOG,'ListboxTop', 1);

    cla(handles.axes1);
    reset(handles.axes1);
    box on;

    tic() 
    [Solution, Value, CurveOFV, Evaluations, StopMessage, HistoryRanks] = DSO(@CostFunction, nDim, LB , UB, setup);
    toc()

    s = size(get(handles.txt_LOG,'String')) - 11;
    s = s(1);
    set(handles.txt_LOG, 'ListboxTop', max(1, s))


% --- Executes on button press in btn_Reset.
function btn_Reset_Callback(hObject, eventdata, handles)
% hObject    handle to btn_Reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    set(handles.txt_DIM,'String', num2str(5));
    set(handles.txt_UB,'String', '10.0');
    set(handles.txt_LB,'String', '-10.0');
    set(handles.txt_C1,'String', num2str(0.9));
    set(handles.txt_C2,'String', num2str(0.4));
    set(handles.txt_C3,'String', num2str(0.5));
    set(handles.txt_N_Teams,'String', num2str(4));
    set(handles.txt_N,'String', num2str(25));
    set(handles.rb_Check_Bounds, 'Value', 1.0);
    set(handles.txt_Command_Center_Iter,'String', num2str(10));
    set(handles.txt_MaxStagnation,'String', num2str(10));
    set(handles.txt_Pacc,'String', num2str(0.1));
    set(handles.txt_VTR,'String', '1e-8');
    set(handles.txt_MaxEvaluations,'String', num2str(50000));
    set(handles.txt_ReportLag,'String', num2str(50));
    


function txt_DIM_Callback(hObject, eventdata, handles)
% hObject    handle to txt_DIM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_DIM as text
%        str2double(get(hObject,'String')) returns contents of txt_DIM as a double



% --- Executes during object creation, after setting all properties.
function txt_DIM_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_DIM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txt_UB_Callback(hObject, eventdata, handles)
% hObject    handle to txt_UB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_UB as text
%        str2double(get(hObject,'String')) returns contents of txt_UB as a double


% --- Executes during object creation, after setting all properties.
function txt_UB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_UB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txt_LB_Callback(hObject, eventdata, handles)
% hObject    handle to txt_LB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_LB as text
%        str2double(get(hObject,'String')) returns contents of txt_LB as a double


% --- Executes during object creation, after setting all properties.
function txt_LB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_LB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_Teams.
function btn_Teams_Callback(hObject, eventdata, handles)
% hObject    handle to btn_Teams (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of btn_Teams


% --- Executes on button press in btn_Commander.
function btn_Commander_Callback(hObject, eventdata, handles)
% hObject    handle to btn_Commander (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of btn_Commander


% --- Executes on button press in togglebutton3.
function togglebutton3_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton3


function txt_C1_Callback(hObject, eventdata, handles)
% hObject    handle to txt_C1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_C1 as text
%        str2double(get(hObject,'String')) returns contents of txt_C1 as a double


% --- Executes during object creation, after setting all properties.
function txt_C1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_C1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txt_C2_Callback(hObject, eventdata, handles)
% hObject    handle to txt_C2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_C2 as text
%        str2double(get(hObject,'String')) returns contents of txt_C2 as a double


% --- Executes during object creation, after setting all properties.
function txt_C2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_C2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txt_C3_Callback(hObject, eventdata, handles)
% hObject    handle to txt_C3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_C3 as text
%        str2double(get(hObject,'String')) returns contents of txt_C3 as a double


% --- Executes during object creation, after setting all properties.
function txt_C3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_C3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txt_Command_Center_Iter_Callback(hObject, eventdata, handles)
% hObject    handle to txt_Command_Center_Iter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_Command_Center_Iter as text
%        str2double(get(hObject,'String')) returns contents of txt_Command_Center_Iter as a double


% --- Executes during object creation, after setting all properties.
function txt_Command_Center_Iter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_Command_Center_Iter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txt_MaxStagnation_Callback(hObject, eventdata, handles)
% hObject    handle to txt_MaxStagnation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_MaxStagnation as text
%        str2double(get(hObject,'String')) returns contents of txt_MaxStagnation as a double


% --- Executes during object creation, after setting all properties.
function txt_MaxStagnation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_MaxStagnation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txt_Pacc_Callback(hObject, eventdata, handles)
% hObject    handle to txt_Pacc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_Pacc as text
%        str2double(get(hObject,'String')) returns contents of txt_Pacc as a double


% --- Executes during object creation, after setting all properties.
function txt_Pacc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_Pacc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txt_N_Teams_Callback(hObject, eventdata, handles)
% hObject    handle to txt_N_Teams (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_N_Teams as text
%        str2double(get(hObject,'String')) returns contents of txt_N_Teams as a double


% --- Executes during object creation, after setting all properties.
function txt_N_Teams_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_N_Teams (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txt_N_Callback(hObject, eventdata, handles)
% hObject    handle to txt_N (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_N as text
%        str2double(get(hObject,'String')) returns contents of txt_N as a double


% --- Executes during object creation, after setting all properties.
function txt_N_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_N (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in rb_Check_Bounds.
function rb_Check_Bounds_Callback(hObject, eventdata, handles)
% hObject    handle to rb_Check_Bounds (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rb_Check_Bounds



function txt_VTR_Callback(hObject, eventdata, handles)
% hObject    handle to txt_VTR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_VTR as text
%        str2double(get(hObject,'String')) returns contents of txt_VTR as a double


% --- Executes during object creation, after setting all properties.
function txt_VTR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_VTR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txt_MaxEvaluations_Callback(hObject, eventdata, handles)
% hObject    handle to txt_MaxEvaluations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_MaxEvaluations as text
%        str2double(get(hObject,'String')) returns contents of txt_MaxEvaluations as a double


% --- Executes during object creation, after setting all properties.
function txt_MaxEvaluations_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_MaxEvaluations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txt_ReportLag_Callback(hObject, eventdata, handles)
% hObject    handle to txt_ReportLag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_ReportLag as text
%        str2double(get(hObject,'String')) returns contents of txt_ReportLag as a double


% --- Executes during object creation, after setting all properties.
function txt_ReportLag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_ReportLag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txt_LOG_Callback(hObject, eventdata, handles)
% hObject    handle to txt_LOG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_LOG as text
%        str2double(get(hObject,'String')) returns contents of txt_LOG as a double


% --- Executes during object creation, after setting all properties.
function txt_LOG_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_LOG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
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
