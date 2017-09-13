%-----------------------------------------------------------------------------%
%
% Υπολογισμός Εικόνας δοσμένου του αυτόνομου πλαισίου 
% (Frame I) και του διανύσματος κίνησης  [Αντιστάθμηση Κίνησης]
%
% Είσοδος
%   imgI : αυτόνομο πλαίσιο (Frame I)
%   motionVect : δυάνισμα κίνησης
%
% Έξοδος
%   imgComp : Η αντιστάθμιση κίνησης της εικόνας
%
%-----------------------------------------------------------------------------%

function imgComp = motionComp(imgI, motionVect)
mbSize=16;
[row col] = size(imgI);

% Τo "Scanning" της εικόνας αρχίζει από πάνω αριστερά
% και για κάθε μακρομπλόκ διαβάζεται το διάνυσμα κίνησης
% και το αποτέλεσμα αυτού τοποθετείται στο imgComp

mbCount = 1;
for i = 1:mbSize:row-mbSize+1
    for j = 1:mbSize:col-mbSize+1
        
        % dy η κάθετη μετατόπηση
        % dx οριζόντια μετατόπηση
        
        dy = motionVect(1,mbCount);
        dx = motionVect(2,mbCount);
        refBlkVer = i + dy;
        refBlkHor = j + dx;
        imageComp(i:i+mbSize-1,j:j+mbSize-1) = imgI(refBlkVer:refBlkVer+mbSize-1, refBlkHor:refBlkHor+mbSize-1);
    
        mbCount = mbCount + 1;
    end
end

imgComp = imageComp;