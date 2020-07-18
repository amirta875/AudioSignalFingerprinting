function [ matchSongID ] = matchSegment(clipData, fs)
%% MATCHSEGMENT identifys a song from an input sound segment
%  Given an input song data and sampling rate the function executes the
%  spectral identification pipeline resulting in the most likely match from
%  the reference database.
%  This function requires the global variables 'hashtable' and'numSongs'
%  along with the saved values from 'setings' in order to work properly.
%

load('settings');       % loads parameters 

global hashtable
global numSongs

hashTableSize = size(hashtable,1);

% Find peak pairs from the clip
[ peakMags, peaksN, F ,T ] = spectralFingerprint(clipData, fs, tRes, 100/overlapSize, gridSize);           % finds maximal peak magintude values
[ dF, dT] = size2pixel(F,T,Fband,Tlen);
[ hashlist ] = pairs2Hash(peaksN, dF, dT, fanout);

clipList = hashlist;     % Replace this line

% construct a cell of matches for each song in the database
matches = cell(numSongs,1);
                                                

% Calcualtes hash value for peak-pairs from the clip and find if they exist
% in the global hash table reference data base as well.
                                                
for k = 1:size(clipList, 1)
        
    clipHash = convert2hash(clipList(k,3),clipList(k,4), clipList(k,2)-clipList(k,1), hashTableSize);
        
    %  find the song\songs with matching peak pairs
    if (~isempty(hashtable{clipHash, 1}))
        matchID = hashtable{clipHash, 1}; 
        matchTime = hashtable{clipHash, 2}; 
        
        % Calculate the time difference between clip pair and song pair
        timeOffset = matchTime -  clipList(k,1);
        
        % add specific song matches for each entry
        for n = 1:numSongs
              matches{n} = [ matches{n} , timeOffset(find(matchID == n)) ];
            
        end
    end
end


% find the counts of the mode of the time offset array for each song

for k = 1:numSongs
    [number(k), counts(k) ] = mode(matches{k});
end

% final identification decision 
[val matchSongID ] = max(counts);

%  optinal histogram plot for the matches results
% 
%     figure(5)
%     clf
%     y = zeros(length(matches),1);
%     for k = 1:length(matches)
%         subplot(length(matches),1,k)
%         hist(matches{k},1000)
%         y(k) = max(hist(matches{k},1000));
%     end
%     
%     for k = 1:length(matches)
%         subplot(length(matches),1,k)
%         axis([-inf, inf, 0, max(y)])
%     end
% 
%     subplot(length(matches),1,1)
%     title('Histogram of offsets for each song')
% end

end

