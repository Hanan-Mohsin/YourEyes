import os
from flask import Flask, request, Response, jsonify, send_from_directory, abort
#from ObjectDetectionModule.objectDetectionModule import ObjectDetectionModule
#from ObjectDetectionModule.objectDetectionModule import ObjectDetectionModule
import ObjectDetectionModule.objectDetectionModule as odm
import ObjectDetectionModule.preprocessor as pp
import ObjectDetectionModule.model as m
import ObjectDetectionModule.utils as u
import API.apiService as aService
app = Flask(__name__)
class APIService:
   
    @app.route('/image', methods=['POST'])
    def uploadImage():
    
        image = request.files["image"]
    
        imageName = image.filename
        image.save(os.path.join('C:\\Users\\User\\Documents\\Project_files\\YourEyes\\youreyes_backend\\data\\images', imageName))
    
        #images = FLAGS.images
        imagePath = 'C:\\Users\\User\\Documents\\Project_files\\YourEyes\\youreyes_backend\\data\\images\\'+imageName
        result = aService.APIService.getImage(imagePath)
        print(result)
        os.remove(imagePath)
        response = 'done'
        try:
            print("sending")
            return Response(response=response, status=200,mimetype="text/plain")
        except FileNotFoundError:
            abort(404)
        #result FinalResult.returnResult(imagePath)
    
    def getImage(imagePath):
        print('getting image')
        preProcessor = pp.Preprocessor(imagePath)
        model = m.Model([])
        utils = u.Utils([],[],0,0)
        objectDetection = odm.ObjectDetectionModule(imagePath,preProcessor,model,utils)
        return objectDetection.getFinalDetectionResult()
        #return FinalResult.returnResult(imagePath)
   

if __name__ == '__main__':
   
    # try:
    #     app.run(main)
    # except SystemExit:
    #     pass
    print("started")
    app.run(debug=True,host='127.0.0.1')
    #app.run(debug=True,host='192.168.1.6')