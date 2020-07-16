function [ peakMags ,peaksIndx, F ,T ] = spectralFingerprint(dataS, fs, tRes, noverlap, gridSize)
%SPECTRALFINGERPRINT spectral decomposition and peaks finder

%   The function calculates the input audio signal spectrogram based on STFT 
%   under a designated time resolution. It then finds the local peaks over a given 
%   even freq-time grid window. It returns an arrays with the peaks frequencies
%   indexs. In addition for diagnostics purposes the magnitude, frequency and 
%   time spans values are also returned.
%   In this version implemantion of thershold values for peaks filtering
%   hasn't been fully completed.


segment = tRes*fs;                          % segment size [samples]
desiredPPS = 30;                            % scales the threshold

[S,F,T] = spectrogram(dataS, blackman(segment), noverlap, [], fs);              % calculates spectrogram; 
magS = abs(S)';

                                                                                % creates a temp array to account for frame\boundry values
tempS = zeros(size(magS,1)+2*gridSize(end),size(magS,2)+2*gridSize(end))*-inf;      
tempS( (max(gridSize)+1):size(magS,1)+max(gridSize)  ,  ( max(gridSize)+1):size(magS,2)+max(gridSize) ) ...
    = mag2db(magS);

peaks = ones(size(magS,1)+2*gridSize(end),size(magS,2)+2*gridSize(end));        % creates a boolean array indicating position of local peaks
Tpeaks = ones(size(magS,1)+2*gridSize(end),size(magS,2)+2*gridSize(end));    

for horShift = -gridSize:gridSize                                               % finds the local peaks with respect to the nearest gridSize entries in both directions
    for vertShift = -gridSize:gridSize
        if(vertShift ~= 0 || horShift ~= 0)
            gridWin = circshift(tempS, [horShift,vertShift]);
            peaks = (tempS > gridWin);
            Tpeaks = Tpeaks.*peaks;
        end
    end
end

peaksIndx = Tpeaks( max(gridSize)+1:size(magS,1)+max(gridSize)  ,max(gridSize)+1:size(magS,2)+max(gridSize) );         
peakMags = peaksIndx.*magS;


% magS=mag2db(magS);

% threshold = max(max(peakMags))-;
% 
% sortedpeakMags = sort(peakMags(:),'descend');                               % sort all peak values in order
% %newN = nonzeros(peakMags);
% 
% % Apply threshold
% if (threshold > 0)
%     peaksN = (peakMags >= threshold);
% end


end

