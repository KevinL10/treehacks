import socketio
from aiohttp import web

sio = socketio.AsyncServer()
app = web.Application()
sio.attach(app)

'''

join_room (sid, room_id): joins a given room   

data (sid, data): sends an update on data 

'''

@sio.event
async def connect(sid, environ):
    print("Client connected:", sid)
    await sio.emit('message', 'Welcome to the Socket.IO server!', room=sid)

@sio.event
async def chat_message(sid, data):
    print("Message from", sid, ":", data)
    # Echo the message back to the client
    await sio.emit('chat_message', data, room=sid)

@sio.event 
def join_room
@sio.event
def disconnect(sid):
    print("Client disconnected", sid)

if __name__ == '__main__':
    web.run_app(app, port=5000)
