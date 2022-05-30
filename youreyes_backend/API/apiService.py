import os
from flask import Flask, request, Response, jsonify, send_from_directory, abort
#from ObjectDetectionModule.objectDetectionModule import ObjectDetectionModule
#from ObjectDetectionModule.objectDetectionModule import ObjectDetectionModule
import ObjectDetectionModule.objectDetectionModule as odm
import DistanceModule.distanceModule as dm
import ObjectDetectionModule.preprocessor as pp
import ObjectDetectionModule.model as m
import ObjectDetectionModule.utils as u
from config.config import cfg
import API.apiService as aService
app = Flask(__name__)
class APIService:
   
    @app.route('/image', methods=['POST'])
    def uploadImage():
    
        image = request.files["image"]
    
        imageName = image.filename
        image.save(os.path.join(cfg.imagePath, imageName))
    
        #images = FLAGS.images
        imagePath = cfg.imagePath + imageName
        result = aService.APIService.getImage(imagePath)
        #print(result)
        os.remove(imagePath)
        try:
            print("sending")
            return jsonify(result), 200
        except FileNotFoundError:
            abort(404)
        #result FinalResult.returnResult(imagePath)
    
    def getImage(imagePath):
        print('getting image')
        preProcessor = pp.Preprocessor(imagePath)
        model = m.Model([])
        utils = u.Utils([],[],0,0)
        objectDetection = odm.ObjectDetectionModule(imagePath,preProcessor,model,utils)
        distanceEstimation = dm.DistanceModule()
        results = objectDetection.getFinalDetectionResult()
        detections = results['detections']
        for detection in detections:
            distance = distanceEstimation.calculateDistance(detection['class'],detection['BBoxes']['ymax'],detection['BBoxes']['ymin'])
            detection['distance'] = distance
        return {"image":results['image'],"detections":detections}
        return 
        #return FinalResult.returnResult(imagePath)
  

if __name__ == '__main__':
   

    print("started")
    app.run(debug=True,host='127.0.0.1')
    #app.run(debug=True,host='192.168.1.11')
