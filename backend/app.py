from fastapi import FastAPI, WebSocket, Request
from fastapi.responses import HTMLResponse, JSONResponse, PlainTextResponse
from collections import defaultdict
from uuid import uuid4
from typing import List, Dict   
import asyncio
import time

app = FastAPI()

# room_id: list of names in the room
# note: names server as unique identifiers; two players must not have the same name
room_users = defaultdict(list)

# room_id: event
room_started_event: Dict[int, asyncio.Event] = {}



# maps from room_id: {name: [(health, step, time)]}
user_health_data = defaultdict(lambda: defaultdict(list))


@app.get("/")
async def index():
    return JSONResponse({"status": "ok"})


@app.post("/start")
async def start_room(request: Request):
    data = await request.json()
    room_id = data["room_id"]
    room_started_event[room_id].set()
    return JSONResponse({"status": "ok"})


@app.get("/data")
async def get_room_data(room_id: int = -1):
    print(user_health_data[room_id])
    return JSONResponse(user_health_data[room_id])


@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()

    # join room with room_id and name
    data = await websocket.receive_json()
    assert data["method"] == "join_room"
    
    room_id = data["params"]["room_id"]
    name = data["params"]["name"]
    room_users[room_id].append(name)

    await websocket.send_json({"method": "update_status", "params": {"status": "waiting"}})

    # wait for game to be started
    game_started = asyncio.Event()
    room_started_event[room_id] = game_started 
    await game_started.wait()
    
    await websocket.send_json({"method": "update_status", "params": {"status": "starting"}})
    
    # receive data from watch repeatedly
    # TODO: stop when the song finishes
    while True:
        data = await websocket.receive_json()
        assert data["method"] == "submit_data"

        heartrate = data["params"]["heartrate"]
        step_count = data["params"]["step_count"]
        timestamp = int(time.time())

        print(data)
        user_health_data[room_id][name].append((heartrate, step_count, timestamp))



'''

accept() name

send() ok


send() start

while ...
accept() data

send() done




'''