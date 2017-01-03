function [ cl_video_idx, cl_video_max ] = shearlet_video_representation_clustering( VID, centroids, prefix, save_to_mat)
%SHEARLET_VIDEO_CLUSTERING Clusters the descriptors passed w.r.t. the
%chosen centroids
%
% Usage:
%   [idx, maxs] = shearlet_video_clustering_full(X, centroids, prefix)
%           Clusters the content of the video sequence represented in X by
%           using the centroids passed to classify each 2D+T point.
%
% Parameters:
%   X:
%   centroids:
%   prefix:
%
% Output:
%   idx:
%   max:
%
%   See also ...

% 2016 Damiano Malafronte.

if(nargin < 4)
    save_to_mat = false;
end

% initialize the structures needed for this operation
cl_video_idx = zeros(size(VID,1), size(VID,2), size(VID,3));
cl_video_max = zeros(size(VID,1), size(VID,2), size(VID,3));

%
t_start = 2;
t_end= 90;

ind = 46;

T_LIMIT = 0;

%
while true
    
    fprintf('Transform with ind: %d.\n', ind);
    
    %
    start_cut = ind - ((91 - 1)/2);
    
    %
    clear COEFFS idxs;
    [COEFFS,idxs] = shearlet_transform_3D(VID,ind,91,[0 1 1], 2, 1);
    
    %
    for t=t_start:t_end
        
        if(T_LIMIT > 0 && t == T_LIMIT)
            break;
        end
        
        %
        if(~(ind == (size(VID,3)- 45)) && t + start_cut > size(VID,3) - 45)
            fprintf('CUT\n');
            break;
        end
        
        fprintf('Processing frame: %d.\n', t+start_cut-1);
        
        %
        DESCR_MAT = shearlet_descriptor(COEFFS, t, 2, idxs, true);
        CL_IND = shearlet_cluster_by_seeds(DESCR_MAT, COEFFS, centroids);
        CL_SORT = shearlet_cluster_image(CL_IND, size(centroids,1), false, false);
        
        cl_video_idx(:,:,t+start_cut-1) = CL_SORT;
        cl_video_max(:,:,t+start_cut-1) = reshape(DESCR_MAT(:,1), 160, 120)';
                
    end
    
    if(T_LIMIT > 0 && t == T_LIMIT)
        break;
    end
        
    t_start = 46;
    
    %
    if(ind == (size(VID,3)- 45))
        break
    end
    
    %
    ind = min([(ind+45) (size(VID,3)- 45)]);
        
end

%
if(save_to_mat)
    SORT_CTRS = centroids;
    save([prefix '_cl_video_and_vid.mat'], 'VID', 'cl_video_idx', 'cl_video_max', 'SORT_CTRS');
end

% 
for i=1:5
    beep;
    pause(0.5);
end

end

