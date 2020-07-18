function maxCollisions = addHashTable(list, songidnum)
%ADDHASHTABLE creates hash indexes from peak-pairs data and appened them to
% database
%
% function receives the list of proximate peak pairs and song id from which they
% were taken from. The list is then converted to hash values which are appended to a global
% variable for future reference
% maxCollisons can be used for ongoing tests and diagnostics

global hashtable;

hashTableSize = size(hashtable,1);

maxCollisions = 0;

        
for m = 1:size(list, 1)
    
    hash = convert2hash(list(m,3),list(m,4), list(m,2)-list(m,1), hashTableSize);
    
                                                            % first instance hash
    if isempty(hashtable{hash,1})
        hashtable{hash, 1} = songidnum;                     % id # of the song
        hashtable{hash, 2} = list(m,1);                     % time-start index (t1)
                                                            
                                                            % duplicate instance of this hash
    else
        hashtable{hash, 1} = [hashtable{hash, 1}, songidnum];
        hashtable{hash, 2} = [hashtable{hash, 2}, list(m,1)];

        collisions = length(hashtable{hash, 1});
        if collisions > maxCollisions
            maxCollisions = collisions;
        end
    end
end

end

