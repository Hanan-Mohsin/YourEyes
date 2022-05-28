class DistanceModule():

    def calculateDistance(self,name,ymax,ymin):

         #distance = round (((1 - (float(xmax) - float(xmin)))**4),1)
         if(name == "hole"):
         	#distance = 0.0198/(float(ymax)-float(ymin))
	distance = 0.0216/(float(ymax)-float(ymin))
         else if(name == "sewage opening"):
	distance = 0.3/(float(ymax)-float(ymin))
         else:
         	#distance = 0.323/(float(ymax)-float(ymin))
	distance = 0.4534/(float(ymax)-float(ymin))
         return str(distance)