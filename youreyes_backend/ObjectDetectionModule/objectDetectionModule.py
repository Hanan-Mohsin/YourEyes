
import ObjectDetectionModule.objectDetectionModule as odm
import ObjectDetectionModule.preprocessor as pp
import ObjectDetectionModule.model as m
import ObjectDetectionModule.utils as u
from config.config import cfg

class ObjectDetectionModule():


    def __init__(self,imagePath,preprocessor,model, utils):
        self.imagePath = imagePath
        self.preprocessor = preprocessor
        self.model = model
        self.utils = utils
   
    
    def getFinalDetectionResult(self):
        self.preprocessor = pp.Preprocessor(self.imagePath)
        imagesData = self.preprocessor.preprocessImage()
        self.model = m.Model(imagesData)
        boxes, predConf = self.model.predict()
        self.utils = u.Utils(boxes, predConf,cfg.iou,cfg.score)
        boxess, scores, classes, valid_detections = self.utils.performNMS()

        pred_bbox = [boxess.numpy()[0], scores.numpy()[0], classes.numpy()[0], valid_detections.numpy()[0]]
        class_names = list(self.utils.readClassNames(cfg.YOLO.CLASSES).values())
        print(class_names)
        num_classes = len(class_names)
        result = []
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
                result.append([class_name,score,coor[0], coor[1], coor[2], coor[3]])
                print("Object found: {}, Confidence: {:.2f}, BBox Coords (ymin, xmin, ymax, xmax): {}, {}, {}, {} ".format(class_name, score, coor[0], coor[1], coor[2], coor[3]))
        return result


    