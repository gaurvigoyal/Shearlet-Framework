function [ blur_points_heatmap, res ] = comparison_heatmap_from_points( video, coordinates )
%COMPARISON_HEATMAP Summary of this function goes here
%   Detailed explanation goes here


c=2;

% close all;

figure;

img = zeros(size(video, 1), size(video, 2));

for i=1:size(coordinates,1)
    if(coordinates(i,1) >= 1 && coordinates(i,1) <= size(video,1))
        img(coordinates(i,1),coordinates(i,2)) = img(coordinates(i,1),coordinates(i,2)) + 1;
    end
end

Iblur1 = imgaussfilt(img,1);

subplot(1,3,1);
imshow(img, []);
subplot(1,3,2);
imshow(Iblur1, []);
subplot(1,3,3);
% imshow(Iblur1 > 0.01, []);

blackimg = zeros(size(video, 1), size(video, 2));
imshow(blackimg, []);

hold on 
for i=1:size(coordinates,1)
plot(coordinates(i,2), coordinates(i,1), 'w.','MarkerFaceColor',[1 0 0], 'MarkerEdgeColor',[1 0 0], 'MarkerSize',34);
plot(coordinates(i,2), coordinates(i,1), 'w.', 'LineWidth',2,...
    'MarkerFaceColor',[1 1 1], 'MarkerSize',24);
end
hold off




figure;

res = cat(3, video(:,:,1), video(:,:,1), video(:,:,1)) ./ 255;

out_red = res(:,:,1);

Iblurnorm = Iblur1 ./ max(Iblur1(:));

out_red(Iblur1 > 0.01) = Iblurnorm(Iblur1 > 0.01);

out_red(Iblur1 > 0.01) = 1;


res(:,:,1) = max(res(:,:,1), out_red);

imshow(res);

blur_points_heatmap = Iblur1;

%
% % plot(1:numel(counts), counts, 'r-');
%
% bar(counts);
%
% fHand = figure('Name', 'Points', 'Position', [31 521 531 387]);
%
% while true
%
%     id = find(target_coordinates(:, 3) == c);
%
%     figure(fHand);
%     imshow(video(:,:,c), []);
%     set(fHand, 'Position', [31 521 531 387]);
%
%     if(size(id,1) > 0)
%         hold on
%         plot(target_coordinates(id, 2), target_coordinates(id,1), 'ro', 'MarkerSize', 20, 'LineWidth', 5);
%         hold off
%     end
%
%     pause(0.04);
%
%     c = c + 1;
%
%     if(c == size(video,3))
%         c=2;
%     end
%
% end


end

