#!/usr/bin/env sh

MY=/home/liuying/caffe-master/ECGnet/data
#MY=data


echo "Create train lmdb.."
rm -rf $MY/img_train_lmdb
/home/liuying/caffe-master/build/tools/convert_imageset \
--shuffle \
--resize_height=256 \
--resize_width=256 \
/home/liuying/caffe-master/ECGnet/data/ \
$MY/train_shawn.txt \
$MY/img_train_lmdb

echo "Create test lmdb.."
rm -rf $MY/img_test_lmdb
/home/liuying/caffe-master/build/tools/convert_imageset \
--shuffle \
--resize_width=256 \
--resize_height=256 \
/home/liuying/caffe-master/ECGnet/data/ \
$MY/test_shawn.txt \
$MY/img_test_lmdb

echo "All Done.."
