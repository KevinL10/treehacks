'use client';


import React, { useState } from 'react';
import { Button } from "@/components/ui/button";
import { PageState } from '@/lib/utils';

export default function StartPage({ setState, setRoomId }: { 
  setState: React.Dispatch<React.SetStateAction<PageState>>,
  setRoomId: React.Dispatch<React.SetStateAction<number>>,
 }) {

  return (<div className="flex justify-center items-center  h-[100vh]">
    <Button onClick={() => {
      setState(PageState.WAITING)
      setRoomId(Math.floor(99998+ Math.random() * 900000))
    }}>Create Room</Button>
  </div>)
}