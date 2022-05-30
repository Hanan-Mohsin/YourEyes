#! /usr/bin/env python
# coding=utf-8
from easydict import EasyDict as edict


__C                           = edict()


cfg                           = __C


__C.YOLO                      = edict()

__C.YOLO.CLASSES              = "../data/classes/obj.names"
__C.YOLO.STRIDES              = [8, 16, 32]
__C.YOLO.XYSCALE              = [1.2, 1.1, 1.05]
__C.YOLO.ANCHOR_PER_SCALE     = 3
__C.YOLO.IOU_LOSS_THRESH      = 0.5
__C.WEIGHT                    = '../checkpoints/custom-416'
__C.iou                       = 0.45
__C.score                     = 0.50




