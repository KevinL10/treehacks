import React, { useState, useEffect } from 'react';
import { Button } from '@/components/ui/button';
import { PageState, RankingItem } from '@/lib/utils';
import RankingTable from '../ranking-table';
import { StandingsChart } from '../standing-chart';


const player = { "name": "kevin", "score": 1234 }
export default function StandingsPage({ setState, roomId }: { setState: React.Dispatch<React.SetStateAction<PageState>>, roomId: number }) {
  return (
    <div className='flex justify-center'>
      <div className='pt-16  w-[56rem]'>
        <div className="flex justify-center">
          <h1 className='text-3xl font-semibold tracking-tighter'>Standings</h1>
        </div>

        <div className='mt-8 flex justify-between'>
          <StandingsChart winners={[player, player, player]} />
          {/* <RankingTable title="Top Overall" players={leaderboardOverall} />
          <RankingTable title="Top Calories Burned" players={leaderboardCalories} />
          <RankingTable title="Top Steps Taken" players={leaderboardOverall} /> */}
        </div>
        <div className='mt-16 flex justify-center'>
          <h3>Next song: <i>Blank Space</i> by <i>Taylor Swift</i></h3>
        </div>
      </div>
    </div>
  )
}