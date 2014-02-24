function alias = get_alias( HF )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
alias = -HF;
for i = -6:6
    for j = -6:6
        alias = alias + Move_H(HF,i,j);
    end
end
alias = alias(401:801,401:801);


