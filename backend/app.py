from fastapi import FastAPI, WebSocket, Request
from fastapi.responses import HTMLResponse, JSONResponse, PlainTextResponse
from fastapi.middleware.cors import CORSMiddleware
from collections import defaultdict
from uuid import uuid4
from typing import List, Dict   
import asyncio
import time

app = FastAPI()

origins = [
    "http://localhost:3000",
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# room_id: list of names in the room
# note: names server as unique identifiers; two players must not have the same name
room_users = defaultdict(list)

# room_id: event
room_started_event: Dict[int, asyncio.Event] = {}


# maps from room_id: {name: [(heart_rate, step, time)]}
user_health_data = defaultdict(lambda: defaultdict(list))

def compute_score(measurements):
    avg_heart_rate = sum([m[0] for m in measurements]) / len(measurements)
    return avg_heart_rate * 5


@app.get("/users")
async def get_room_data(room_id: int = -1):
    return JSONResponse({"data": room_users[room_id]})


@app.get("/")
async def index():
    return JSONResponse({"status": "ok"})


@app.post("/start")
async def start_room(request: Request):
    data = await request.json()
    room_id = data["room_id"]
    room_started_event[room_id].set()
    return JSONResponse({"status": "ok", "room_id": room_id})


@app.get("/top/overall")
async def get_top_overall(room_id: int = -1):
    # (name, score)
    items = [(user, compute_score(measurements)) for user, measurements in user_health_data[room_id].items()]
    ranked_results = [{"name": item[0], "score": item[1]} for item in sorted(items, key=lambda k: -k[1])]
    return JSONResponse({"data": ranked_results})



@app.get("/data")
async def get_room_data(room_id: int = -1):
    return JSONResponse({"data": user_health_data[room_id]})


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