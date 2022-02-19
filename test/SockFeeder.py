import socket
from time import sleep
from Serialization import Serialization as ser
from params import *

class SockFeeder(object):

    def __init__(self, alg_name):
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.alg = alg_name
        self.sock.bind(('', op_map[alg_name][1]))
        self.sock.listen(1)
        pass

    def connect(self):
        print('Waiting for connection ...')
        self.c_sock, self.c_addr = self.sock.accept()
        self.c_sock.settimeout(3.0)
        self.buffer = b''
        print('Connected: {}.'.format(self.c_addr))
        return self.c_sock

    def reconnect(self):
        try:
            print('Broken pipe! Reconnecting ...')
            self.c_sock.close()
        finally:
            self.c_sock, self.c_addr = self.sock.accept()
            self.c_sock.settimeout(3.0)
            self.buffer = b''
            print('Connected: {}.'.format(self.c_addr))
        pass

    def recv(self, buf_size=2048):
        _success_flag, recv_buffer = 0, b''
        while not _success_flag:
            try:
                recv_buffer = self.c_sock.recv(buf_size)
                if len(recv_buffer) == 0:
                    raise Exception()
                _success_flag = 1
            except Exception as e:
                self.reconnect()
            pass
        return recv_buffer

    def sync(self):
        _idx = self.buffer.find(PKT_HEADER)
        while _idx < 0:
            self.buffer += self.recv(2048)
            _idx = self.buffer.find(PKT_HEADER)
            pass
        return _idx

    def get(self, num=1):
        results, _collected, _brokens = list(), 0, 0

        # Synchronization and Appending
        sync_idx = self.sync()
        while _collected < num:
            self.buffer = self.buffer[sync_idx + len(PKT_HEADER):]
            sync_idx = self.sync()
            try:
                _sample = ser.restore(self.buffer[:sync_idx])
                results.append(_sample)
                _collected += 1
            except Exception as e:
                _brokens   += 1
            pass

        return _brokens, results

    pass