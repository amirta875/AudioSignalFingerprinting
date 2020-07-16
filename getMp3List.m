function songList = getMp3List(direc)
% GETMP3LIST 
% the function returns a list of filenames that contain '.mp3' in the
% specified directory.

    dirObject = dir(direc);

    fullList = cell(size(dirObject));
    for i=1:size(dirObject,1)
        fullList{i} = dirObject(i).name;
    end
    
    
    songList = cell(size(fullList));
    counter=1;
    for ii = 1:size(fullList,1)
        if ~isempty(strfind(fullList{ii},'.mp3'))
           songList{counter} = fullList{ii};
           counter = counter+1;
        end
    end
    if counter==1
        disp 'No MP3s Found'; 
    end
    
                                                        % Reduce list to correct length
    songList = songList(1:counter-1);
end