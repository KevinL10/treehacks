'use client';


import React, { useState } from 'react';
import { Button } from "@/components/ui/button";
import { PageState } from '@/lib/utils';

export default function StartPage({ setState, setRoomId }: { 
  setState: React.Dispatch<React.SetStateAction<PageState>>,
  setRoomId: React.Dispatch<React.SetStateAction<number>>,
 }) {

  return (
  <div>
    <div className='flex justify-center mt-16'>
      <h1 className='text-3xl font-semibold tracking-tighter'>Pulse Party</h1>
    </div>
    <div className="flex justify-center items-center  h-[60vh]">
      <Button onClick={() => {
        setState(PageState.WAITING)
        setRoomId(Math.floor(1000+ Math.random() * 9000))
      }}>Create Room</Button>
    </div>
  </div>)
}