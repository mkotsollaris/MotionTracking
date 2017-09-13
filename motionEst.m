% ----------------------------------------------------------------------- %
%
% Υλοποίηση του υπολογισμου των διανυσμάτων κίνησης με Λογιαρθμικό Κόστος
%
% Είσοδος
%   imgP : Πλαίσιο Στόχος	(Target Frame)
%   imgI : Αυτόνομο Πλαίσιο (πλαίσιο αναφοράς) (Frame I)
%
% Έξοδος
%   motionVect : διάνυσμα κίνησης για κάθε μακρομπλόκ
%
% ----------------------------------------------------------------------- %


function [motionVect] = motionEst(imgP, imgI)
k=16; 
mbSize=16;
[row col] = size(imgI);
vectors = zeros(2,round(row*col/mbSize^2));
costs = ones(3, 3) * 65537;


L = floor(log10(k+1)/log10(2));   
stepMax = 2^(L-1);

%Συνολικός αριθμός βημάτων = 4

mbCount = 1; % υπολογισμός ευρισκόμενου (current) μακρομπλόκ
for i = 1 : mbSize : row-mbSize+1
    for j = 1 : mbSize : col-mbSize+1

        x = j;
        y = i;
        
		% Γίνεται ο υπολογισμός της SAD μετρικής για τα αντίστοιχα μακρομπλοκ
        
        costs(2,2) = costFuncSAD(imgP(i:i+mbSize-1,j:j+mbSize-1), ...
                                    imgI(i:i+mbSize-1,j:j+mbSize-1));
        
        stepSize = stepMax;               

        while(stepSize >= 1)  

            % m = κάθετη μετατόπιση
            % n = οριζόντια μετατόπιση
			
            for m = -stepSize : stepSize : stepSize        
                for n = -stepSize : stepSize : stepSize
                    refBlkVer = y + m;   % row/κάθετη 
                    refBlkHor = x + n;   % col/οριζόντια
                    if ( refBlkVer < 1 || refBlkVer+mbSize-1 > row ...
                        || refBlkHor < 1 || refBlkHor+mbSize-1 > col)
                        continue;
                    end


                    costRow = m/stepSize + 2;
                    costCol = n/stepSize + 2;
                    if (costRow == 2 && costCol == 2)
                        continue
                    end
                    costs(costRow, costCol ) = costFuncSAD(imgP(i:i+mbSize-1,j:j+mbSize-1), ...
                        imgI(refBlkVer:refBlkVer+mbSize-1, refBlkHor:refBlkHor+mbSize-1));
                    
                end
            end
			
			% Υπολογίζεται το διάνυσμα του οποίου το κόστος είναι 
			% το ελάχιστο, αποθηκεύεται ώστε να σταλέι πίσω

			% βρίσκει ποιο μακρομπλοκ στο imgI μας έδωσε ελάχιστο κόστος	
            [dx, dy, min] = minCost(costs);      
            
			% μετατόπιση της ρίζας για την αναζήτηση για εύρεση νέου ελαχίστου σημείου

            x = x + (dx-2)*stepSize;
            y = y + (dy-2)*stepSize;
            stepSize = stepSize / 2; % υποδιπλασιασμός βήματος
            costs(2,2) = costs(dy,dx);
            
        end
		%Επαναπροσανατολισμός των διανυσμάτων
        vectors(1,mbCount) = y - i;   
        vectors(2,mbCount) = x - j;               
        mbCount = mbCount + 1;
        costs = ones(3,3) * 65537;
    end
end
motionVect = vectors;
                    