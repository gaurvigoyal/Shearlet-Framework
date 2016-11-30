
% VID = load_video_to_mat('person02_jogging_d3_uncomp.avi');
% shearlet_video_clustering_full( VID(:,:,1:100), SORT_CTRS, 'jogging', true);

% VID = load_video_to_mat('person09_boxing_d4_uncomp.avi');
% shearlet_video_clustering_full( VID(:,:,1:100), SORT_CTRS, 'boxing_quick', true);

filenames = {'person02_boxing_d1_uncomp', 'person02_boxing_d2_uncomp', 'person01_handclapping_d4_uncomp', ...
             'person05_handwaving_d3_uncomp', 'person04_jogging_d4_uncomp', 'person04_running_d1_uncomp', ...
             'person02_walking_d3_uncomp', 'person01_walking_d2_uncomp'};

for i=1:numel(filenames)
   VID = load_video_to_mat([filenames{i} '.avi']);
   shearlet_video_clustering_full( VID(:,:,1:100), SORT_CTRS, filenames{i}, true);
end