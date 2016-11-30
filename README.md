## Shearlet-Framework

Github repository for the shearlets-based framework developed during the second year of my PhD studies, relies on the use of ShearLab3D (http://www.shearlab.org/) to carry on video signal processing tasks.

## Code Example

The following is an example of the function calls needed to load a video `walk-simple.avi`, resize it so that none of its sizes are greater than 160 pixels, and select only the frames from 1 to 100.
```matlab
    % load the video sequence
    VID = load_video_to_mat('walk-simple.avi',160, 1,100);
    
    % calculate the shearlets coefficients
    COEFFS = shearlet_transform_3D(VID,46,91,[0 1 1], 3, 1);
    
    % parameters setup
    LOWER_THRESHOLD = 0.1;
    SPT_WINDOW = 11;
    
    % detects spatio-temporal interesting points within a subsequence of the original video 
    COORDINATES = shearlet_detect_points( VID(:,:,1:91), COEFFS, [2 3], [], LOWER_THRESHOLD, SPT_WINDOW, false);
```

## Installation

To use this framework, download:

- this repository as a ZIP file
- the ShearLab3D code from the website http://www.shearlab.org/ 

Unpack the archives in a directory, then add all the source files to the MATLAB path by clicking on "Add to Path -> Selected Folder and Subfolders" in the MATLAB file browser (alternatively, you can use the `addpath(genpath(your_root_folder))` in the MATLAB command prompt). 

To start using the framework remember that you need to have within your MATLAB path also the video sequences you want to process.

## License

A short snippet describing the license (MIT, Apache, etc.)