addpath('tools');

savePath = '../output/'
stride = 1

d = dir('.');
isub = [d(:).isdir];
nameFolds = {d(isub).name}';
nameFolds(ismember(nameFolds,{'.','..','tools'})) = [];
nameFolds(~cellfun(@isempty,(regexp(nameFolds,'._out')))) = [];
disp(numel(nameFolds));

count = 0;
outCount = 0;
for f = 1:numel(nameFolds)
	disp(f);
	disp(nameFolds{f});
	files = get_synched_frames(nameFolds{f});

	c = numel(files);
	disp(strcat('filecount: ',int2str(c)));

	files = files(1:stride:c);
	c = numel(files);
	disp(strcat('filecount to process: ',int2str(c)));
	count = count + c;

	outFolder = strcat(savePath, nameFolds{f}, '_out');
	if ~exist(outFolder, 'dir')
		mkdir(outFolder);
	end
	parfor idx = 1:c
	    rgbFilename = strcat(nameFolds{f},'/',files(idx).rawRgbFilename);
	    depthFilename = strcat(nameFolds{f},'/',files(idx).rawDepthFilename);
	    outRGBFilename = strcat(savePath,nameFolds{f},'_out/',nameFolds{f},num2str(idx),'rgb.png');
	    outDepthFilename = strcat(savePath,nameFolds{f},'_out/',nameFolds{f},num2str(idx),'depth.png');
	    
	    rgb = imread(rgbFilename);
	    depth = imread(depthFilename);
	    depth = swapbytes(depth);
	    
	    [depthOut, rgbOut] = project_depth_map(depth, rgb);
   	    imgDepth = fill_depth_colorization(double(rgbOut) / 255.0, depthOut, 0.8);

	    imgDepth = imgDepth / 10.0 * 65535.0
	    imgDepth = uint16(imgDepth)
	    imwrite(rgbOut, outRGBFilename);
	    imwrite(imgDepth, outDepthFilename, 'png', 'bitdepth', 16);	
	end
        D = dir([outFolder, '/*rgb.png']);
	Num = length(D);
	disp(strcat('output filecount: ',int2str(Num)));
	outCount = outCount + Num;
end
disp(count);
disp(outCount);
