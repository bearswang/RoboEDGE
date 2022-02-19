# -*- coding: utf-8 -*-
"""
Created on Wed Apr 10 11:49:33 2019

@author: shuai wang
"""
import time
from SockFeeder import SockFeeder
# import pdb

# Author: Gael Varoquaux <gael dot varoquaux at normalesup dot org>
# License: BSD 3 clause

# Standard scientific Python imports
import matplotlib.pyplot as plt

# Import datasets, classifiers and performance metrics
from sklearn import datasets, svm, metrics

# The digits dataset
digits = datasets.load_digits()

# The data that we are interested in is made of 8x8 images of digits, let's
# have a look at the first 4 images, stored in the `images` attribute of the
# dataset.  If we were working from image files, we could load them using
# matplotlib.pyplot.imread.  Note that each image must have the same size. For these
# images, we know which digit they represent: it is given in the 'target' of
# the dataset.
images_and_labels = list(zip(digits.images, digits.target))
for index, (image, label) in enumerate(images_and_labels[:4]):
    plt.subplot(2, 4, index + 1)
    plt.axis('off')
    plt.imshow(image, cmap=plt.cm.gray_r, interpolation='nearest')
    plt.title('Training: %i' % label)

# To apply a classifier on this data, we need to flatten the image, to
# turn the data in a (samples, feature) matrix:
n_samples = len(digits.images)
data = digits.images.reshape((n_samples, -1))

# Create a classifier: a support vector classifier
classifier = svm.SVC(C=1,gamma=0.001)

###################### Main Section ######################
sf = SockFeeder('svm')
sf.connect()
batch_xs = []
batch_ys = []
while True:
    _, results = sf.get(num=10) #blocking, until get $num samples
    
    batch_xs = batch_xs+[x[0] for x in results] # collect all images
    batch_ys = batch_ys+[x[1] for x in results] # collect all labels
    classifier.fit(batch_xs, batch_ys)

    # Now predict the value of the digit on the second half:
    expected = digits.target[1001:]
    predicted = classifier.predict(data[1001:])
    print(metrics.accuracy_score(expected, predicted))

    pass
