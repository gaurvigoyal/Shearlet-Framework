function [coordinates] = shearlet_plot_graylevel_local_maxima( VID, cl_video_max, min_threshold, window, pause_between_frames, upper_limit, visualization_cmap, save_filename)
%SHEARLET_PLOT_GRAYLEVEL_LOCAL_MAXIMA Summary of this function goes here
%   Detailed explanation goes here



% vidOut1 = VideoWriter(['outbox2_' save_filename]);
% vidOut.Quality = 100;
% vidOut.FrameRate = 25;
% open(vidOut1);


%
if(nargin == 8)
    vidOut = VideoWriter(save_filename);
    vidOut.Quality = 100;
    vidOut.FrameRate = 25;
    open(vidOut);
    outimg = 255*ones(size(VID(:,:,1),1),20+size(VID(:,:,1),2)*2,3);
end

if(nargin < 7)
    visualization_cmap = colormap(jet(256));
    if(nargin < 6)
        upper_limit = 3;
        if(nargin < 5)
            pause_between_frames = false;
            if(nargin < 4)
                window = 3;
            end
        end
    end
end

% parameters controls
if(window < 1)
    ME = MException('shearlet_plot_graylevel_local_maxima:invalid_window_size', ...
        'You have to specify a window size greater than 1.');
    throw(ME);
end

if(min_threshold < 0)
    warning('shearlet_plot_graylevel_local_maxima:negative_min_threshold', ...
        'A negative threshold is meaningless, value set to 0.');
    min_threshold = 0;
end

% if the user specified it, pauses between each frame and 
% shows a slice corresponding to the current spatio-temporal point
if(pause_between_frames)
    num_plots = 3;
else
    num_plots = 2;
end

% 
% [i, j, k] = shearlet_local_maxima_in_3D_matrix(cl_video_max, 0, window, size(VID));
[i, j, k] = shearlet_local_maxima_in_3D_matrix(cl_video_max, min_threshold, window, size(VID));

coordinates = [i j k];

fprintf('-- Found local maxima: %d.\n', size(i,1));

c=2;

%
figure('Position', [-1320 184 1266 594]);

%
while true
    
    %
    id = find(k==c);
    
    %
    subplot(1,num_plots,1);
    imshow(VID(:,:,c), []);
    
    subplot(1,num_plots, 2);
    
    %     fprintf('Frame: %d..\n', c);
    
    if(nargin >= 7)
        
        ttemp = cl_video_max(:,:,c);
        ttemp(ttemp > upper_limit) = upper_limit;
        ttemp = gray2ind(ttemp, 256);
        ttemp = ind2rgb(ttemp, visualization_cmap);
        
        imshow(ttemp);
        
        if(nargin >= 8)
            outimg(:, 1:size(VID(:,:,1),2), :) = cat(3, VID(:,:,c),VID(:,:,c),VID(:,:,c));
            outimg(:,size(VID(:,:,1),2)+20+1:end, :) = ttemp * 255;
            writeVideo(vidOut, outimg / 255.);
        end
    else
        imshow(cl_video_max(:,:,c), [0 upper_limit]);
    end
    
    
    %
    if(size(id,1) > 0)
        
        subplot(1,num_plots,1);
        hold on
        
        plot(j(id), i(id), 'ro', 'MarkerSize', 20, 'LineWidth', 5);
        
        if(pause_between_frames)
            for ind=1:size(id,1)
                
                subplot(1,num_plots, 3);
                imshow(imresize(VID(i(id(ind))-window:i(id(ind))+window, ...
                    j(id(ind))-window:j(id(ind))+window,c), 13), []);
                
                if(pause_between_frames)
                    waitforbuttonpress;
                end
                
            end
        end
        hold off
        
        % waitforbuttonpress
    end
    
    %         fig = getframe(gcf);
    %         writeVideo(vidOut1, fig.cdata);
    %         writeVideo(vidOut1, fig.cdata);
    %         writeVideo(vidOut1, fig.cdata);
    %         writeVideo(vidOut1, fig.cdata);
    %         writeVideo(vidOut1, fig.cdata);
    %         writeVideo(vidOut1, fig.cdata);
    %         writeVideo(vidOut1, fig.cdata);
    %         writeVideo(vidOut1, fig.cdata);
    %         writeVideo(vidOut1, fig.cdata);
    %         writeVideo(vidOut1, fig.cdata);
    
    % sets a small pause, then increases the
    % current frame counter
    pause(0.04);
    c = c + 1;
    
    % if the end of the sequence has been reached,
    % exits the loop (the commented line should be
    % swapped with the one below it, in case the user
    % wants to see the sequence looping)
    if(c == 91)
        %         c=2;
        break;
    end
    
end

% close(vidOut1);

end



