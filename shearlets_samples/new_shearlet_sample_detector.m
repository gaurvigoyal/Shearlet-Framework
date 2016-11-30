

%%

close all;

%%

% loads the video sequence

clear VID 

% [VID, COLOR_VID] = load_video_to_mat('person04_boxing_d1_uncomp.avi',160, 1,100); % parametri 1.5 e 5
[VID, COLOR_VID] = load_video_to_mat('alessia_rectangle.mp4',160, 600,700);
% [VID, COLOR_VID] = load_video_to_mat('walk-simple.avi',160, 1,100);
% [VID, COLOR_VID] = load_video_to_mat('Sample0001_color.mp4', 160, 1239, 1350);

% calculates the 3D Shearlet Transform

clear COEFFS idxs

[COEFFS,idxs] = shearlet_transform_3D(VID,46,91,[0 1 1], 3, 1);

%%

% parameters for the detection process
LOWER_THRESHOLD = 0.1;  % old values was 0.01
SPT_WINDOW = 11;          % old values was 7
PAUSE_BETWEEN_FRAMES = false;

close all;
[COORDINATES, CHANGE_MAP] = shearlet_detect_points( VID(:,:,1:91), COEFFS, [2 3], [], LOWER_THRESHOLD, SPT_WINDOW, PAUSE_BETWEEN_FRAMES);

%%

comparison_local_maxima_in_frame(VID(:,:,1:91), COLOR_VID(:,:,:,1:91), CHANGE_MAP, LOWER_THRESHOLD, SPT_WINDOW, PAUSE_BETWEEN_FRAMES, 3, colormap(jet(256)));  % buono boxing? centrato in 46, SCALA 2

%%

close all;

load('kth_bg_averaged.mat');

[~, FG_CENTROIDS] = comparison_mask_from_kth_video(VID(:,:,1:91), bg_averaged, 90);
[TRANSLATED] = comparison_translate_points_by_centroid(COORDINATES, FG_CENTROIDS, VID);
comparison_heatmap_from_points(VID, floor(TRANSLATED));

%%

[COUNTS] = comparison_points_over_time(VID(:,:,1:91), COORDINATES);

%%

[~, COUNTS_IND] = sort(COUNTS,2, 'descend');

close all;
figure;

subplot(1,4,1);
imshow(COLOR_VID(:,:,:,COUNTS_IND(1))./255);

subplot(1,4,2);
imshow(COLOR_VID(:,:,:,COUNTS_IND(2))./255);

subplot(1,4,3);
imshow(COLOR_VID(:,:,:,COUNTS_IND(3))./255);

subplot(1,4,4);
imshow(COLOR_VID(:,:,:,COUNTS_IND(4))./255);

%%

[FG_MASKS, FG_CENTROIDS] = comparison_mask_from_kth_video(VID(:,:,1:91), bg_averaged, 65);


%% 

[TRANSLATED] = comparison_translate_points_by_centroid(COORDINATES, FG_CENTROIDS, VID(:,:,1));

%%

% comparison_heatmap_from_points(VID, floor(TRANSLATED));
comparison_heatmap_from_points(VID, floor(COORDINATES));

%%

% XYZnew = FG_MASKS;
% 
% for i=1:size(FG_MASKS,3)
%     XYZnew(:,:,i) = FG_MASKS(:,:,end-i+1);
% end

permuted = true;

VIS_FG_MASKS = FG_MASKS;

if(permuted)
    VIS_FG_MASKS = permute(VIS_FG_MASKS,[3 2 1]);
end

close all;

comparison_3d_visualization_from_points(VIS_FG_MASKS, COORDINATES, permuted);


%%

close all;

shearlet_visualize_change_map( VID(:,:,1:91), CHANGE_MAP, 3, colormap(jet(256)));
