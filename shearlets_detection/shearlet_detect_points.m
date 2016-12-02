function [ COORDINATES, change_map ] = shearlet_detect_points( video, coeffs, scales, weights, min_threshold, spt_window, pause_between_frames)
%SHEARLET_DETECT_POINTS Detects a set of spatio-temporal interest points in
%the sequence passed as a parameter (more precisely, using the
%corresponding shearlet coefficients, previously calculated)
%
% Usage:
%   [coordinates, change_map] = shearlet_detect_points(video, coeffs, [2 3], [], 0.1, 9, false)
%           Detects points in the 'video' matrix passed by considering the
%           values inside the 'coeffs' object, only keeping into account of
%           the values corresponding to the second and third scales. 
%           Values below 0.1 will not be considered for the non-maxima
%           supression process, as they will be set to zero, and the local
%           window within which a value has to be the maximum to be
%           considered as a detected point is a cube of side 2*9+1 pixels.
%           
% Parameters:
%   video: the matrix representing the video sequence
%   coeffs: the four-dimensional matrix containing the shearlet coefficients
%   scales: the set of scales to consider for the detection
%   weights: the weights to use for each scale (not used, until now)
%   min_threshold: the minumum value for a candidate point
%   spt_window: the neighborhood to consider while searching for local
%               maxima
%   pause_between_frames: whether to pause or not during 
%
% Output:
%   coordinates: a matrix containing a set of triples (x,y,t) representing
%                the coordinates of the spatio-temporal interest points
%                that have been found by the process.
%   change_map: a three-dimensional matrix containing the values for the
%               interest measure considered to extract the points.
%
%   See also ...
%
% 2016 Damiano Malafronte.

if(isempty(weights))
    weights = ones(1,numel(scales));
end

% parameters controls
% if(scales > 5)
%     warning('shearlet_detect_points:scales_too_high', ...
%         'The number of scales is high, you could incur into memory issues while loading the corresponding shearlet system.');
% end
% 
% if(scales ~= numel(weights))
%     ME = MException('shearlet_detect_points:number_of_weights', ...
%         'You have to specify an equal number of weights and scales.');
%     throw(ME);
% end
% 
% if(end_frame < start_frame)
%     ME = MException('load_video_to_mat:invalid_end_frame', ...
%         'The ending frame cannot be before the staring one.');
%     throw(ME);
% end
% 
% if(end_frame > floor(vidObj.Duration * vidObj.FrameRate))
%     warning('load_video_to_mat:end_frame_out_of_bounds', ...
%         'The ending frame was out of bound, set to be the last frame in the sequence.');
%     end_frame = floor(vidObj.Duration * vidObj.FrameRate);
% end


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

