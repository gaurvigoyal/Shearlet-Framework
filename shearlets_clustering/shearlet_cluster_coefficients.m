function [ res_clusters, ctrs ] = shearlet_cluster_coefficients( coeffs_mat, cluster_num, sizes)
%SHEARLET_CLUSTER_COEFFICIENTS Summary of this function goes here
%   Detailed explanation goes here

opts = statset('Display','final', 'MaxIter',200);

[cidx, ctrs] = kmeans(coeffs_mat, cluster_num, 'Distance', 'sqeuclidean', 'Replicates',3, 'Options',opts);

res_clusters = reshape(cidx, sizes(2), sizes(1), 1);
res_clusters = res_clusters';

end

