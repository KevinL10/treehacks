import { type ClassValue, clsx } from "clsx"
import { twMerge } from "tailwind-merge"

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}

export enum PageState {
  START = "START",
  WAITING = "WAITING",
  PLAYING = "PLAYING",
  STANDINGS = "STANDINGS"
}


export interface RankingItem {
    name: string
    score: number
}