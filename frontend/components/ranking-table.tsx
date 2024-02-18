import { RankingItem } from '@/lib/utils';
import React, { useState } from 'react';


export default function RankingTable({ title, players }: { title: string, players: RankingItem[] }) {
  return (
    <div>
      <div className='text-xl tracking-tighter'>{title}</div>
      <div>
        {players.map((player, idx) => {
          return <div key={player.name}>{idx + 1}. {player.name} - {player.score.toFixed(2)}</div>
        })}
      </div>
    </div>
  )
}