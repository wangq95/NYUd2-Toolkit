import os
import scipy.io as sio

root = './label16bit/'
newRgb_train = './train/rgb/'
newDep_train = './train/depth/'
newRgb_test  = './test/rgb/'
newDep_test  = './test/depth/'

for dir in [newRgb_train, newDep_train, newRgb_test, newDep_test]:
    if not os.path.exists(dir):
        os.makedirs(dir)

data = sio.loadmat('splits.mat')
train = data['trainNdxs']
trainId = []
for i in range(len(train)):
    trainId.append(int(train[i][0]))


for i in range(1449):
    rgbName = root + '%d_rgb.png' % (i+1)
    depName = root + '%d_depth.png' % (i+1)
    if (i+1) in trainId:
        newRgbName = newRgb_train + '%05d.png' % (i+1)
        newDepName = newDep_train + '%05d.png' % (i+1)
    else:
        newRgbName = newRgb_test + '%05d.png' % (i+1)
        newDepName = newDep_test + '%05d.png' % (i+1)
    os.system('cp %s %s' % (rgbName, newRgbName))
    os.system('cp %s %s' % (depName, newDepName))
