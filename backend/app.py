import socketio
from typing import Dict
from collections import defaultdict
import time
import logging

'''

join_room (sid, room_id): joins a given room   

data (sid, data): sends an update on data 
'''

sio = socketio.Server()
app = socketio.WSGIApp(sio)

user_data = defaultdict(list) 


logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("app")

@sio.event
def connect(sid, environ):
    logger.info("Client connected:" + sid)
    print("Client connected:", sid)
    sio.emit('response', 'Connected to server', room=sid)


@sio.event 
def submit_data(sid, data: Dict):
    print(f"User {sid} uploaded data: {data}")
    user_data[sid].append(data)

@sio.event
def join_room(sid, room_id):
    print(f"User {sid} has joined room {room_id}")
    sio.enter_room(sid, room_id)

    # simulate time until room starts
    # time.sleep(10)
    # sio.emit('status', "STARTED")

@sio.event
def disconnect(sid):
    print("User disconnected", sid)

if __name__ == '__main__':
    import eventlet
    eventlet.wsgi.server(eventlet.listen(('', 8000)), app)

