# -*- coding: utf-8 -*-
"""
Created on Mon Feb 18 16:38:06 2019

@author: SPAD-FCS
"""

from u64ToCounts import u64ToCounts
from operator import add
from PhotonClass import Photon
import math

def analyzeFCSData(fname):
    countArray = []
    counts = [0] * 25
    with open(fname) as f:
        lineNr = 0
        for line_terminated in f:
            if lineNr % 1000000 == 0:
                print(lineNr)
            line = int(line_terminated.rstrip('\n'))
            count = u64ToCounts(line)
            if sum(count) > 0:
                for i in range(len(count)):
                    detElCounts = count[i]
                    for j in range(detElCounts):
                        arrivalTime = math.floor(lineNr / 2)
                        detEl = i
                        p = Photon(arrivalTime, detEl)
                        countArray.append(p)
                counts = list(map(add, counts, count))
            lineNr += 1
    return counts, countArray
            
counts, countArray = analyzeFCSData(fname)