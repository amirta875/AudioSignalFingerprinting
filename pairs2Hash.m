function [ hashList ] = pairs2Hash(peaks, delT, delF, fanout)
%PAIRS2HASH finds peaks-pairs indexs
%
% given a binary matrix of peaks locations as input the functions returns a
% list of the first fanout number of proximate peaks pairs [initial time(t1), offseted time(t2), inital frequency(f1), offseted frequency(f2)]
% who are in proximity to each other within the limits of delT and delF


[f, t] = find(peaks);                       % indexes of peaks for comparison 

L = zeros(fanout*length(peaks), 4);

pairs = 0;                                  % Number of pairs found

for i = 1:length(f)                         % cycle through each peak and find pairs under given time and freq condtions
    
    f1 = f(i);
    t1 = t(i);
    
    [R, C] = find((abs(f - f1) <= delF) & ((t - t1) > 0) & ((t - t1) <= delT), fanout);
        
    for j = 1:length(R)
         Lrow = [ t1, t(R(j)), f1, f(R(j)) ];
         pairs = pairs+1;
         hashList(pairs,:) = Lrow;       
         
    end 
end


% figure
% clf; imagesc(peaks)
% axis xy;
% colormap(1-gray)
% hold on
% for i = 1:size(hashList,1)
%     line([hashList(i,1), hashList(i,2) ] , [ hashList(i,3), hashList(i,4) ])
% end
% hold off; title('Pairs'); xlabel('Time'); ylabel('Frequency');







