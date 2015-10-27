# Control size and colour of labels when using the RgoogleMaps R-package

The functions PlotPolysOnStaticMap() offers the possibility to easily draw polygons on maps on GoogleMaps backgrounds ("roadmap", "mobile", "satellite", "terrain", "hybrid", "mapmaker-roadmap", "mapmaker-hybrid"). You just add the text of your label in textInPolys and it's done.  
**But** the text is printed by default in blue with a cex size parameters = 0.75 and no way to change it -a least I didn't find-!!  
I adapted PlotPolysOnStaticMap() function to allow changing the size and colour with two additional parameters: *cextext* and *coltext*. By default they take original size (cex=0.75) and colour (col='blue').  

Example:  
bb <- slot(My_SPDF_dataset,"bbox")  
MyMap <- GetMap.bbox(bb[1,], bb[2,], destfile ="tmp.png", maptype = "hybrid",size = c(640, 640))  
PlotPolysOnStaticMap2(MyMap,SpatialToPBS(COM$CLP)$xy ## See help about SpatialToPBS()  
                     ,col=rgb(0,0,0,0),border=rgb(0,0,1,0.3),lwd=5,lty=5  
                     ,textInPolys=My_SPDF_dataset$Labels  
                     ,coltext=rgb(0,0,1,0.3),cextext=2)  
