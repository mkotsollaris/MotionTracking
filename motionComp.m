%-----------------------------------------------------------------------------%
%
% ����������� ������� �������� ��� ��������� �������� 
% (Frame I) ��� ��� ����������� �������  [������������ �������]
%
% �������
%   imgI : �������� ������� (Frame I)
%   motionVect : �������� �������
%
% ������
%   imgComp : � ������������ ������� ��� �������
%
%-----------------------------------------------------------------------------%

function imgComp = motionComp(imgI, motionVect)
mbSize=16;
[row col] = size(imgI);

% �o "Scanning" ��� ������� ������� ��� ���� ��������
% ��� ��� ���� ���������� ���������� �� �������� �������
% ��� �� ���������� ����� ������������ ��� imgComp

mbCount = 1;
for i = 1:mbSize:row-mbSize+1
    for j = 1:mbSize:col-mbSize+1
        
        % dy � ������ ����������
        % dx ��������� ����������
        
        dy = motionVect(1,mbCount);
        dx = motionVect(2,mbCount);
        refBlkVer = i + dy;
        refBlkHor = j + dx;
        imageComp(i:i+mbSize-1,j:j+mbSize-1) = imgI(refBlkVer:refBlkVer+mbSize-1, refBlkHor:refBlkHor+mbSize-1);
    
        mbCount = mbCount + 1;
    end
end

imgComp = imageComp;