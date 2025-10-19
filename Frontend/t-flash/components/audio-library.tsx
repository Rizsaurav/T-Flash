"use client"

import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"
import { Button } from "@/components/ui/button"
import { Badge } from "@/components/ui/badge"
import { ScrollArea } from "@/components/ui/scroll-area"
import { Play, Clock, Calendar, Plus } from "lucide-react"
import { useAudio } from "@/lib/audio-context"

const briefings = [
  {
    id: "1",
    title: "Morning Briefing",
    date: "Today, 7:00 AM",
    duration: 754,
    topics: ["Technology", "Business", "World"],
    status: "new",
  },
  {
    id: "2",
    title: "Afternoon Update",
    date: "Today, 2:00 PM",
    duration: 525,
    topics: ["Politics", "Sports"],
    status: "scheduled",
  },
  {
    id: "3",
    title: "Evening Digest",
    date: "Yesterday, 6:00 PM",
    duration: 922,
    topics: ["Technology", "Science", "Health"],
    status: "played",
  },
  {
    id: "4",
    title: "Morning Briefing",
    date: "Yesterday, 7:00 AM",
    duration: 678,
    topics: ["Business", "World"],
    status: "played",
  },
]

const playlists = [
  { id: "p1", name: "Tech Deep Dive", count: 12, duration: "2h 34m" },
  { id: "p2", name: "Weekly Highlights", count: 7, duration: "1h 15m" },
  { id: "p3", name: "Favorites", count: 24, duration: "4h 52m" },
]

export function AudioLibrary() {
  const { play, addToQueue, currentTrack } = useAudio()

  const handlePlay = (briefing: (typeof briefings)[0]) => {
    play({
      id: briefing.id,
      title: briefing.title,
      date: briefing.date,
      duration: briefing.duration,
      topics: briefing.topics,
    })
  }

  const handleAddToQueue = (briefing: (typeof briefings)[0]) => {
    addToQueue({
      id: briefing.id,
      title: briefing.title,
      date: briefing.date,
      duration: briefing.duration,
      topics: briefing.topics,
    })
  }

  return (
    <Card className="flex flex-col">
      <CardHeader>
        <CardTitle>Your Audio Library</CardTitle>
        <CardDescription>Browse your personalized news briefings and playlists</CardDescription>
      </CardHeader>
      <CardContent className="flex-1">
        <Tabs defaultValue="briefings" className="h-full">
          <TabsList>
            <TabsTrigger value="briefings">Briefings</TabsTrigger>
            <TabsTrigger value="playlists">Playlists</TabsTrigger>
          </TabsList>
          <TabsContent value="briefings" className="mt-4">
            <ScrollArea className="h-[500px] pr-4">
              <div className="space-y-3">
                {briefings.map((briefing) => (
                  <div
                    key={briefing.id}
                    className="group flex items-start gap-4 rounded-sm border-2 border-border bg-card p-4 transition-all hover:border-foreground"
                    data-active={currentTrack?.id === briefing.id}
                  >
                    <Button
                      size="icon"
                      variant="outline"
                      className="mt-1 shrink-0 border-2 transition-all group-hover:border-foreground group-hover:bg-foreground group-hover:text-background group-data-[active=true]:border-foreground group-data-[active=true]:bg-foreground group-data-[active=true]:text-background bg-transparent"
                      onClick={() => handlePlay(briefing)}
                    >
                      <Play className="size-4" />
                    </Button>
                    <div className="flex-1 space-y-2">
                      <div className="flex items-start justify-between gap-2">
                        <div>
                          <h3 className="font-semibold leading-none">{briefing.title}</h3>
                          <div className="mt-1.5 flex items-center gap-3 text-sm text-muted-foreground">
                            <span className="flex items-center gap-1">
                              <Calendar className="size-3" />
                              {briefing.date}
                            </span>
                            <span className="flex items-center gap-1">
                              <Clock className="size-3" />
                              {Math.floor(briefing.duration / 60)}:
                              {(briefing.duration % 60).toString().padStart(2, "0")}
                            </span>
                          </div>
                        </div>
                        <div className="flex items-center gap-2">
                          {briefing.status === "new" && (
                            <Badge variant="default" className="shrink-0">
                              New
                            </Badge>
                          )}
                          {briefing.status === "scheduled" && (
                            <Badge variant="outline" className="shrink-0">
                              Scheduled
                            </Badge>
                          )}
                          <Button
                            size="icon"
                            variant="ghost"
                            className="size-8 shrink-0"
                            onClick={() => handleAddToQueue(briefing)}
                          >
                            <Plus className="size-4" />
                          </Button>
                        </div>
                      </div>
                      <div className="flex flex-wrap gap-1.5">
                        {briefing.topics.map((topic) => (
                          <Badge key={topic} variant="secondary" className="text-xs">
                            {topic}
                          </Badge>
                        ))}
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            </ScrollArea>
          </TabsContent>
          <TabsContent value="playlists" className="mt-4">
            <ScrollArea className="h-[500px] pr-4">
              <div className="space-y-3">
                {playlists.map((playlist) => (
                  <div
                    key={playlist.id}
                    className="group flex items-center justify-between rounded-sm border-2 border-border bg-card p-4 transition-all hover:border-foreground"
                  >
                    <div className="flex items-center gap-4">
                      <Button
                        size="icon"
                        variant="outline"
                        className="shrink-0 border-2 transition-all group-hover:border-foreground group-hover:bg-foreground group-hover:text-background bg-transparent"
                      >
                        <Play className="size-4" />
                      </Button>
                      <div>
                        <h3 className="font-semibold leading-none">{playlist.name}</h3>
                        <p className="mt-1.5 text-sm text-muted-foreground">
                          {playlist.count} episodes • {playlist.duration}
                        </p>
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            </ScrollArea>
          </TabsContent>
        </Tabs>
      </CardContent>
    </Card>
  )
}
