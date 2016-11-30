function [ big_coeffs, shearletIdxs] = shearlet_transform_3D( X, central_frame, neigh_window, shearLevels, scales, useGPU )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% impostazione di default per i livelli di shearing:
% in questo modo si avranno 3x3, 5x5, 5x5 shearing nelle scale
if(isempty(shearLevels))
    shearLevels = [0 1 1];
end

% se non specificato dall'utente, non usa la GPU
if(nargin < 5)
    useGPU = 0;
end

%
start_ind = central_frame - (neigh_window-1)/2;
end_ind = central_frame + (neigh_window-1)/2;

start_ind = max(start_ind,1);
end_ind = min(end_ind, size(X,3));

%
Xactual = X(:,:,start_ind:end_ind);

%
st = tic;
[Xfreq, ~, preparedFilters, dualFrameWeightsCurr, shearletIdxs] = SLprepareSerial3D(useGPU,Xactual,scales,shearLevels, true);
fprintf('-- Time for Serial Preparation: %.4f seconds\n', toc(st));

st = tic;

%
big_coeffs = zeros(size(Xactual,1), size(Xactual,2), size(Xactual,3), size(shearletIdxs,1));

%
for j = 1:size(shearletIdxs,1)
    shearletIdx = shearletIdxs(j,:);
    
    %%shearlet decomposition
    [coeffs,~, dualFrameWeightsCurr,~] = SLsheardecSerial3D(Xfreq,shearletIdx,preparedFilters,dualFrameWeightsCurr);
    
    if(~useGPU)
        big_coeffs(:,:,:,j) = coeffs;
    else
        big_coeffs(:,:,:,j) = gather(coeffs);
    end
    
end

%
fprintf('-- Time for Serial Decomposition: %.4f seconds\n', toc(st));

end

