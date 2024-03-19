#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
To prepare for MintPy and maintain compatability for the outputs with GIS.
"""

"""Clip a bunch of geotiffs to the same area"""
import os
import glob
from osgeo import gdal

# list all image files
ls = glob.glob('/Volumes/dmk/InSAR/NewFreeport/2021east/hyp3/*/*.tif')
lt = [f for f in ls if '.rprj.' not in f]
ls = lt
del(lt)

# determine the largest area covered by all input files
corners = [gdal.Info(f, format='json')['cornerCoordinates'] for f in ls]
ulx = max(corner['upperLeft'][0] for corner in corners)
uly = min(corner['upperLeft'][1] for corner in corners)
lrx = min(corner['lowerRight'][0] for corner in corners)
lry = max(corner['lowerRight'][1] for corner in corners)

# identify the area of interest to clip.  This was done in QGIS atop one of the unwrapped images.
clip = "/Volumes/dmk/InSAR/NewFreeport/gis/aoi.shp"

# pixel size:
# QGIS: Warp, properties, information, resolution
# gdalinfo: take translated example (e.g., from below or QGIS) and look for pixel size.
dx = 0.0004297626000000000245
dy = -0.0004297626000000000245

# subset all image files to common outer coordinates
for f in ls:
    split = f.split(".")
    tout = split[0] + ".trns.tif"
    wout = split[0] + ".rprj.tif"
    gdal.Translate(destName = tout, srcDS = f, projWin = [ulx, uly, lrx, lry])
    gdal.Warp(wout, tout, srcSRS = 'EPSG:32617', dstSRS = 'EPSG:4326', xRes = dx, yRes = dy, cutlineDSName = clip, cropToCutline=True)
    os.remove(tout)
    print(str(split[0]))

