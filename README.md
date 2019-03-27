# NYU-d v2 Tools

Here, we provide a simple tool for pre-processing of NYU-d v2 dataset. As the the NYU-d v2 author only provide the original dumped data collected by Kinect. When we apply monocular depth estimation on NYU-d v2 dataset, we shoule generate the **RGB** image and **dense depth map** ourself, the process method is as follows.

## Requirements

These code are tested on Ubuntu 16.04 LTS with MATLAB 2015b and Python2.7.


## Dataset preparation

1. Download the **raw data** of [NYU-d v2 dataset](https://cs.nyu.edu/~silberman/datasets/nyu_depth_v2.html#raw_parts), which more than ``400G``, please make sure that you have enough disk space availabel. Then extract them into the directory ``nyud_raw_data``. At the same time, download the ``Toolbox`` and extract it.

2. The dataset is divided into ``590`` folders which correspond to each ``scene`` being filmed, such as ``living_room_0012``. The file is structured as follows:

```bash
/
../bedroom_0001/
../bedroom_0001/a-1294886363.011060-3164794231.dump
../bedroom_0001/a-1294886363.016801-3164794231.dump
                  ...
../bedroom_0001/d-1294886362.665769-3143255701.pgm
../bedroom_0001/d-1294886362.793814-3151264321.pgm
                  ...
../bedroom_0001/r-1294886362.238178-3118787619.ppm
../bedroom_0001/r-1294886362.814111-3152792506.ppm
```

Files that begin with the prefix ``a-`` are the accelerometer dumps. Files that begin with the prefix ``r-`` and ``d-`` are the frames from the RGB and depth cameras, respectively. You can use ``get_synched_frames.m`` function in the Toolbox to find the matching relationship between ``rgb image`` and ``depth map``.

## Generate the RGB and Dense Depth map

1. Put the script ``process_raw.m`` and the ``Toolbox`` into dir ``nyud_raw_data`` as mentioned above.

2. Modify the ``savePath`` and ``stride``, which the ``savePath`` termed the output path and the ``stride`` control the number of output files. The default value of ``stride`` is ``1``, which will save all images.

3. Open matlab under ``tmux`` for the sake of long processing time and run the script ``process_raw.m``.

Sample results are as follows:

rgb image with resolution of ``480 * 640``:
![rgb](https://github.com/QianshengGu/NYU-d-v2-Tools/blob/master/misc/rgb.png)

dense depth image with the same resolution of rgb image:
![depth]()

Tips: For better training, I save the dense depth of RGB image with the data format of **16 bit**, so the value of depth map is between ``0`` and ``65535``, as defined at:

```bash
imgDepth = imgDepth / 10.0 * 65535.0
imgDepth = uint16(imgDepth)
imwrite(imgDepth, outDepthFilename, 'png', 'bitdepth', 16);
```

## Generate the NYU-d v2 thin dataset

In general, we can also generate a thin dataset which has ``1449`` images totally. ``795`` is for training and ``654`` is for testing. 

1. Firstly, you should download the thin dataset **integrated** into one ``.mat`` file from the same url above, named ``Labeled dataset (~2.8 GB)``, then extract it to get ``nyu_depth_v2_labeled.mat`` which contents:

```bash
accelData:         [1449×4 single]
depths:            [480×640×1449 single]
images:            [480×640×3×1449 uint8]
instances:         [480×640×1449 uint8]
labels:            [480×640×1449 uint16]
names:             {894×1 cell}
namesToIds:        [894×1 containers.Map]
rawDepthFilenames: {1449×1 cell}
rawDepths:         [480×640×1449 single]
rawRgbFilenames:   {1449×1 cell}
sceneTypes:        {1449×1 cell}
scenes:            {1449×1 cell}
```

2. Run ``save16bitdepth.m`` to save the ``16bit`` dense depth map of ``1449`` images, while the ``RGB`` images can be obtained by directly save from the ``images`` attributes of ``nyu_depth_v2_labeled.mat``.

3. Run ``nyud_split.py`` to split ``1449`` images to ``test`` and ``train`` subset for practical application. You should change the variables refer to ``PATH`` as you wish.
