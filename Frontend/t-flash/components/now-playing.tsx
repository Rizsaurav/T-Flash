"use client"

import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Button } from "@/components/ui/button"
import { Slider } from "@/components/ui/slider"
import { Badge } from "@/components/ui/badge"
import { Play, Pause, SkipBack, SkipForward, Volume2, Repeat, Shuffle } from "lucide-react"
import { useAudio } from "@/lib/audio-context"

export function NowPlaying() {
  const {
    currentTrack,
    isPlaying,
    currentTime,
    duration,
    volume,
    togglePlayPause,
    seek,
    setVolume,
    skipForward,
    skipBackward,
  } = useAudio()

  if (!currentTrack) {
    return (
      <Card className="flex flex-col">
        <CardHeader>
          <CardTitle>Now Playing</CardTitle>
        </CardHeader>
        <CardContent className="flex flex-1 flex-col items-center justify-center gap-4">
          <div className="text-center text-muted-foreground">
            <p className="text-sm">No audio playing</p>
            <p className="mt-1 text-xs">Select a briefing to start listening</p>
          </div>
        </CardContent>
      </Card>
    )
  }

  const progress = duration > 0 ? (currentTime / duration) * 100 : 0

  return (
    <Card className="flex flex-col">
      <CardHeader>
        <CardTitle>Now Playing</CardTitle>
      </CardHeader>
      <CardContent className="flex flex-1 flex-col gap-6">
        {/* Album Art / Waveform Visualization */}
        <div className="aspect-square w-full overflow-hidden rounded-sm border-2 border-foreground bg-gradient-to-br from-primary/20 to-accent/20">
          <div className="flex size-full items-center justify-center">
            <div className="flex items-end gap-1">
              {Array.from({ length: 32 }).map((_, i) => (
                <div
                  key={i}
                  className="w-1 bg-foreground/40 transition-all"
                  style={{
                    height: `${Math.random() * 60 + 20}%`,
                    animation: isPlaying ? `pulse ${Math.random() * 0.5 + 0.5}s ease-in-out infinite` : "none",
                  }}
                />
              ))}
            </div>
          </div>
        </div>

        {/* Track Info */}
        <div className="space-y-2">
          <h3 className="font-semibold leading-tight">{currentTrack.title}</h3>
          <p className="text-sm text-muted-foreground">{currentTrack.date}</p>
          <div className="flex flex-wrap gap-1.5">
            {currentTrack.topics.map((topic) => (
              <Badge key={topic} variant="secondary" className="text-xs">
                {topic}
              </Badge>
            ))}
          </div>
        </div>

        {/* Progress Bar */}
        <div className="space-y-2">
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
          <div className="flex justify-between text-xs text-muted-foreground">
            <span>
              {Math.floor(currentTime / 60)}:
              {Math.floor(currentTime % 60)
                .toString()
                .padStart(2, "0")}
            </span>
            <span>
              {Math.floor(duration / 60)}:
              {Math.floor(duration % 60)
                .toString()
                .padStart(2, "0")}
            </span>
          </div>
        </div>

        {/* Playback Controls */}
        <div className="flex items-center justify-center gap-2">
          <Button size="icon" variant="ghost" className="size-8">
            <Shuffle className="size-4" />
          </Button>
          <Button size="icon" variant="ghost" onClick={skipBackward}>
            <SkipBack className="size-5" />
          </Button>
          <Button size="icon" className="size-12 border-2 border-foreground" onClick={togglePlayPause}>
            {isPlaying ? <Pause className="size-5" /> : <Play className="size-5" />}
          </Button>
          <Button size="icon" variant="ghost" onClick={skipForward}>
            <SkipForward className="size-5" />
          </Button>
          <Button size="icon" variant="ghost" className="size-8">
            <Repeat className="size-4" />
          </Button>
        </div>

        {/* Volume Control */}
        <div className="flex items-center gap-2">
          <Volume2 className="size-4 text-muted-foreground" />
          <Slider
            value={[volume * 100]}
            onValueChange={([value]) => setVolume(value / 100)}
            max={100}
            step={1}
            className="flex-1"
          />
        </div>
      </CardContent>
    </Card>
  )
}
