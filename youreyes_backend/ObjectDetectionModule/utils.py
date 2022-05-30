
import tensorflow as tf 


class Utils():

    def __init__(self,boxes,predConf,iouThreshold,probThreshold):
        self.boxes = boxes
        self.predConf = predConf
        self.iouThreshold = iouThreshold
        self.probThreshold = probThreshold
      
    def readClassNames(self,class_file_name):
        names = {}
        with open(class_file_name, 'r') as data:
            for ID, name in enumerate(data):
                names[ID] = name.strip('\n')
        return names

    def performNMS(self):
        print('[INFO] Performing NMS')
        boxess, scores, classes, valid_detections = tf.image.combined_non_max_suppression(
            boxes=tf.reshape(self.boxes, (tf.shape(self.boxes)[0], -1, 1, 4)),
            scores=tf.reshape(
                self.predConf, (tf.shape(self.predConf)[0], -1, tf.shape(self.predConf)[-1])),
            max_output_size_per_class=50,
            max_total_size=50,
            iou_threshold=self.iouThreshold,
            score_threshold=self.probThreshold
        )
        return boxess, scores, classes, valid_detections
