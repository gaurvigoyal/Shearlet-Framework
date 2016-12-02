function [ COORDINATES, change_map ] = shearlet_detect_points( video, coeffs, scales, weights, min_threshold, spt_window, pause_between_frames)
%SHEARLET_DETECT_POINTS XXXX
%
% Usage:
%   [coordinates, change_map] = shearlet_detect_points(video, coeffs, [2 3], [], 0.1, 9, false)
%           XXX
%           
% Parameters:
%   video: 
%   coeffs: 
%   scale: 
%   weights: 
%   min_threshold: 
%   spt_window: 
%   pause_between_frames: 
%
% Output:
%   coordinates:  
%   change_map: 
%
%   See also ...
%
% 2016 Damiano Malafronte.

if(isempty(weights))
    weights = ones(1,numel(scales));
end

% parameters controls
if(max_size < 16)
        ME = MException('load_video_to_mat:tiny_max_size_for_frames', ...
        'The max_size parameters must be greater than 16.');
    throw(ME);
end

if(start_frame < 1 || start_frame > floor(vidObj.Duration * vidObj.FrameRate))
    ME = MException('load_video_to_mat:negative_frame_index', ...
        'Specify a valid value for the starting frame.');
    throw(ME);
end

if(end_frame < start_frame)
    ME = MException('load_video_to_mat:invalid_end_frame', ...
        'The ending frame cannot be before the staring one.');
    throw(ME);
end

if(end_frame > floor(vidObj.Duration * vidObj.FrameRate))
    warning('load_video_to_mat:end_frame_out_of_bounds', ...
        'The ending frame was out of bound, set to be the last frame in the sequence.');
    end_frame = floor(vidObj.Duration * vidObj.FrameRate);
end


st = tic;

i = 1;

change_map_temp = cell(1, numel(scales));

for scale = scales
    
    load(strcat('cone_indexes_for_5x5_shearings_scale',int2str(scale),'.mat'))

    ind_cone1_sc2 = c1(:);
    ind_cone2_sc2 = c2(:);
    ind_cone3_sc2 = c3(:);
    
    change_map_temp{i} = sum(abs(coeffs(:,:,:, ind_cone2_sc2)),4);
    
    % considers also the changes in the spatial dimensions (cone 1 and cone 3)
    
    first_cone_map = sum(abs(coeffs(:,:,:, ind_cone1_sc2)),4);
    third_cone_map = sum(abs(coeffs(:,:,:, ind_cone3_sc2)),4);
    
    % combined_map = third_cone_map + first_cone_map;
    combined_map = third_cone_map .* first_cone_map;
    
    % change_map(change_map < 1) = 0;
    change_map_temp{i} = change_map_temp{i} .* combined_map;
    
    %
    i = i + 1;
    
end

change_map = weights(1) * change_map_temp{1};

for i=2:numel(scales)
    change_map = change_map .* (weights(i) * change_map_temp{i});
end

%
fprintf('-- Time to create the change map from SH coeffs (number of scales %d): %.4f seconds\n', numel(scales), toc(st));


[COORDINATES] = shearlet_plot_graylevel_local_maxima( video, change_map, min_threshold, spt_window, pause_between_frames, 3, colormap(jet(256)));

end

