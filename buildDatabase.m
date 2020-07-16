% reads all MP3 files in 'dir' and adds them to a database.
% implaments spectral fingerprinting and hash index pipeline algorithm.
% produces two .mat files: "HASHTABLE" and "SONGID" which are used as a song
% identifcation database references.

%% parameters for spectral study of resolution

newSampleRate = 8e3;                            % downsample sampling value [Hz]
tRes = .064;                                    % time resoultion\ size of each time segment [sec]
overlapSize = 50;                               % percentage of overlap between segments [%]
gridSize = 4;                                   % maximal grid distance for peak serach [pixel]

% peak-pairs window size parameters

Fband = 200;                                    % [Hz] 
Tlen = 1;                                       % [sec]
fanout = 3;                                     % number of maximal peaks pairs in window

%%  songs database creation process

dir = 'songs';                                  % folder name which has the audio files
songs = getMp3List(dir);

hashTableSize = 100000; 

global hashtable

if ~exist('songid')                             % creates hash-song database
                                                
    if exist('SONGID.mat')
        load('SONGID.mat');
        load('HASHTABLE.mat');
    else  
        
        songid = cell(0);
        hashtable = cell(hashTableSize,2); % 
    end
end

songIndex = length(songid);
                                                % adds songs to songid and fingerprints to hashtable
NewSongs = 0;
for i = 1:length(songs)
                      
    songFound = 0;
    for m = 1:length(songid)
        if strcmp(songs{i}, songid{m})
            songFound = 1;
            break;
        end
    end
    
    if ~songFound
        NewSongs = 1;
        songIndex = songIndex + 1;
        filename = strcat(dir, filesep, songs{i});
              
        [ dataS, fs ] = mp3SongRead(filename,newSampleRate);                                                   % imports audio file data
        [ peakMags, peaksIndx, F ,T ] = spectralFingerprint(dataS, fs, tRes, 100/overlapSize, gridSize);       % finds maximal peak magintude values
        [ dF, dT] = size2pixel(F,T,Fband,Tlen);                                                                % calculate peak-pairs window sizs
        [ hashlist ] = pairs2Hash(peaksIndx, dF, dT, fanout);                                                  % finds peak-pairs of song in form of indexs
        addHashTable(hashlist,songIndex);                       % convert peak-pairs indexes to a hash number and add it to the hash table
        songid{songIndex,1} = songs{i};                         % create an index id number for the song
    end
end

global numSongs
numSongs = songIndex;

if NewSongs
    save('SONGID.mat', 'songid');
    save('HASHTABLE.mat', 'hashtable');
end