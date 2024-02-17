import React, { useState } from 'react';
import { Button } from '@/components/ui/button';
import { PageState } from '@/lib/utils';

export default function WaitingPage({ setState }: { setState: React.Dispatch<React.SetStateAction<PageState>> }) {
  const [users, setUsers] = useState<string[]>(["kevin", "bartek"])

  return (
    <div className='flex justify-center'>
      <div className='pt-16 max-w-4xl'>
        <div className="flex justify-center">
          <h1 className='text-3xl font-semibold tracking-tighter'>Room Code: 123456</h1>
        </div>

        <div className='mt-8 flex justify-center'>
          <Button onClick={() => setState(PageState.PLAYING)}>Start Room</Button></div>
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