function H_move = Move_H_super_mode( H, i, j )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[M,N] = size(H);
H_move = zeros(3*M,3*N);
H_move(1201+(i+j)*100:2401+(i+j)*100,1201+(i-j)*100:2401+(i-j)*100) = H;
H_move = H_move(1201:2401,1201:2401);
end

