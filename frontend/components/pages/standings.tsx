import React, { useState, useEffect } from 'react';
import { Button } from '@/components/ui/button';
import { PageState, RankingItem } from '@/lib/utils';
import RankingTable from '../ranking-table';
import { StandingsChart } from '../standing-chart';


const player = { "name": "kevin", "score": 1234 }
export default function StandingsPage({ setState, roomId }: { setState: React.Dispatch<React.SetStateAction<PageState>>, roomId: number }) {
  
  const [players, setPlayers] = useState<RankingItem[]>([]);
  
  useEffect(() => {

    setTimeout(() => {setState(PageState.WAITING)}, 10 * 1000)

  }, [])
  
  
  useEffect(() => {
    // Define the async function
    const fetchData = async () => {
      try {
        const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/top/overall?room_id=${roomId}`);
        const data = await response.json();
        console.log(data.data);
        setPlayers(data.data)
        // Process your data here
      } catch (error) {
        console.error('There was an error fetching the data', error);
      }
    };
    
    fetchData();
  }, [])



  return (
    <div className='flex justify-center'>
      <div className='pt-16  w-[56rem]'>
        <div className="flex justify-center">
          <h1 className='text-3xl font-semibold tracking-tighter'>Standings</h1>
        </div>

        <div className='mt-8 flex justify-between'>
          <StandingsChart winners={players} />
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