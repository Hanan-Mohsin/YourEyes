import colorsys
import random
import cv2
import numpy as np
import tensorflow as tf
from config.config import cfg
import ObjectDetectionModule.utils as utils
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

    def printInfo(self,pred_bbox,imageName):
        class_names = list(self.readClassNames(cfg.YOLO.CLASSES).values())
        num_classes = len(class_names)
        detections = []
        out_boxes, out_scores, out_classes, num_boxes = pred_bbox

        for i in range(num_boxes):
            if int(out_classes[i]) < 0 or int(out_classes[i]) > num_classes: continue
            coor = out_boxes[i]
            score = out_scores[i]
            class_ind = int(out_classes[i])
            class_name = class_names[class_ind]
            
            if class_name not in class_names:
                continue
            else:
                detections.append({"class":class_name,"confidence":str(score),"BBoxes":{"ymin":str(coor[0]), "xmin":str(coor[1]), "ymax":str(coor[2]), "xmax":str(coor[3])}})
                print("Object found: {}, Confidence: {:.2f}, BBox Coords (ymin, xmin, ymax, xmax): {}, {}, {}, {} ".format(class_name, score, coor[0], coor[1], coor[2], coor[3]))
        result = {"image":imageName,"detections":detections}
        return result

    def format_boxes(self,bboxes,original_image):
        image_height , image_width,_ = original_image.shape
        for box in bboxes:
            ymin = int(box[0] * image_height)
            xmin = int(box[1] * image_width)
            ymax = int(box[2] * image_height)
            xmax = int(box[3] * image_width)
            box[0], box[1], box[2], box[3] = xmin, ymin, xmax, ymax
        return bboxes

    def draw_bbox(self,bboxes,image):
        classes = list(self.readClassNames(cfg.YOLO.CLASSES).values())
        num_classes = len(classes)
        image_h, image_w, _ = image.shape
        hsv_tuples = [(1.0 * x / num_classes, 1., 1.) for x in range(num_classes)]
        colors = list(map(lambda x: colorsys.hsv_to_rgb(*x), hsv_tuples))
        colors = list(map(lambda x: (int(x[0] * 255), int(x[1] * 255), int(x[2] * 255)), colors))

        random.seed(0)
        random.shuffle(colors)
        random.seed(None)
        out_boxes, out_scores, out_classes, num_boxes = bboxes

        for i in range(num_boxes):
            if int(out_classes[i]) < 0 or int(out_classes[i]) > num_classes: continue
            coor = out_boxes[i]
            fontScale = 0.5
            score = out_scores[i]
            class_ind = int(out_classes[i])
            class_name = classes[class_ind]
            if class_name not in classes:
                continue
            else:
                # to place the bounding box
                bbox_color = colors[class_ind]
                bbox_thick = int(0.6 * (image_h + image_w) / 600)
                c1, c2 = (coor[0], coor[1]), (coor[2], coor[3])
                cv2.rectangle(image, c1, c2, bbox_color, bbox_thick)

                # to show a text
                bbox_mess = '%s: %.2f' % (class_name, score)
                t_size = cv2.getTextSize(bbox_mess, 0, fontScale, thickness=bbox_thick // 2)[0]
                c3 = (c1[0] + t_size[0], c1[1] - t_size[1] - 3)
                cv2.rectangle(image, c1, (np.float32(c3[0]), np.float32(c3[1])), bbox_color, -1) 

                cv2.putText(image, bbox_mess, (c1[0], np.float32(c1[1] - 2)), cv2.FONT_HERSHEY_SIMPLEX,
                        fontScale, (0, 0, 0), bbox_thick // 2, lineType=cv2.LINE_AA)

        return image
