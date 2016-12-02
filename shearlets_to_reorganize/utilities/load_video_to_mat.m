function [result, color_result] = load_video_to_mat( input_video, max_size, start_frame, end_frame)
%LOAD_VIDEO_TO_MAT Loads a video sequence both in grayscale and color
%
% Usage:
%   [result, color_result] = load_video_to_mat('sequence.avi', 128, 100, 200)
%           Loads the video clip represented by the file 'sequence.avi',
%           from frame 100 to frame 200. Moreover, it resizes all the 
%           frames so that  the maximum size (height or width) is not 
%           greater than 128 pixels.
%           
% Parameters:
%   input_video: the filename of the input video sequence.
%   max_size: the maximum lateral size of every frame.
%   start_frame: the frame to start loading from.
%   end_frame: the last frame to load.
%
% Output:
%   result: a 3-dimensional matrix representing the video sequence, with
%           every frame converted to graylevels.
%   color_result: a 3-dimensional matrix representing the original video 
%                 sequence
%
%   See also ...
%
% 2016 Damiano Malafronte.

vidObj = VideoReader(input_video);

i = 1;
count = 1;

if(nargin < 2)
   max_size = 0; 
end

if(nargin < 3)
    start_frame = 1;
end

if(nargin < 4)
    end_frame = floor(vidObj.Duration * vidObj.FrameRate);
end

frame_h = vidObj.Height;
frame_w = vidObj.Width;
% color_result = zeros(frame_h, frame_w,3,end_frame-start_frame+1);

if(max_size > 0 && max_size < max(frame_h, frame_w))
    ratio = max_size / max(frame_h, frame_w);
    
    
    frame_h = round(frame_h * ratio);
    frame_w = round(frame_w * ratio);
    
    resize_frame = true;
else
    resize_frame = false;
end

result = zeros(frame_h, frame_w,end_frame-start_frame+1);
color_result = zeros(frame_h, frame_w,3,end_frame-start_frame+1);

while(hasFrame(vidObj) && count <= end_frame)
    color_frame = readFrame(vidObj);
    frame = rgb2gray(color_frame);
    if(count >= start_frame)
        if(resize_frame)
            result(:,:,i) = imresize(frame, ratio);
            color_result(:,:,:,i) = imresize(color_frame(:,:,:), ratio);
        else
            result(:,:,i) = frame;
            color_result(:,:,:,i) = color_frame(:,:,:);
        end
%         color_result(:,:,:,i) = color_frame(:,:,:);
        i = i + 1;
    end
    count = count + 1;
end

end

