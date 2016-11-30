function [counts] = comparison_points_over_time( video, target_coordinates )
%COMPARISON_POINTS_OVER_TIME Summary of this function goes here
%   Detailed explanation goes here

c=2;

figure;
counts = zeros(1,size(video,3));

for i=1:size(target_coordinates,1)
    counts(target_coordinates(i,3)) = counts(target_coordinates(i,3)) + 1;
end

% plot(1:numel(counts), counts, 'r-');

bar(counts);

xlabel('frame')
ylabel('points found')
xlim([0 91]);

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
%         break;
%     end
%     
% end


end

