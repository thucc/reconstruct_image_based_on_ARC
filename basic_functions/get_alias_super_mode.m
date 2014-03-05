function [ alias ] = get_alias_super_mode( HF )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

alias = -HF;
for i = -1:1
    for j = -1:1
        alias = alias + Move_H_super_mode(HF,i,j);
    end
end
alias = alias(401:801,401:801);
end

