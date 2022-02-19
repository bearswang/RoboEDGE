import socket
from sys import argv
from time import sleep
from itertools import cycle
from Serialization import Serialization as ser
from params import *

import tensorflow as tf
import numpy as np
from tensorflow.keras.datasets import mnist
from sklearn import datasets

DBG=0

class SockCollector(object):
    def __init__(self, op_code):
        self.alg = op_code
        self.data = list()
        # self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.reconnect()
        # self.sock.connect( op_map[op_code] )
        pass

    def load_data(self):
        if self.alg=='svm':         #NOTE: load dataset for SVM jobs
            digits = datasets.load_digits()
            n_samples = len(digits.images)
            shaped_images = digits.images.reshape((n_samples, -1))
            return zip(shaped_images, digits.target) #FIXME: pick a random subset
        elif self.alg=='cnn':      #NOTE: load dataset for CNN jobs
            (x_train, y_train), (x_test, y_test) = mnist.load_data()
            x_train = np.reshape(x_train/255.0, (60000, 784))
            y_train = tf.keras.utils.to_categorical(y_train, 10)
            return zip(x_train, y_train)
        else:
            return -1
        pass

    def reconnect(self):
        print('Broken pipe! Reconnecting ...')
        # self.sock.close()
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

        _success_flag = 0
        while not _success_flag:
            try:
                self.sock.connect( op_map[self.alg] )
                _success_flag = 1
                print('Now on!')
            except Exception as e:
                print('Server Not Available! Reconnecting ...')
                sleep(1.0)
            pass
        pass

    def send(self, obj):
        _len, _buffer = ser.dump(obj)
        # _len = _len.to_bytes(length=2)
        packet = PKT_HEADER + _buffer
        _success_flag = 0

        while not _success_flag:
            try:
                self.sock.send(packet)
                _success_flag = 1
                if DBG: print('send once')
            except Exception as e:
                self.reconnect()
            pass
        pass

def main():
    if len(argv) < 2:
        print('No Dataset Specified!')
        exit()
    
    op_code = argv[1]
    try:
        sc = SockCollector(op_code)
        print('Now on!')
        dataset = sc.load_data()
        for sample in cycle(dataset):
            sc.send(sample)
            sleep(0.2) #TODO: sleep time could be arrival rate
            pass
    except Exception as e:
        print('No "%s" dataset available!'%argv[1])
        raise(e)
    pass

if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        print(e) #print(e)
    finally:
        exit()
