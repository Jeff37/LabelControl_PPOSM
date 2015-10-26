## A version of function PlotPolysOnStaticMap {RgoogleMaps} which allows to control color and size of labels with 2 new parameters coltext and cextext
## Defaults of these parameters are the defaults from the original function of RgoogleMpas package

PlotPolysOnStaticMap2 <-  function (MyMap, polys, col, border = NULL, lwd = 0.25, verbose = 0, 
          add = TRUE, textInPolys = NULL, coltext="blue",cextext=0.75, ...) 
{
  stopifnot(class(polys)[1] == "SpatialPolygons" | class(polys)[1] == 
              "PolySet" | class(polys)[1] == "data.frame" | class(polys)[1] == 
              "matrix")
  if (class(polys)[1] == "SpatialPolygons") 
    polys = SpatialToPBS(polys)$xy
  Rcoords <- LatLon2XY.centered(MyMap, lat = polys[, "Y"], 
                                lon = polys[, "X"])
  polys.XY <- as.data.frame(polys)
  polys.XY[, "X"] <- Rcoords$newX
  polys.XY[, "Y"] <- Rcoords$newY
  if (!("PID" %in% colnames(polys.XY))) 
    polys.XY[, "PID"] <- 1
  if (!("SID" %in% colnames(polys.XY))) 
    polys.XY[, "SID"] <- 1
  polys.XY[, "PIDSID"] <- apply(polys.XY[, c("PID", "SID")], 
                                1, paste, collapse = ":")
  if (!add) 
    tmp <- PlotOnStaticMap(MyMap, verbose = 0, ...)
  if (verbose > 1) 
    browser()
  if (!is.null(textInPolys)) 
    Centers = PBSmapping::calcCentroid(polys.XY)
  if (requireNamespace("PBSmapping", quietly = TRUE) & all(c("PID", 
                                                             "X", "Y", "POS") %in% colnames(polys.XY))) {
    attr(polys.XY, "projection") <- NULL
    usr <- par("usr")
    PBSmapping::addPolys(polys.XY, col = col, border = border, 
                         lwd = lwd, xlim = usr[1:2], ylim = usr[3:4], ...)
    if (!is.null(textInPolys)) {
      text(Centers[, "X"], Centers[, "Y"], textInPolys, 
           cex = cextext, col = coltext)
    }
  }
  else {
    if (!missing(col)) {
      polys.XY[, "col"] <- col
      PIDtable <- as.numeric(table(polys.XY[, "PID"]))
      SIDtable <- as.numeric(table(polys.XY[, "PIDSID"]))
      if (length(SIDtable) == length(col)) 
        polys.XY[, "col"] <- rep(col, SIDtable)
      if (length(PIDtable) == length(col)) 
        polys.XY[, "col"] <- rep(col, PIDtable)
    }
    if (!("col" %in% colnames(polys.XY))) 
      polys.XY[, "col"] <- rgb(0.1, 0.1, 0.1, 0.05)
    pids = unique(polys.XY[, "PIDSID"])
    for (i in pids) {
      jj = polys.XY[, "PIDSID"] == i
      xx = polys.XY[jj, ]
      if (("POS" %in% colnames(xx))) 
        xx <- xx[order(xx[, "POS"]), ]
      polygon(xx[, c("X", "Y")], col = xx[, "col"])
      if (!is.null(textInPolys)) {
        text(Centers[i, "X"], Centers[i, "Y"], textInPolys[i], 
             col = coltext)
      }
    }
  }
}