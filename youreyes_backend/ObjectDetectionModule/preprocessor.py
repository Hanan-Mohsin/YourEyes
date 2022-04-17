import cv2
import numpy as np

class Preprocessor():

    def __init__(self,imagePath):
        self.imagePath = imagePath
    

    def preprocessImage(self):
        print('[INFO] Preprocessing image')
        input_size = 416
        image_path = self.imagePath
      #  for count, image_path in enumerate(images, 1):
        original_image = cv2.imread(image_path)
        original_image = cv2.cvtColor(original_image, cv2.COLOR_BGR2RGB)

        image_data = cv2.resize(original_image, (input_size, input_size))
        image_data = image_data / 255.
        
        # get image name by using split method
        image_name = image_path.split('/')[-1]
        image_name = image_name.split('.')[0]

        images_data = []
        images_data.append(image_data)
        images_data = np.asarray(images_data).astype(np.float32)
      
       
        return images_data,original_image,image_name
