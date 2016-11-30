function comparison_local_maxima_in_frame( VID, COLOR_VID, cl_video_max, min_threshold, window, pause_between_frames, upper_limit, visualization_cmap, save_filename)
%SHEARLET_PLOT_GRAYLEVEL_LOCAL_MAXIMA Summary of this function goes here
%   Detailed explanation goes here

%
% if(nargin == 8)
%     vidOut = VideoWriter(save_filename);
%     vidOut.Quality = 100;
%     vidOut.FrameRate = 25;
%     open(vidOut);
%     outimg = 255*ones(size(VID(:,:,1),1),20+size(VID(:,:,1),2)*2,3); 
% end

% if(nargin < 6)
%     upper_limit = 3;
%     if(nargin < 5)
%         pause_between_frames = true;
%         if(nargin < 4)
%             window = 3;
%         end
%     end
% end


%
% CURMAT = cl_video_max;
% CURMAT(CURMAT < min_threshold) = 0;
% 
% %
% Amin=minmaxfilt(CURMAT,window,'max','same'); % alternatively use imerode in image processing
% [i, j, k]=ind2sub(size(CURMAT),find(Amin==CURMAT & CURMAT > 0)); % <- index of local minima
% 
% %
% idxkeep=find(i>window & i<size(VID,1)-window & j>window & j<size(VID,2)-window & k>window & k<size(VID,3)-window);
% 
% %
% i=i(idxkeep);
% j=j(idxkeep);
% k=k(idxkeep);

[i, j, k] = shearlet_local_maxima_in_3D_matrix(cl_video_max, 0, window, size(VID));
[it, jt, kt] = shearlet_local_maxima_in_3D_matrix(cl_video_max, min_threshold, window, size(VID));

% coordinates = [i j k];
% 
% fprintf('Found local maxima: %d.\n', size(i,1));

c=15;


%
figure('Position', [755 217 1024 214]);
size(COLOR_VID)
%
while true
    
    %
    id = find(k==c);
    idt = find(kt==c);
    
    %
    subplot(1,3,1);
    imshow(COLOR_VID(:,:,:,c)./255, []);
    
    subplot(1,3,2);
%     imshow(COLOR_VID(:,:,:,c)./255, []);
    
    fprintf('Frame: %d..\n', c);
    
    if(nargin >= 7)
        
        ttemp = cl_video_max(:,:,c);
        ttemp(ttemp > upper_limit) = upper_limit;
        ttemp = gray2ind(ttemp, 256);
        ttemp = ind2rgb(ttemp, visualization_cmap);
        
        imshow(ttemp);
        
%         if(nargin >= 8)
%            outimg(:, 1:size(VID(:,:,1),2), :) = cat(3, VID(:,:,c),VID(:,:,c),VID(:,:,c));
%            outimg(:,size(VID(:,:,1),2)+20+1:end, :) = ttemp * 255;
%            writeVideo(vidOut, outimg / 255.); 
%         end
    else
        imshow(cl_video_max(:,:,c), [0 upper_limit]);
    end
    
    
    %
    if(size(id,1) > 0)
        
%         subplot(1,3,2);
%         hold on
%         
%         plot(j(id), i(id), 'ro', 'MarkerSize', 20, 'LineWidth', 5);
%         
%         hold off
%         
        subplot(1,3,3);
        imshow(COLOR_VID(:,:,:,c)./255, []);

        hold on
        
        plot(jt(idt), it(idt), 'ro', 'MarkerSize', 20, 'LineWidth', 5);
        
        hold off

%         for ind=1:size(id,1)
%             
%             
%             
%             
%             subplot(1,3, 3);
%             imshow(imresize(VID(i(id(ind))-window:i(id(ind))+window, ...
%                 j(id(ind))-window:j(id(ind))+window,c), 13), []);
%             
%             if(pause_between_frames)
%                 waitforbuttonpress;
%             end
%             
%         end
        
%         hold off
        
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
    
    pause(0.0001);
    
    break;
    
%     c = c + 1;
%     
%     if(c == 91)
%         c=2;
%                 break;
%     end
end

% close(vidOut1);

end

