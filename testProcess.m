% This script is used to test the song identification pipeline and validate its performance.
% A microphone recording or a clip of a random segment from the song
% archive is used as test sound data. In addition noise can be added to it
% as well.
 
global hashtable

load('settings')

recordingOn = 	1;  % invoke for recording from microphone (0 for random segment)
duration = 10;      % [sec]
                                               % loads database 
                                               
if ~exist('songid')
    
    if exist('SONGID.mat')
        load('SONGID.mat');
        load('HASHTABLE.mat');
    else  
        msgbox('No song database');
        return;
    end
end

global numSongs
numSongs = length(songid);

if recordingOn
                                                                % settings for recording.
    fs = 44100;                                                 % sampling frequency
    bits = 16;                                                  % bits used per sample

    duration = 10;                                              % recorded audio duration [sec]
    recObj = audiorecorder(fs, bits, 2); 
    handle1 = msgbox('Recording');
    recordblocking(recObj, duration);
    delete(handle1)
                                                % store data
    soundData = getaudiodata(recObj);
    
else                                            % select a random segment
    
    add_noise = 0;          % add noise to soundData option
    SNRdB = 5;              % signal to noise Ratio [dB]    
    
    dir = 'songs';          % folder that the MP3 files are in.
    songs = getMp3List(dir);
    
    % selects random song and cuts a clip from it
    thisSongIndex = ceil(length(songs)*rand);
    songName = strcat(dir, filesep, songs{thisSongIndex});
    [ soundData, fs ] = mp3SongRead(songName,newSampleRate)
   
    if length(soundData) > ceil(duration*fs)
        shiftRange = length(soundData) - ceil(duration*fs)+1;
        shift = ceil(shiftRange*rand);
        soundData = soundData(shift:shift+ceil(duration*fs)-1);
    end
    
    % add noise
    if add_noise
        soundPower = mean(soundData.^2);
        noise = randn(size(soundData))*sqrt(soundPower/10^(SNRdB/10));
        soundData = soundData + noise;
    end
end


%% find song id from audio clip

% match an audio clip (recording, random song segment or custom new audio file) after 'buildDatabase' script 
% has been executed

global songid

external_FILENAME = [];             % external custom audio clip file name

if external_FILENAME
    [ soundData, fs ] = mp3SongRead('external_FILENAME',newSampleRate);
end

[ indexM ] = matchSegment(soundData,fs);

disp(['Song Title: ',songid{indexM}]);
