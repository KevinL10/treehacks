'use client';


import React, { useState } from 'react';
import { Button } from "@/components/ui/button";
import { PageState } from '@/lib/utils';

export default function StartPage({ setState }: { setState: React.Dispatch<React.SetStateAction<PageState>> }) {

  return (<div className="flex justify-center items-center  h-[100vh]">
    <Button onClick={() => setState(PageState.WAITING)}>Create Room</Button>
  </div>)
}