function [ output_name ] = shearlet_create_video_outname( video_filename, SCALES, LOWER_THRESHOLD, SPT_WINDOW)
%   Detailed explanation goes here


[~,name,~] = fileparts(video_filename);

scales_text = 'sc_';

for i =1:numel(SCALES)
    scales_text = strcat(scales_text, int2str(SCALES(i)), '_');
end

thresh_text = strcat('th_', num2str(LOWER_THRESHOLD, 3));

thresh_text = strrep(thresh_text, '.', '_');

win_text = strcat('win_', int2str(SPT_WINDOW));

output_name = strcat(name, '_', scales_text, thresh_text, '_', win_text, '.avi');

end

