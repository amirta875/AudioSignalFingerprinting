function [ data, newSampleRate ] = mp3SongRead(songName,newSampleRate)
%MP3RSONGREAD Imports song data from .mp3 file
%   the function imports stereo music data, average the two chanels (mono), substract the mean (DC) and
%   downsample it.

[dataS, fs] = audioread(songName);

dataS = mean(dataS,2);                      % reduce to mono

monoData = dataS - mean(dataS) ;

data = resample(monoData, newSampleRate, fs);       % downsample data


end

