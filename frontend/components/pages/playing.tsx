import React, { useState } from 'react';
import { Button } from '@/components/ui/button';
import { PageState } from '@/lib/utils';
import RankingTable from '../ranking-table';

const players = [
  { name: "Kevin", score: 425 },
  { name: "Bartek", score: 234 }
]
export default function PlayingPage({ setState }: { setState: React.Dispatch<React.SetStateAction<PageState>> }) {
  const [users, setUsers] = useState<string[]>(["kevin", "bartek"])

  return (
    <div className='flex justify-center'>
      <div className='pt-16  w-[56rem]'>
        <div className="flex justify-center">
          <h1 className='text-3xl font-semibold tracking-tighter'>Leaderboard</h1>
        </div>

        <div className='mt-8 flex justify-between'>
          <RankingTable title="Top Dancers" players={players} />
          <RankingTable title="Most Calories Burned" players={players} />
        </div>
      </div>
    </div>
  )
}
