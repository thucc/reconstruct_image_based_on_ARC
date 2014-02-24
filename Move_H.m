function [ H_move ] = Move_H( H, i, j)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
[M,N] = size(H);
H_move = zeros(3*M,3*N);
H_move(1201+100*i:2401+100*i,1201+100*j:2401+100*j) = H;
H_move = H_move(1201:2401,1201:2401);
end

