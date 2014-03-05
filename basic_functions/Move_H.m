function [ H_move ] = Move_H( H, i, j)
%H: MTF of the given system
%i,j: shift amount(how many frequency points to shift)

[M,N] = size(H);
H_move = zeros(3*M,3*N);
H_move(M+1+i:2*M+i,N+1+j:2*N+j) = H;
H_move = H_move(M+1:2*M,N+1:2*N);
end

