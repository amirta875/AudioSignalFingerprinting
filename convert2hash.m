function hash = convert2hash(f1, f2, deltaT, size)
%CONVERT2HASH hash function
% the function returns a hash table from input freq. and time indexes
% input arguments are the proximate frequency indexs and time differences

hash = mod(round( size*1000000*(log(abs(f1)+2) + 2*log(abs(f2)+2) + 3*log(abs(deltaT)+2)) ), size) + 1;

end

