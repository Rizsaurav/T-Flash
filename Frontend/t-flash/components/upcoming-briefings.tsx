"use client"

import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import { ScrollArea } from "@/components/ui/scroll-area"
import { Switch } from "@/components/ui/switch"
import { Clock, Calendar, Settings } from "lucide-react"

const upcomingBriefings = [
  {
    id: "1",
    title: "Morning Briefing",
    date: "Today",
    time: "7:00 AM",
    type: "morning" as const,
    topics: ["Technology", "Business", "World"],
    enabled: true,
    recurring: "Daily",
  },
  {
    id: "2",
    title: "Evening Digest",
    date: "Today",
    time: "6:00 PM",
    type: "evening" as const,
    topics: ["Technology", "Science", "Health"],
    enabled: true,
    recurring: "Daily",
  },
  {
    id: "3",
    title: "Morning Briefing",
    date: "Tomorrow",
    time: "7:00 AM",
    type: "morning" as const,
    topics: ["Technology", "Business", "World"],
    enabled: true,
    recurring: "Daily",
  },
  {
    id: "4",
    title: "Afternoon Update",
    date: "Tomorrow",
    time: "2:00 PM",
    type: "afternoon" as const,
    topics: ["Politics", "Sports"],
    enabled: true,
    recurring: "Weekdays",
  },
  {
    id: "5",
    title: "Evening Digest",
    date: "Tomorrow",
    time: "6:00 PM",
    type: "evening" as const,
    topics: ["Technology", "Science", "Health"],
    enabled: true,
    recurring: "Daily",
  },
]

const typeColors = {
  morning: "bg-amber-500/10 text-amber-700 dark:text-amber-400 border-amber-500/20",
  afternoon: "bg-blue-500/10 text-blue-700 dark:text-blue-400 border-blue-500/20",
  evening: "bg-purple-500/10 text-purple-700 dark:text-purple-400 border-purple-500/20",
}

export function UpcomingBriefings() {
  return (
    <Card className="flex flex-col">
      <CardHeader>
        <CardTitle>Upcoming Briefings</CardTitle>
        <CardDescription>Your scheduled briefings for the next few days</CardDescription>
      </CardHeader>
      <CardContent className="flex-1">
        <ScrollArea className="h-[600px] pr-4">
          <div className="space-y-3">
            {upcomingBriefings.map((briefing) => (
              <div
                key={briefing.id}
                className="space-y-3 rounded-sm border-2 border-border bg-card p-4 transition-all hover:border-foreground"
              >
                <div className="flex items-start justify-between gap-2">
                  <div className="flex-1 space-y-2">
                    <div className="flex items-center gap-2">
                      <h4 className="font-semibold leading-none">{briefing.title}</h4>
                      <Badge variant="outline" className={typeColors[briefing.type]}>
                        {briefing.type}
                      </Badge>
                    </div>
                    <div className="flex flex-wrap items-center gap-3 text-sm text-muted-foreground">
                      <span className="flex items-center gap-1">
                        <Calendar className="size-3" />
                        {briefing.date}
                      </span>
                      <span className="flex items-center gap-1">
                        <Clock className="size-3" />
                        {briefing.time}
                      </span>
                    </div>
                  </div>
                  <Switch defaultChecked={briefing.enabled} />
                </div>

                <div className="flex flex-wrap gap-1.5">
                  {briefing.topics.map((topic) => (
                    <Badge key={topic} variant="secondary" className="text-xs">
                      {topic}
                    </Badge>
                  ))}
                </div>

                <div className="flex items-center justify-between border-t pt-3">
                  <span className="text-xs text-muted-foreground">Repeats: {briefing.recurring}</span>
                  <Button variant="ghost" size="sm" className="h-7 gap-1.5 text-xs">
                    <Settings className="size-3" />
                    Edit
                  </Button>
                </div>
              </div>
            ))}
          </div>
        </ScrollArea>
      </CardContent>
    </Card>
  )
}
