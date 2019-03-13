# -*- coding: utf-8 -*-
# -*- coding: utf-8 -*-
# -*- coding: utf-8 -*-
"""
Created on Mon Oct 16 21:00:54 2017

@author: Shawn Yuen
"""

from __future__ import print_function
# keras modules
from keras.models import Sequential
from keras.layers import Dense, Dropout, Conv1D, MaxPooling1D,Flatten
import numpy as np

import os

os.environ['CUDA_VISIBLE_DEVICES'] = '1'

# plot ecg

import tensorflow as tf
import keras

# for loading data
import scipy.io

#check version of tf and k
print('tf version is', tf.__version__)
print('keras version is', keras.__version__)

# load ECG data
#data = scipy.io.loadmat('one_dim.mat')
data = scipy.io.loadmat('/home/liuying/ecg_Keras/oneDnoise30.mat')
#data = scipy.io.loadmat('C:/Users/lab/Desktop/one_dimen.mat')
# test set
x_test = data['x_test']
x_test = np.expand_dims(x_test, axis=2)
y_test = data['y_test']

# training set
x_train = data['x_train']
x_train = np.expand_dims(x_train, axis=2)
y_train = data['y_train']

# free up memory
del(data)

print(len(x_train), 'training examples')
print(len(x_test), 'test examples')

print('x_train shape is', x_train.shape)
print('x_test shape is', x_test.shape)

# plot a ecg for checking
#plt.figure('ecg')
#plt.plot(range(820),np.squeeze(x_train[101,:,:]))

# hyper parameters in ConNets
hidden_dims = 100
batch_size = 64
epochs =100
# model
print('Building model...')
model = Sequential()
 
model.add(Conv1D(32,7,strides=3,input_shape=(820,1),padding='valid',activation='relu',kernel_initializer='uniform'))  
model.add(MaxPooling1D(pool_size=3,strides=2))  
model.add(Conv1D(64,5,strides=1,padding='same',activation='relu',kernel_initializer='uniform'))  
model.add(MaxPooling1D(pool_size=3,strides=2)) 
model.add(Conv1D(128,3,strides=1,padding='same',activation='relu',kernel_initializer='uniform'))  
model.add(Conv1D(128,3,strides=1,padding='same',activation='relu',kernel_initializer='uniform'))  
model.add(Conv1D(128,3,strides=1,padding='same',activation='relu',kernel_initializer='uniform'))  
model.add(MaxPooling1D(pool_size=3,strides=2))  
model.add(Flatten())  
model.add(Dense(1024,activation='relu'))  
model.add(Dropout(0.5))  
model.add(Dense(1024,activation='relu'))  
model.add(Dropout(0.5))  
model.add(Dense(1,activation='sigmoid'))  

model.compile(loss='binary_crossentropy', optimizer='adam', metrics=['accuracy'])
model.fit(x_train, y_train, batch_size=batch_size, epochs=epochs, validation_split=0.2)

score = model.evaluate(x_test, y_test, verbose=0)
print('Test loss:', score[0])
print('Test accuracy:', score[1]) 