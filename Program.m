%------------------------------------------------------------------%
% Matlab 2012 (Edition Ra)  
% 
%
% �������� �� ����� ��������� ���� ���� ����� ���������
% ��� �� ��������� ����������� ��� ���������� ��� �����������
% mfiles
%
% Written by Minella Kotsollari & Aleksandros Kesar
%
%------------------------------------------------------------------%

function varargout = Program(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Program_OpeningFcn, ...
                   'gui_OutputFcn',  @Program_OutputFcn, ...
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



% --- Executes just before Program is made visible.
function Program_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;

guidata(hObject, handles);



% --- Outputs from this function are returned to the command line.
function varargout = Program_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in Energeia1.
function Energeia1_Callback(hObject, eventdata, handles)

%�������� �� �� ������ ��� ������ �������� ("������� ��������")

global RunEnergeia1; % ��� �� ��� ���� ������ ��� � ���������
global InProgress;  % ��� �� ��� ������ ���� ��������� ��������� ��� �� �������
global time1;  % � ������ ��� ���������� ��� ��� �������� ��� �����������

% ������������ ��� ������������� ���������� ����������� �� ����� ������ � �������� ����

TF = isempty(InProgress);
if(TF==1)
	InProgress=4;
end
if(InProgress~=2)
ClockStart = clock;
	InProgress=2;
	didfinish=0;
	steps = 100; % ��������� ��������� ��� ��� ��������� ��� Waitbar
	h = waitbar(0,'Please wait...','name','Loading','CreateCancelBtn',...
				'setappdata(gcbf,''canceling'',1)');
				setappdata(h,'canceling',0)
				
	xyloObj = VideoReader('movie.wmv');
	nFrames = 100; % � ������� ��� �������� ��� ��� �����������
	vidHeight = xyloObj.Height;
	vidWidth = xyloObj.Width;

	global EntropyOfFrames; % �������� ��� ��������
	global CounterOfEntropyOfFrames; % ��������� ��������� ��������� ��� ��������
	CounterOfEntropyOfFrames=0;

	mov(1:nFrames) = ...
		struct('cdata', zeros(vidHeight, vidWidth, 3, 'uint8'),...
			   'colormap', []);
	for k = 1 : nFrames
		if getappdata(h,'canceling') % �� ��������� "cancel", ������ ��� ��� ���������
			CounterOfEntropyOfFrames=0;
			break;
		end
		mov(k).cdata = read(xyloObj, k);
		% �������� ��������� ���������
		EntropyOfFrames(k)=entropy(rgb2gray(mov(1,k).cdata));
		CounterOfEntropyOfFrames = CounterOfEntropyOfFrames + EntropyOfFrames(k);
		M = mod(k,5);
			if(M == 0)
				waitbar(k/steps,h,sprintf('%d%s',k,'%'))
			end
			if(k==nFrames)
				didfinish=1;
			end
	end
	delete(h); % �������� ��� waitbar
	% ������� ��� �� ��� ������������ � ����������
	if(didfinish==1)
		hf = figure;
		set(hf,'name','Movie','numbertitle','off')
		set(hf, 'position', [150 150 vidWidth vidHeight])
		movie(hf, mov, 1, xyloObj.FrameRate);
	end
	if(k==nFrames)
		RunEnergeia1=1;
	end
	ClockEnd = clock;
	TimeElapsed = etime(ClockEnd,ClockStart)/60;% ��������� ��� etime ��� ������������ �� �����
	time1=TimeElapsed;
	InProgress=0;
else
	errordlg('At this time, some other action is in process. Please progress after the action is finished.','Error','Error Icon')
end


% --- Executes on button press in Energeia2.
function Energeia2_Callback(hObject, eventdata, handles)

%�������� �� �� ������ ��� ������ �������� ("1�� ����������")


global InProgress; % ��� �� ��� ������ ���� ��������� ��������� ��� �� �������
global RunEnergeia2; % ��� �� ��� ���� ������ ��� � ���������
global time2; % � ������ ��� ���������� ��� ��� �������� ��� �����������

% ������������ ��� ������������� ���������� ����������� �� ����� ������ � �������� ����

TF = isempty(InProgress);
if(TF==1)
	InProgress=4;
end
if(InProgress~=2)
ClockStart = clock;
	InProgress=2;
	h = waitbar(0,'Please wait...','name','Algorithm 1 in Progress','CreateCancelBtn',...
				'setappdata(gcbf,''canceling'',1)');
				setappdata(h,'canceling',0)
	steps = 100;% ��������� ��������� ��� ��� ��������� ��� Waitbar
	xyloObj = VideoReader('movie.wmv');
	nFrames = 100;% � ������� ��� �������� ��� ��� �����������
	vidHeight = xyloObj.Height;
	vidWidth = xyloObj.Width;


	mov(1:nFrames) = ...
		struct('cdata', zeros(vidHeight, vidWidth, 3, 'uint8'),...
			   'colormap', []);
	for k = 1 : nFrames
			  mov(k).cdata = read(xyloObj, k);  	  
	end

	didfinish=0;% ��������� ��������� ��� �� ��� ������������� � ��� � ����������
	for k=1:nFrames-1
		if getappdata(h,'canceling')
		break
		end
		Diff(:,:,:,k)=imabsdiff(rgb2gray(mov(k+1).cdata),rgb2gray(mov(k).cdata));% ������� ������� ������ ��� ��������
		M = mod(k,5);
		if(M == 0)
		waitbar(k/steps,h,sprintf('%d%s',k,'%'))
		end
		if(k==99)
			didfinish=1;
		end
	end

	global EntropyOfDiffFrames; % �������� ��� ��������
	global CounterOfEntropyOfDiffFrames; % ��������� ��������� ��������� ��� �������� ���������
	CounterOfEntropyOfDiffFrames=0;
	if(didfinish==1)
		for k=1:nFrames-1 
			EntropyOfDiffFrames(k)=entropy(Diff(:,:,k));
			CounterOfEntropyOfDiffFrames= CounterOfEntropyOfDiffFrames+EntropyOfDiffFrames(k);
		end
	end
	delete(h); % �������� ��� waitbar
	if(didfinish==1) 
		implay(Diff) % ������� ��� �������� ���������
		set(findall(0,'tag','spcui_scope_framework'),'position',[100 100 900 550]);
		RunEnergeia2=1;
	end
	ClockEnd = clock;
	TimeElapsed = etime(ClockEnd,ClockStart)/60;%in minutes
	time2=TimeElapsed;
	InProgress=0;
else
	errordlg('At this time, some other action is in progress. Please proceed after the action is finished.','Error','Error Icon')
end



% --- Executes on button press in Energeia3.
function Energeia3_Callback(hObject, eventdata, handles)

%�������� �� �� ������ ��� ������ �������� ("2�� ����������")

global InProgress; % ��� �� ��� ������ ���� ��������� ��������� ��� �� �������
global RunEnergeia3; % ��� �� ��� ���� ������ ��� � ���������
global time3; % � ������ ��� ���������� ��� ��� �������� ��� �����������

% ������������ ��� ������������� ���������� ����������� �� ����� ������ � �������� ����

TF = isempty(InProgress);
if(TF==1)
	InProgress=4;
end
if(InProgress~=2)
ClockStart= clock;
	InProgress=2;
	h = waitbar(0,'Please wait...','name','Algorithm 2 In Progress','CreateCancelBtn',...
				'setappdata(gcbf,''canceling'',1)');
				setappdata(h,'canceling',0)
	steps = 100;
	xyloObj = VideoReader('movie.wmv');
	nFrames = 100; % � ������� ��� �������� ��� ��� �����������
	vidHeight = xyloObj.Height;
	vidWidth = xyloObj.Width;


	mov(1:nFrames) = ...
		struct('cdata', zeros(vidHeight, vidWidth, 3, 'uint8'),...
			   'colormap', []);
	for k = 1 : nFrames
			  mov(k).cdata = read(xyloObj, k);  	  
	end

	didfinish=0;% ��������� ��������� ��� �� ��� ������������ � ����������
	for k=1:nFrames-1
		if getappdata(h,'canceling')
		break
		end
		frame1=rgb2gray(mov(1,k).cdata); % ������� ��� �������������� �������� (Frame I)
		frame2=rgb2gray(mov(1,k+1).cdata); % ������� ������ (Target Frame)
		officialframe2 = imcrop(frame2,[0 0 848 848]);
		% Cast ������� �� double ����������� �� ��������� ������� �� ������� ������ �����.
		x1=double(rgb2gray(mov(1,k).cdata));
		x2=double(rgb2gray(mov(1,k+1).cdata));
		% ������� ���������� (������������ �������) ��� ��� ���������� ��� ����������� �������
		[motionVect]=motionEst(x2,x1);
		% ������� ���������� ��� ��� ���������� ������� ���� ��� ����������� ������� ��� ��� ������� � (������������ �������)
		imgComp = motionComp(x1, motionVect);
		% Cast ����� Double �� uint8 ����������� �� ����� ������ � ������� - �������� �������
		predictionframe=uint8(imgComp);
		% ����������� �������� �������� �������� ��� �������� ������ (Target Frame) ��� ��� ������������� �������� ���� ��� ����������� �������
		DiffViaMotionVector(:,:,k )= imabsdiff(predictionframe,officialframe2);	
		M = mod(k,5);
		if(M == 0)
		waitbar(k/steps,h,sprintf('%d%s',k,'%'))
		end
		if(k==nFrames-1)
			didfinish=1;
		end
	end

	global EntropyOfDiffFramesViaMotionVector; % �������� ��� �������� ��������� ���� ��� ����������� �������
	global CounterOfEntropyOfDiffFramesViaMotionVector; % ��������� ��������� ��������� ��� �������� ��������� ���� ��� ����������� �������
	CounterOfEntropyOfDiffFramesViaMotionVector=0;
	if(didfinish==1)
		for k=1:nFrames-1 
			EntropyOfDiffFramesViaMotionVector(k)=entropy(DiffViaMotionVector(:,:,k));
			CounterOfEntropyOfDiffFramesViaMotionVector= CounterOfEntropyOfDiffFramesViaMotionVector+EntropyOfDiffFramesViaMotionVector(k);
		end
	end
	delete(h) % �������� ��� waitbar
	if(didfinish==1)
		implay(DiffViaMotionVector) % ������� ��� �������� ��������� ���� ��� ����������� �������
		set(findall(0,'tag','spcui_scope_framework'),'position',[100 100 900 550]);
		RunEnergeia3=1;
	end
	ClockEnd = clock;
	TimeElapsed = etime(ClockEnd,ClockStart)/60;% ��������� ��� etime ��� ������������ �� �����
	time3=TimeElapsed;
	InProgress=0;
else
	errordlg('At this time, some other action is in progress. Please proceed after the action is finished.','Error','Error Icon')
end


% --- Executes on button press in Energeia4.
function Energeia4_Callback(hObject, eventdata, handles)

%�������� �� �� ������ ��� ������ �������� ("�������")
%��������� � ������ ������� global ���������� ����������� �� �������� ������ � ����������� ����� �� ���� �� ������� ��� �� ���������� � ������������� ����������� ����


global EntropyOfDiffFrames;global EntropyOfFrames;global EntropyOfDiffFramesViaMotionVector;
global RunEnergeia1;global RunEnergeia2;global RunEnergeia3;global InProgress;
global CounterOfEntropyOfDiffFramesViaMotionVector;global CounterOfEntropyOfDiffFrames;global CounterOfEntropyOfFrames;
cantcontinue=0;global time1;global time2;global time3;

% ������������ ��� ������������� ���������� ����������� �� ����� ������ � �������� ����
TF = isempty(InProgress);
if(TF==1)
	InProgress=4;
end

TF1 = isempty(RunEnergeia1);
TF2 = isempty(RunEnergeia2);
TF3 = isempty(RunEnergeia3);
if (TF1==1 || TF2==1 || TF3==1)
RunEnergeia1=4;RunEnergeia2=4;RunEnergeia3=4;
cantcontinue=1;
end
	if(InProgress~=2)
	InProgress=2;
		if(RunEnergeia1==1 && RunEnergeia2==1 && RunEnergeia3==1 && cantcontinue ==0 && CounterOfEntropyOfFrames~=0 && CounterOfEntropyOfDiffFramesViaMotionVector~=0 && CounterOfEntropyOfDiffFrames~=0)
			%���������� ��������� �������� ��� ����������� (reports) �������� ��� ������������ ��� ��� ����������������� ����������
			NewFigure1 = figure('name','Entropy for each Frame');
			set(NewFigure1,'Position',[70 250 700 430])
			plot(EntropyOfFrames,'Color','red','LineWidth',2);
			text(1.5,7,'-----  Original Frames','Color','red','FontSize',9)
			text(1.5,6.5,'-----  Absolute Difference Frames','Color','green','FontSize',9) 
			text(1.5,6,'-----  Absolute Difference Frames based on motion vectors','Color','blue','FontSize',9)
			xlabel('Frame')
			ylabel('Entropy');
			hold on % ����������� �� �������� �� �������������� (�������) �� ��� ��������
			plot(EntropyOfDiffFrames,'Color','green','LineWidth',2);
			plot(EntropyOfDiffFramesViaMotionVector,'LineWidth',2);
			hold off
			%������� ���������
			h1=msgbox(sprintf('Frames Entropy number = %2.3g\nError Frames Entropy number = %2.3g\nError Frames Entropy number with motion vectors = %2.3g',CounterOfEntropyOfFrames,CounterOfEntropyOfDiffFrames,CounterOfEntropyOfDiffFramesViaMotionVector),'Entropy Report');
			set(h1,'Position',[550 450 390 75]);
			%������� �������� �����������
			h2=msgbox(sprintf('Time needed for first Algorithm: %2.3g (minutes)\nTime needed for first Algorithm:%2.3g (minutes)',time2,time3),'Time Report');
			set(h2,'Position',[550 320 300 65]);
		else
				errordlg('For being able to Report, please run all possible actions and then select "Report"','Error','Error Icon')
		end
		InProgress=0;
	else
	errordlg('At this time, some other action is in progress. Please proceed after the action is finished.','Error','Error Icon')
	end


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)


function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)

function edit7_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
