import struct
import pickle

class Serialization(object):

    def __init__(self):
        pass

    @staticmethod
    def dump(_tuple):
        x_ser = pickle.dumps(_tuple[0], protocol=0)
        y_ser = pickle.dumps(_tuple[1], protocol=0)
        _ser = x_ser + b'SUSTech' + y_ser
        return (len(_ser), _ser)

    @staticmethod
    def restore(_ser):
        (x_ser,y_ser) = _ser.split(b'SUSTech')
        x_ser = pickle.loads(x_ser)
        y_ser = pickle.loads(y_ser)
        return (x_ser, y_ser)

    pass
