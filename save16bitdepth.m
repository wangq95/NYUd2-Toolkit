addpath('../nyud_raw_data/tools');

total = load('nyu_depth_v2_labeled.mat');
depthName = total.rawDepthFilenames;
rgbName   = total.rawRgbFilenames;

disp(['images number:', num2str(numel(rgbName))]);

parfor index = 1:numel(rgbName)
    rgb = strcat('../nyud_raw_data/', rgbName(index));
    dep = strcat('../nyud_raw_data/', depthName(index));
    disp(rgb);
    disp(dep);
    sr = strsplit(rgb{1}, '.');
    sd = strsplit(dep{1}, '.');
    if ~strcmp(sr{2}, sd{2})
        disp(num2str(index));
    end

    outRGBFilename   = strcat('./label16bit/', num2str(index),'_rgb.png');
    outDepthFilename = strcat('./label16bit/', num2str(index),'_depth.png');
        
    rgb_ = imread(rgb{1});
    depth = imread(dep{1});
    depth = swapbytes(depth);
    
    [depthOut, rgbOut] = project_depth_map(depth, rgb_);
    imgDepth = fill_depth_colorization(double(rgbOut) / 255.0, depthOut, 0.8);

    imgDepth = imgDepth / 10.0 * 65535.0;
    imgDepth = uint16(imgDepth);
    imwrite(rgbOut, outRGBFilename);
    imwrite(imgDepth, outDepthFilename, 'png', 'bitdepth', 16);
    disp('-------------------end--------------------')
end
