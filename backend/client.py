import websockets
import asyncio
import json
from random import randint
import time

async def main():
    name = input("name: ")
    room = int(input("room_id: "))

    uri = "ws://localhost:8000/ws"
    async with websockets.connect(uri) as websocket:
        await websocket.send(json.dumps({"method": "join_room", "params": {"room_id": room, "name": name}}))
        
        # check waiting response
        data = await websocket.recv()
        data = json.loads(data)
        assert data["method"] == "update_status"
        assert data["params"]["status"] == "waiting"
        print("Joined room")

        # wait until room starts 
        data = await websocket.recv()
        data = json.loads(data)
        assert data["method"] == "update_status"
        assert data["params"]["status"] == "starting"
        print("Started room")




        while True:
            mock_data = {"heartrate": randint(60, 180), "step_count": randint(0, 200)}
            await websocket.send(json.dumps({"method": "submit_data", "params": mock_data}))

            time.sleep(5)

'''
start room: `curl -X POST -H "Content-Type: application/json" -d '{"room_id": 123456}' localhost:8000/start`

get data: `curl http://localhost:8000/data?room_id=123456`

'''


if __name__ == "__main__":
    asyncio.get_event_loop().run_until_complete(main())
    # asyncio.run(send_message)