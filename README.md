# ECG-classification
Deep learning in ECG classification
Turn one-dimension signal into two-dimension signal and process data in computer vision. 
Built 2D ECG database based on image segmentation and deep neural network. 
Combining with traditional signal processing method and neural network transfer learning to achieve very high signal classification accuracy in real time.

Data preprocessing is based on matlab. Algorithm is mainly based on segmentation and denoise. In order to compare noise influence on physiological signal, preprocessing is divided into raw signal and noise signal before put into neural network. The other important part in this paper is turn 1-D signal into 2-D signal, we also did that in preprocessing code. Classification is based on Alexnet. Since ECG signal is 1-D signal, classification is both from classify 1-D signal and 2-D signal, Conv layer is revised by dimension.

The publication for this project has been posted on 
[1]ECG classification based on transfer learning and deep convolution neural network
[2] A Comparison of 1-D and 2-D Deep Convolutional Neural Networks in ECG Classification
