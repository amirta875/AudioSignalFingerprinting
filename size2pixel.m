function [dF,dT] = size2pixel(F,T,Fband,Tlen)
%SIZE2PIXEL converts time\freq values to pixel units
%   Returns dimensions in pixel size of the time-freq window for peak pairs
%   extraction

dF = round(Fband/(F(2)-F(1))) ;        % spectral window band for peak-pairs [pixel]
dT = round(Tlen/(T(2)-T(1))) ;         % time window length for peak-pairs [pixel]


end

