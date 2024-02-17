'use client';
import React, {useState} from 'react';
import StartPage from "@/components/pages/start";
import { PageState } from "@/lib/utils";
import Image from "next/image";
import WaitingPage from '@/components/pages/waiting';
import PlayingPage from '@/components/pages/playing';


export default function Home() {
  const [state, setState] = useState<PageState>(PageState.PLAYING)
  
  
  if (state === PageState.START) {
    return <StartPage setState={setState} />
  }

  if (state === PageState.WAITING) {
    return <WaitingPage setState={setState}/>
  }


  if (state === PageState.PLAYING) {
    return <PlayingPage setState={setState}/>
  }

  return <div>missing page</div>
}
