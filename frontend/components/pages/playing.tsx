import React, { useState, useEffect } from 'react';
import { Button } from '@/components/ui/button';
import { PageState, RankingItem } from '@/lib/utils';
import RankingTable from '../ranking-table';
import NowPlaying from '../spotify-card';

const players = [
  { name: "Kevin", score: 425 },
  { name: "Bartek", score: 234 }
]
export default function PlayingPage({ setState, roomId }: { setState: React.Dispatch<React.SetStateAction<PageState>>, roomId: number }) {
  const [users, setUsers] = useState<string[]>(["kevin", "bartek"])
  const [leaderboardOverall, setLeaderboardOverall] = useState<RankingItem[]>([])
  const [leaderboardCalories, setLeaderboardCalories] = useState<RankingItem[]>([])


  const fetchLeaderboard = async (category: string, setLeaderboard: React.Dispatch<React.SetStateAction<RankingItem[]>>) => {
    //category one of "overall" or "fitness"
    const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/top/${category}?room_id=${roomId}`)
    const data = await response.json()
    console.log(category, data)
    setLeaderboard(data.data)
  }

  useEffect(() => {
    const interval = 2000;
    fetchLeaderboard("overall", setLeaderboardOverall)
    fetchLeaderboard("calories", setLeaderboardCalories)

    const id = setInterval(() => {
      fetchLeaderboard("overall", setLeaderboardOverall)
      fetchLeaderboard("calories", setLeaderboardCalories)
    }, interval);

    // Cleanup function to clear the interval when the component unmounts
    return () => clearInterval(id);
  }, []); 


  return (
    <div className='flex justify-center'>
      <div className='pt-16  w-[56rem]'>
        <div className="flex justify-center">
          <h1 className='text-3xl font-semibold tracking-tighter'>Leaderboard</h1>
        </div>

        {/* <div className='mt-8'>
            <iframe style={{borderRadius: 12}} src="https://open.spotify.com/embed/track/5yVIlYEHZxQVLyInCdldoS?utm_source=generator" width="100%" height="352" frameBorder="0" allowFullScreen={false} allow="autoplay; clipboard-write; encrypted-media; fullscreen; picture-in-picture" loading="lazy"></iframe>
        </div> */}
        <div className='mt-8'>
          <NowPlaying roomId={roomId} setState={setState}/>
        </div>
        <div className='mt-8 flex justify-between'>
          <RankingTable title="Top Overall" players={leaderboardOverall} />
          <RankingTable title="Top Calories Burned" players={leaderboardCalories} />
          <RankingTable title="Top Steps Taken" players={leaderboardOverall} />
        </div>
      </div>
    </div>
  )
}
