function alias = get_alias( HF,i_shift,j_shift )
%HF: H.*F
%H: MTF of the given system
%F: image spectrum
%i_shift: shift amout at i direction,should be a array
%j_shift: similar to i_shift

alias = -HF;
for i = i_shift
    for j = j_shift
        alias = alias + Move_H(HF,i,j);
    end
end


