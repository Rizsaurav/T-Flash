"use client"

import { useAudio } from "@/lib/audio-context"
import { Button } from "@/components/ui/button"
import { Slider } from "@/components/ui/slider"
import { Badge } from "@/components/ui/badge"
import { Play, Pause, SkipBack, SkipForward, Volume2, VolumeX, List } from "lucide-react"
import { Sheet, SheetContent, SheetDescription, SheetHeader, SheetTitle, SheetTrigger } from "@/components/ui/sheet"
import { ScrollArea } from "@/components/ui/scroll-area"
import { formatTime } from "@/lib/utils"

export function AudioPlayerBar() {
  const {
    currentTrack,
    isPlaying,
    currentTime,
    duration,
    volume,
    queue,
    togglePlayPause,
    seek,
    setVolume,
    skipForward,
    skipBackward,
    removeFromQueue,
  } = useAudio()

  if (!currentTrack) return null

  const progress = duration > 0 ? (currentTime / duration) * 100 : 0

  return (
    <div className="fixed bottom-0 left-0 right-0 z-50 border-t bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/80">
      <div className="container mx-auto px-4 py-3">
        {/* Progress Bar */}
        <div className="mb-3">
          <Slider
            value={[progress]}
            onValueChange={([value]) => {
              const newTime = (value / 100) * duration
              seek(newTime)
            }}
            max={100}
            step={0.1}
            className="w-full"
          />
          <div className="mt-1 flex justify-between text-xs text-muted-foreground">
            <span>{formatTime(currentTime)}</span>
            <span>{formatTime(duration)}</span>
          </div>
        </div>

        <div className="flex items-center gap-4">
          {/* Track Info */}
          <div className="flex min-w-0 flex-1 items-center gap-3">
            <div className="flex size-12 shrink-0 items-center justify-center rounded-sm border-2 border-foreground bg-gradient-to-br from-primary/20 to-accent/20">
              <div className="flex items-end gap-0.5">
                {Array.from({ length: 4 }).map((_, i) => (
                  <div
                    key={i}
                    className="w-1 bg-foreground"
                    style={{
                      height: `${Math.random() * 60 + 40}%`,
                      animation: isPlaying ? `pulse ${Math.random() * 0.5 + 0.5}s ease-in-out infinite` : "none",
                    }}
                  />
                ))}
              </div>
            </div>
            <div className="min-w-0 flex-1">
              <h4 className="truncate font-semibold leading-none">{currentTrack.title}</h4>
              <div className="mt-1.5 flex flex-wrap gap-1">
                {currentTrack.topics.slice(0, 3).map((topic) => (
                  <Badge key={topic} variant="secondary" className="text-xs">
                    {topic}
                  </Badge>
                ))}
              </div>
            </div>
          </div>

          {/* Playback Controls */}
          <div className="flex items-center gap-1">
            <Button size="icon" variant="ghost" onClick={skipBackward} className="hidden sm:flex">
              <SkipBack className="size-4" />
            </Button>
            <Button size="icon" className="size-10 border-2 border-foreground" onClick={togglePlayPause}>
              {isPlaying ? <Pause className="size-5" /> : <Play className="size-5" />}
            </Button>
            <Button size="icon" variant="ghost" onClick={skipForward} className="hidden sm:flex">
              <SkipForward className="size-4" />
            </Button>
          </div>

          {/* Volume & Queue */}
          <div className="flex items-center gap-2">
            <div className="hidden items-center gap-2 md:flex">
              <Button size="icon" variant="ghost" className="size-8" onClick={() => setVolume(volume > 0 ? 0 : 0.7)}>
                {volume === 0 ? <VolumeX className="size-4" /> : <Volume2 className="size-4" />}
              </Button>
              <Slider
                value={[volume * 100]}
                onValueChange={([value]) => setVolume(value / 100)}
                max={100}
                step={1}
                className="w-24"
              />
            </div>

            <Sheet>
              <SheetTrigger asChild>
                <Button size="icon" variant="ghost" className="relative size-8">
                  <List className="size-4" />
                  {queue.length > 0 && (
                    <span className="absolute -top-1 -right-1 flex size-4 items-center justify-center rounded-full bg-primary text-[10px] font-bold text-primary-foreground">
                      {queue.length}
                    </span>
                  )}
                </Button>
              </SheetTrigger>
              <SheetContent>
                <SheetHeader>
                  <SheetTitle>Queue</SheetTitle>
                  <SheetDescription>
                    {queue.length === 0 ? "No items in queue" : `${queue.length} items in queue`}
                  </SheetDescription>
                </SheetHeader>
                <ScrollArea className="mt-4 h-[calc(100vh-120px)]">
                  <div className="space-y-2">
                    {queue.map((track, index) => (
                      <div
                        key={track.id}
                        className="flex items-start gap-3 rounded-sm border-2 border-border bg-card p-3 transition-all hover:border-foreground"
                      >
                        <span className="mt-1 text-sm font-semibold text-muted-foreground">{index + 1}</span>
                        <div className="flex-1">
                          <h4 className="font-semibold leading-none">{track.title}</h4>
                          <p className="mt-1 text-sm text-muted-foreground">{track.date}</p>
                        </div>
                        <Button
                          size="icon"
                          variant="ghost"
                          className="size-8 shrink-0"
                          onClick={() => removeFromQueue(track.id)}
                        >
                          <span className="sr-only">Remove</span>×
                        </Button>
                      </div>
                    ))}
                  </div>
                </ScrollArea>
              </SheetContent>
            </Sheet>
          </div>
        </div>
      </div>
    </div>
  )
}
