%------------------------------------------------------------------%
% Matlab 2012 (Edition Ra)  
% 
%
% Αποτελεί το κύριο πρόγραμμα όπου μέσω αυτού καλούνται
% και οι υπόλοιπες λειτουργίες που βρίσκονται στα διαφορετικά
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

%Καλείται με το πάτημα του πρώτου κουμπιού ("Προβολή Πλαισίων")

global RunEnergeia1; % Για το εάν έχει τρέξει ήδη η συνάρτηση
global InProgress;  % Για το εάν κάποια άλλη συνάρτηση βρίσκεται ήδη σε εξέλιξη
global time1;  % Ο χρόνος που απαιτείται για την εκτέλεση της λειτουργίας

% Αρχικοποίηση των συγκρινόμενων μεταβλητών προκειμένου να είναι δυνατή η σύγκριση τους

TF = isempty(InProgress);
if(TF==1)
	InProgress=4;
end
if(InProgress~=2)
ClockStart = clock;
	InProgress=2;
	didfinish=0;
	steps = 100; % Βοηθητική Μεταβλητή για την υλοποίηση της Waitbar
	h = waitbar(0,'Please wait...','name','Loading','CreateCancelBtn',...
				'setappdata(gcbf,''canceling'',1)');
				setappdata(h,'canceling',0)
				
	xyloObj = VideoReader('movie.wmv');
	nFrames = 100; % Ο αριθμός των πλαισίων που μας ενδιαφέρουν
	vidHeight = xyloObj.Height;
	vidWidth = xyloObj.Width;

	global EntropyOfFrames; % Εντροπία των πλαισίων
	global CounterOfEntropyOfFrames; % Αθροιστής συνολικής εντροπίας των πλαισίων
	CounterOfEntropyOfFrames=0;

	mov(1:nFrames) = ...
		struct('cdata', zeros(vidHeight, vidWidth, 3, 'uint8'),...
			   'colormap', []);
	for k = 1 : nFrames
		if getappdata(h,'canceling') % σε περίπτωση "cancel", έξοδος από την επανάληψη
			CounterOfEntropyOfFrames=0;
			break;
		end
		mov(k).cdata = read(xyloObj, k);
		% ’θροισμα συνολικής Εντροπίας
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
	delete(h); % διαγραφή της waitbar
	% Έλεγχος για το εάν ολοκληρώθηκε η λειτουργία
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
	TimeElapsed = etime(ClockEnd,ClockStart)/60;% μετατροπή της etime από δευτερόλεπτα σε λεπτά
	time1=TimeElapsed;
	InProgress=0;
else
	errordlg('At this time, some other action is in process. Please progress after the action is finished.','Error','Error Icon')
end


% --- Executes on button press in Energeia2.
function Energeia2_Callback(hObject, eventdata, handles)

%Καλείται με το πάτημα του πρώτου κουμπιού ("1ος Αλγοριθμος")


global InProgress; % Για το εάν κάποια άλλη συνάρτηση βρίσκεται ήδη σε εξέλιξη
global RunEnergeia2; % Για το εάν έχει τρέξει ήδη η συνάρτηση
global time2; % Ο χρόνος που απαιτείται για την εκτέλεση της λειτουργίας

% Αρχικοποίηση των συγκρινόμενων μεταβλητών προκειμένου να είναι δυνατή η σύγκριση τους

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
	steps = 100;% Βοηθητική Μεταβλητή για την υλοποίηση της Waitbar
	xyloObj = VideoReader('movie.wmv');
	nFrames = 100;% Ο αριθμός των πλαισίων που μας ενδιαφέρουν
	vidHeight = xyloObj.Height;
	vidWidth = xyloObj.Width;


	mov(1:nFrames) = ...
		struct('cdata', zeros(vidHeight, vidWidth, 3, 'uint8'),...
			   'colormap', []);
	for k = 1 : nFrames
			  mov(k).cdata = read(xyloObj, k);  	  
	end

	didfinish=0;% Βοηθητική μεταβλητή για το εαν ολοκληρώνεται η όχι η λειτουργία
	for k=1:nFrames-1
		if getappdata(h,'canceling')
		break
		end
		Diff(:,:,:,k)=imabsdiff(rgb2gray(mov(k+1).cdata),rgb2gray(mov(k).cdata));% Απόλυτη διαφορά μεταξύ των πλαισίων
		M = mod(k,5);
		if(M == 0)
		waitbar(k/steps,h,sprintf('%d%s',k,'%'))
		end
		if(k==99)
			didfinish=1;
		end
	end

	global EntropyOfDiffFrames; % Εντροπία των πλαισίων
	global CounterOfEntropyOfDiffFrames; % Αθροιστής συνολικής εντροπίας των πλαισίων σφαλμάτων
	CounterOfEntropyOfDiffFrames=0;
	if(didfinish==1)
		for k=1:nFrames-1 
			EntropyOfDiffFrames(k)=entropy(Diff(:,:,k));
			CounterOfEntropyOfDiffFrames= CounterOfEntropyOfDiffFrames+EntropyOfDiffFrames(k);
		end
	end
	delete(h); % διαγραφή της waitbar
	if(didfinish==1) 
		implay(Diff) % Προβολή των Πλαισίων σφαλμάτων
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

%Καλείται με το πάτημα του πρώτου κουμπιού ("2ος Αλγόριθμος")

global InProgress; % Για το εάν κάποια άλλη συνάρτηση βρίσκεται ήδη σε εξέλιξη
global RunEnergeia3; % Για το εάν έχει τρέξει ήδη η συνάρτηση
global time3; % Ο χρόνος που απαιτείται για την εκτέλεση της λειτουργίας

% Αρχικοποίηση των συγκρινόμενων μεταβλητών προκειμένου να είναι δυνατή η σύγκριση τους

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
	nFrames = 100; % Ο αριθμός των πλαισίων που μας ενδιαφέρουν
	vidHeight = xyloObj.Height;
	vidWidth = xyloObj.Width;


	mov(1:nFrames) = ...
		struct('cdata', zeros(vidHeight, vidWidth, 3, 'uint8'),...
			   'colormap', []);
	for k = 1 : nFrames
			  mov(k).cdata = read(xyloObj, k);  	  
	end

	didfinish=0;% Βοηθητική μεταβλητή για το εαν ολοκληρώθηκε η λειτουργία
	for k=1:nFrames-1
		if getappdata(h,'canceling')
		break
		end
		frame1=rgb2gray(mov(1,k).cdata); % Πλαίσιο που κωδικοποιείται αυτόνομα (Frame I)
		frame2=rgb2gray(mov(1,k+1).cdata); % Πλαίσιο στόχος (Target Frame)
		officialframe2 = imcrop(frame2,[0 0 848 848]);
		% Cast Εικόνων σε double προκειμένου να καθιστούν δυνατές οι πράξεις μεταξύ αυτών.
		x1=double(rgb2gray(mov(1,k).cdata));
		x2=double(rgb2gray(mov(1,k+1).cdata));
		% Κάλεσμα Συνάρτησης (Λογαριθμικού κόστους) για τον υπολογισμό των διανυσμάτων κίνησης
		[motionVect]=motionEst(x2,x1);
		% Κάλεσμα Συνάρτησης για την δημιουργία εικόνας βάση των διανυσμάτων κίνησης και της εικόνας Ι (Αντιστάθμηση Κίνησης)
		imgComp = motionComp(x1, motionVect);
		% Cast τύπου Double σε uint8 προκειμένου να είναι δυνατή η προβολή - σύγκριση εικόνας
		predictionframe=uint8(imgComp);
		% Υπολογισμός Πλαισίου διαφορών δοσμένου του πλαισίου στόχος (Target Frame) και του προβλεπόμενου πλαισίου βάση των δυανισμάτων κίνησης
		DiffViaMotionVector(:,:,k )= imabsdiff(predictionframe,officialframe2);	
		M = mod(k,5);
		if(M == 0)
		waitbar(k/steps,h,sprintf('%d%s',k,'%'))
		end
		if(k==nFrames-1)
			didfinish=1;
		end
	end

	global EntropyOfDiffFramesViaMotionVector; % Εντροπία των πλαισίων σφαλμάτων βάση των διανυσμάτων κίνησης
	global CounterOfEntropyOfDiffFramesViaMotionVector; % Αθροιστής συνολικής εντροπίας των πλαισίων σφαλμάτων βάση των διανυσμάτων κίνησης
	CounterOfEntropyOfDiffFramesViaMotionVector=0;
	if(didfinish==1)
		for k=1:nFrames-1 
			EntropyOfDiffFramesViaMotionVector(k)=entropy(DiffViaMotionVector(:,:,k));
			CounterOfEntropyOfDiffFramesViaMotionVector= CounterOfEntropyOfDiffFramesViaMotionVector+EntropyOfDiffFramesViaMotionVector(k);
		end
	end
	delete(h) % διαγραφή της waitbar
	if(didfinish==1)
		implay(DiffViaMotionVector) % Προβολή των Πλαισίων σφαλμάτων βάση των διανυσμάτων κίνησης
		set(findall(0,'tag','spcui_scope_framework'),'position',[100 100 900 550]);
		RunEnergeia3=1;
	end
	ClockEnd = clock;
	TimeElapsed = etime(ClockEnd,ClockStart)/60;% μετατροπή της etime από δευτερόλεπτα σε λεπτά
	time3=TimeElapsed;
	InProgress=0;
else
	errordlg('At this time, some other action is in progress. Please proceed after the action is finished.','Error','Error Icon')
end


% --- Executes on button press in Energeia4.
function Energeia4_Callback(hObject, eventdata, handles)

%Καλείται με το πάτημα του πρώτου κουμπιού ("Αναφορά")
%Προκύπτει η ανάγκη δήλωσης global μεταβλητών προκειμένου να καταστεί δυνατή η επεξεργασία αυτών σε αυτό το κομμάτι και να αποφευχθεί ο επαναληπτικός υπολογισμός τους


global EntropyOfDiffFrames;global EntropyOfFrames;global EntropyOfDiffFramesViaMotionVector;
global RunEnergeia1;global RunEnergeia2;global RunEnergeia3;global InProgress;
global CounterOfEntropyOfDiffFramesViaMotionVector;global CounterOfEntropyOfDiffFrames;global CounterOfEntropyOfFrames;
cantcontinue=0;global time1;global time2;global time3;

% Αρχικοποίηση των συγκρινόμενων μεταβλητών προκειμένου να είναι δυνατή η σύγκριση τους
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
			%Δημιουργία παραθύρου προβολής των στατιστικών (reports) απόδοσης του προγράμματος και τον χρησιμοποιούμενων αλγορίθμων
			NewFigure1 = figure('name','Entropy for each Frame');
			set(NewFigure1,'Position',[70 250 700 430])
			plot(EntropyOfFrames,'Color','red','LineWidth',2);
			text(1.5,7,'-----  Original Frames','Color','red','FontSize',9)
			text(1.5,6.5,'-----  Absolute Difference Frames','Color','green','FontSize',9) 
			text(1.5,6,'-----  Absolute Difference Frames based on motion vectors','Color','blue','FontSize',9)
			xlabel('Frame')
			ylabel('Entropy');
			hold on % Προκειμένου τα δεδομένα να αναπαρασταθούν (στατικά) σε ένα παράθυρο
			plot(EntropyOfDiffFrames,'Color','green','LineWidth',2);
			plot(EntropyOfDiffFramesViaMotionVector,'LineWidth',2);
			hold off
			%Αναφορά Εντροπίας
			h1=msgbox(sprintf('Frames Entropy number = %2.3g\nError Frames Entropy number = %2.3g\nError Frames Entropy number with motion vectors = %2.3g',CounterOfEntropyOfFrames,CounterOfEntropyOfDiffFrames,CounterOfEntropyOfDiffFramesViaMotionVector),'Entropy Report');
			set(h1,'Position',[550 450 390 75]);
			%Αναφορά Χρονικής πληροφορίας
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
