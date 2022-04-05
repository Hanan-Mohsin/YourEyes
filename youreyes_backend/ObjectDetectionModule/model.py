import os
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '3'
import tensorflow as tf
physical_devices = tf.config.experimental.list_physical_devices('GPU')
if len(physical_devices) > 0:
    tf.config.experimental.set_memory_growth(physical_devices[0], True)
from tensorflow.python.saved_model import tag_constants
from config.config import cfg

class Model():

    def __init__(self,imagesData):
        self.imagesData = imagesData
        
    def predict(self):
        print('[INFO] Predicting')
       # STRIDES, ANCHORS, NUM_CLASS, XYSCALE = utils.load_config() 
        saved_model_loaded = tf.saved_model.load(cfg.WEIGHT, tags=[tag_constants.SERVING])
        infer = saved_model_loaded.signatures['serving_default']
        batch_data = tf.constant(self.imagesData)
        pred_bbox = infer(batch_data)
        for key, value in pred_bbox.items():
            boxes = value[:, :, 0:4]
            pred_conf = value[:, :, 4:]
        return boxes,pred_conf