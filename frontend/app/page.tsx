'use client';
import React, {useRef, useState, useEffect} from 'react';
import StartPage from "@/components/pages/start";
import { PageState } from "@/lib/utils";
import Image from "next/image";
import WaitingPage from '@/components/pages/waiting';
import PlayingPage from '@/components/pages/playing';


export default function Home() {
  const [state, setState] = useState<PageState>(PageState.START)
  const [roomId, setRoomId] = useState<number>(1)

  if (state === PageState.START) {
    return <StartPage setRoomId={setRoomId} setState={setState} />
  }

  if (state === PageState.WAITING) {
    return <WaitingPage roomId={roomId} setState={setState}/>
  }


  if (state === PageState.PLAYING) {
    return <PlayingPage roomId={roomId} setState={setState}/>
  }

  return <div>missing page</div>
}
