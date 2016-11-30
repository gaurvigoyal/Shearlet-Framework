function img = shearlet_plot_clusters_over_time( cl_video_idx, start_index, end_index, kill)
%SHEARLET_PLOT_CLUSTERS_OVER_TIME Summary of this function goes here
%   Detailed explanation goes here


close all;

global cluster_map

if(~exist('cluster_map') || isempty(cluster_map))
    cluster_map =  [0 0 1; 1 0 0; 0 1 0; ...
        1 1 0; 0 0 0; 0 1 1; ...
        1 0 1; 1 1 1; 0.5 0.5 0.5; ...
        0.6 0.6 0; 1 0.4 0.4; 0.2 1 0.3; ...
        0.9 0.8 0.1; 0.2 0.2 1; 0.8 0 0.5];
end

if(nargin < 4)
    kill = false;
end

BASELINE = 5;

mat5 = cl_video_idx(:,:, start_index:end_index);

fH = figure('Position', [680 277 951 701]);

hold all;

%
% for i=1:8
%     d = squeeze(sum(sum(mat5 == i,1),2));
%     plot(1:numel(d), d, 'LineWidth', 2);
% end
%
% legend('1', '2', '3', '4', '5', '6', '7', '8');

%
% for i=[2 3 6 7 8]
%     d = squeeze(sum(sum(mat5 == i,1),2));
%     plot(1:numel(d), d, 'LineWidth', 2);
% end
%
% legend('2', '3', '6', '7', '8');

%
START_VAL = 4;
END_VAL = 8;

%
h = zeros(1,END_VAL - START_VAL + 1);
names = cell(1, END_VAL - START_VAL + 1);

%
h_index = 1;

%
titles = {'background', 'background', 'background (higher)', 'far edges', ...
    'corner(ish)', 'edges', 'dyn. edges', 'dyn. corners'};

%
% titles = {'background', 'dyn. corners', 'far edges', 'background (higher)', ...
%     'background', 'dyn. edges', 'edges', 'corner(ish)'};

%
for i=START_VAL:END_VAL
% for i=[2 3 6 7 8]
    
    %
    d = squeeze(sum(sum(mat5 == i,1),2));
    
    %
    plot(1:numel(d), d, 'LineWidth', BASELINE+1, 'Color', [0 0 0]);
    h(h_index) = plot(1:numel(d), d, 'LineWidth', BASELINE, 'Color', cluster_map(i, :));
    
    %
    %     names{h_index} = int2str(i);
    names{h_index} = titles{i};
    
    %
    h_index = h_index + 1;
end

%
lgd = legend(h, names);

%
lgd.FontSize = 14;
lgd.FontWeight = 'bold';
lgd.Color = [0.8 0.8 0.8];


hold off;

if(kill)
    f = getframe(gca);
    img = f.cdata;
        close(fH);

end

end

