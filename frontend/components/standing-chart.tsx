"use client"

import { RankingItem } from "@/lib/utils"
import { Bar, BarChart, ResponsiveContainer, XAxis, YAxis, LabelList } from "recharts"

const data = [
    {
        name: "Jan",
        total: Math.floor(Math.random() * 5000) + 1000,
    },
    {
        name: "Feb",
        total: Math.floor(Math.random() * 5000) + 1000,
    },
    {
        name: "Mar",
        total: Math.floor(Math.random() * 5000) + 1000,
    },
]

export function StandingsChart({ winners }: { winners: RankingItem[] }) {
    const data = [
        {
            name: winners[1].name,
            total: winners[1].score
        },
        {
            name: winners[0].name,
            total: winners[0].score
        },
        {
            name: winners[2].name,
            total: winners[2].score
        },
    ]
    return (
        <ResponsiveContainer width="100%" height={350}>
            <BarChart data={data}>
                {/* <XAxis
                    dataKey="name"
                    stroke="#888888"
                    fontSize={12}
                    tickLine={false}
                    axisLine={false}
                /> */}
                <Bar
                    dataKey="total"
                    fill="currentColor"
                    radius={[4, 4, 0, 0]}
                    className="fill-primary"

                >
                    <LabelList dataKey="name" position="top"   />
                </Bar>
            </BarChart>
        </ResponsiveContainer>
    )
}