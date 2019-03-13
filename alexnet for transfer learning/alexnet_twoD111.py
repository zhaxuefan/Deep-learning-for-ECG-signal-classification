#coding=utf-8  
from __future__ import print_function
from keras.models import Sequential  
from keras.layers import Dense,Flatten,Dropout  
from keras.callbacks import EarlyStopping  
from keras.layers.convolutional import Conv2D,MaxPooling2D   
import numpy as np  
from keras.utils.vis_utils import plot_model  
import keras
seed = 7  
np.random.seed(seed)  

import os

os.environ['CUDA_VISIBLE_DEVICES'] = '3'

from keras import backend as K
import numpy as np
import scipy.io as sio  
import matplotlib.pyplot as plt
class LossHistory(keras.callbacks.Callback):
    def on_train_begin(self, logs={}):
        self.losses = {'batch':[], 'epoch':[]}
        self.accuracy = {'batch':[], 'epoch':[]}
        self.val_loss = {'batch':[], 'epoch':[]}
        self.val_acc = {'batch':[], 'epoch':[]}

    def on_batch_end(self, batch, logs={}):
        self.losses['batch'].append(logs.get('loss'))
        self.accuracy['batch'].append(logs.get('acc'))
        self.val_loss['batch'].append(logs.get('val_loss'))
        self.val_acc['batch'].append(logs.get('val_acc'))

    def on_epoch_end(self, batch, logs={}):
        self.losses['epoch'].append(logs.get('loss'))
        self.accuracy['epoch'].append(logs.get('acc'))
        self.val_loss['epoch'].append(logs.get('val_loss'))
        self.val_acc['epoch'].append(logs.get('val_acc'))

    def loss_plot(self, loss_type):
        iters = range(len(self.losses[loss_type]))
        plt.figure()
        # acc
        plt.plot(iters, self.accuracy[loss_type], 'r', label='train acc')
        # loss
        plt.plot(iters, self.losses[loss_type], 'g', label='train loss')
        if loss_type == 'epoch':
            # val_acc
            plt.plot(iters, self.val_acc[loss_type], 'b', label='val acc')
            # val_loss
            plt.plot(iters, self.val_loss[loss_type], 'k', label='val loss')
        plt.grid(True)
        plt.xlabel(loss_type)
        plt.ylabel('acc-loss')
        plt.legend(loc="upper right")
        plt.savefig('epoch_2d.png')
        plt.show()

def load_data(path='exex.mat'):
    """Loads the MNIST dataset.

    # Arguments
        path: path where to cache the dataset locally
            (relative to ~/.keras/datasets).

    # Returns
        Tuple of Numpy arrays: `(x_train, y_train), (x_test, y_test)`.
    """
    #matlab文件名  
    matfn='/home/liuying/ecg_Keras/graduatezha/newdata2D.mat'
    data1=sio.loadmat(matfn)
    x_train = np.array(data1.get('x_train'))
    x_test = np.array(data1.get('x_test'))
    y_train = np.array(data1.get('y_train'))
    y_test = np.array(data1.get('y_test'))
    return (x_train, y_train), (x_test, y_test)
 
    

  

batch_size = 32
num_classes = 2
epochs = 30

# input image dimensions
img_rows, img_cols = 250, 250


# the data, shuffled and split between train and test sets
(x_train, y_train), (x_test, y_test) = load_data(path='/home/liuying/ecg_Keras/graduatezha/newdata2D.mat')

if K.image_data_format() == 'channels_first':
    x_train = x_train.reshape(x_train.shape[0], 1, img_rows, img_cols)
    x_test = x_test.reshape(x_test.shape[0], 1, img_rows, img_cols)
    input_shape = (1, img_rows, img_cols)
else:
    x_train = x_train.reshape(x_train.shape[0], img_rows, img_cols, 1)
    x_test = x_test.reshape(x_test.shape[0], img_rows, img_cols, 1)
    input_shape = (img_rows, img_cols, 1)

x_train = x_train.astype('float32')
x_test = x_test.astype('float32')
x_train /= 255
x_test /= 255
print('x_train shape:', x_train.shape)
print(x_train.shape[0], 'train samples')
print(x_test.shape[0], 'test samples')
print(y_test.shape)

# convert class vectors to binary class matrices
#y_train = keras.utils.to_categorical(y_train, num_classes)
#y_test = keras.utils.to_categorical(y_test, num_classes)
print(y_train.shape)
print(y_test.shape)

 
model = Sequential()  
model.add(Conv2D(32,(7,7),strides=(3,3),input_shape=(250,250,1),padding='valid',
                 activation='relu',kernel_initializer='uniform',
                 W_regularizer=keras.regularizers.l2(0.01)))  
model.add(MaxPooling2D(pool_size=(3,3),strides=(2,2)))  
model.add(Conv2D(64,(5,5),strides=(1,1),padding='same',activation='relu',
                 kernel_initializer='uniform'))
model.add(MaxPooling2D(pool_size=(3,3),strides=(2,2)))  
model.add(Conv2D(128,(3,3),strides=(1,1),padding='same',activation='relu',
                 kernel_initializer='uniform'))
model.add(Conv2D(128,(3,3),strides=(1,1),padding='same',activation='relu',
                 kernel_initializer='uniform')) 
model.add(Conv2D(128,(3,3),strides=(1,1),padding='same',activation='relu',
                 kernel_initializer='uniform')) 
model.add(MaxPooling2D(pool_size=(3,3),strides=(2,2)))  
model.add(Flatten())  
model.add(Dense(2048,activation='relu'))  
model.add(Dropout(0.5))
model.add(Dense(2048,activation='relu'))  
model.add(Dropout(0.5))
model.add(Dense(2,activation='softmax'))  


model.compile(loss=keras.losses.categorical_crossentropy,
              optimizer=keras.optimizers.Adadelta(),
              metrics=['accuracy'])
history = LossHistory()
#early_stopping =EarlyStopping(monitor='acc', min_delta=0.0001,patience=5,mode='max')
model.fit(x_train, y_train,
          batch_size=batch_size,
          epochs=epochs,
          verbose=1,
          shuffle=True,
          validation_data=(x_test, y_test),
          callbacks=[history])


#json_string = model.to_json()#等价于 json_string = model.get_config()
#open('my_model_architecture.json','w').write(json_string)
#model.save_weights('my_model_weights.h5')


score = model.evaluate(x_test, y_test, verbose=0)
print('Test loss:', score[0])
print('Test accuracy:', score[1])
#plot_model(model, to_file='model_2d.png')
#history.loss_plot('epoch')
#model.summary()
