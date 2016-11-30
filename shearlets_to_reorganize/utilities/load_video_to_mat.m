function [result, color_result] = load_video_to_mat( input_video, max_size, start_frame, end_frame)
%LOAD_VIDEO_TO_MAT Summary of this function goes here
%   Detailed explanation goes here

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

