import socketio
import time

sio = socketio.Client()

@sio.event
def connect():
    print('Connected to server')

@sio.event
def response(message):
    print('Message from server:', message)

@sio.event
def disconnect():
    print('Disconnected from server')

sio.connect('http://localhost:8000')
sio.emit('join_room', 1234)
sio.emit('submit_data', {"heart_rate": 60})

time.sleep(5)