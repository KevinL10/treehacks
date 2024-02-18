'use client'
import React, { useEffect, useState } from 'react';
import { Button } from '@/components/ui/button';
import { PageState } from '@/lib/utils';
import { setSourceMapsEnabled } from 'process';


export default function WaitingPage({ setState, roomId }: {
  setState: React.Dispatch<React.SetStateAction<PageState>>,
  roomId: number,
}) {
  const [users, setUsers] = useState<string[]>([])
  
  

  const fetchWaitingUsers = async () => {
    const response = await fetch(`http://localhost:8000/users?room_id=${roomId}`)
    const data = await response.json()
    setUsers(data.data)
  }

  useEffect(() => {
    const interval = 2000;
    fetchWaitingUsers(); // Initial fetch

    const id = setInterval(() => {
      fetchWaitingUsers();
    }, interval);

    // Cleanup function to clear the interval when the component unmounts
    return () => clearInterval(id);
  }, []); 


  async function handleStartRoom(){
    const response = await fetch(`http://localhost:8000/start`, {
      method: "POST",
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({"room_id": roomId})
    })
    const data = await response.json()
    
    console.log("started room response: ", data)
    setState(PageState.PLAYING)
  }

  return (
    <div className='flex justify-center'>
      <div className='pt-16 max-w-4xl'>
        <div className="flex justify-center">
          <h1 className='text-3xl font-semibold tracking-tighter'>Room Code: {roomId}</h1>
        </div>

        <div className='mt-8 flex justify-center'>
          <Button onClick={handleStartRoom}>Start Room</Button></div>
        <div className='mt-8 grid grid-cols-8 gap-4'>
          {users.map(user => {
            return <div key={user}>{user}</div>
          })
          }
        </div>
      </div>
    </div>
  )
}