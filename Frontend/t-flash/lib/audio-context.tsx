"use client"

import { createContext, useContext, useState, useRef, useEffect, type ReactNode } from "react"

export interface AudioTrack {
  id: string
  title: string
  date: string
  duration: number
  topics: string[]
  audioUrl?: string
}

interface AudioContextType {
  currentTrack: AudioTrack | null
  isPlaying: boolean
  currentTime: number
  duration: number
  volume: number
  playbackRate: number
  queue: AudioTrack[]
  play: (track?: AudioTrack) => void
  pause: () => void
  togglePlayPause: () => void
  seek: (time: number) => void
  setVolume: (volume: number) => void
  setPlaybackRate: (rate: number) => void
  skipForward: () => void
  skipBackward: () => void
  addToQueue: (track: AudioTrack) => void
  removeFromQueue: (trackId: string) => void
  clearQueue: () => void
}

const AudioContext = createContext<AudioContextType | undefined>(undefined)

export function useAudio() {
  const context = useContext(AudioContext)
  if (!context) {
    throw new Error("useAudio must be used within an AudioProvider")
  }
  return context
}

export function AudioProvider({ children }: { children: ReactNode }) {
  const [currentTrack, setCurrentTrack] = useState<AudioTrack | null>(null)
  const [isPlaying, setIsPlaying] = useState(false)
  const [currentTime, setCurrentTime] = useState(0)
  const [duration, setDuration] = useState(0)
  const [volume, setVolumeState] = useState(0.7)
  const [playbackRate, setPlaybackRateState] = useState(1)
  const [queue, setQueue] = useState<AudioTrack[]>([])

  const audioRef = useRef<HTMLAudioElement | null>(null)

  // Initialize audio element
  useEffect(() => {
    audioRef.current = new Audio()
    audioRef.current.volume = volume
    audioRef.current.playbackRate = playbackRate

    const audio = audioRef.current

    const handleTimeUpdate = () => {
      setCurrentTime(audio.currentTime)
    }

    const handleDurationChange = () => {
      setDuration(audio.duration)
    }

    const handleEnded = () => {
      setIsPlaying(false)
      // Auto-play next in queue
      if (queue.length > 0) {
        const nextTrack = queue[0]
        setQueue((prev) => prev.slice(1))
        play(nextTrack)
      }
    }

    const handlePlay = () => {
      setIsPlaying(true)
    }

    const handlePause = () => {
      setIsPlaying(false)
    }

    audio.addEventListener("timeupdate", handleTimeUpdate)
    audio.addEventListener("durationchange", handleDurationChange)
    audio.addEventListener("ended", handleEnded)
    audio.addEventListener("play", handlePlay)
    audio.addEventListener("pause", handlePause)

    return () => {
      audio.removeEventListener("timeupdate", handleTimeUpdate)
      audio.removeEventListener("durationchange", handleDurationChange)
      audio.removeEventListener("ended", handleEnded)
      audio.removeEventListener("play", handlePlay)
      audio.removeEventListener("pause", handlePause)
      audio.pause()
    }
  }, [queue])

  const play = (track?: AudioTrack) => {
    if (!audioRef.current) return

    if (track) {
      setCurrentTrack(track)
      // In a real app, this would be the actual audio URL
      audioRef.current.src = track.audioUrl || "/placeholder-audio.mp3"
      audioRef.current.load()
    }

    audioRef.current.play().catch((error) => {
      console.error("Error playing audio:", error)
    })
  }

  const pause = () => {
    if (!audioRef.current) return
    audioRef.current.pause()
  }

  const togglePlayPause = () => {
    if (isPlaying) {
      pause()
    } else {
      play()
    }
  }

  const seek = (time: number) => {
    if (!audioRef.current) return
    audioRef.current.currentTime = time
    setCurrentTime(time)
  }

  const setVolume = (newVolume: number) => {
    if (!audioRef.current) return
    const clampedVolume = Math.max(0, Math.min(1, newVolume))
    audioRef.current.volume = clampedVolume
    setVolumeState(clampedVolume)
  }

  const setPlaybackRate = (rate: number) => {
    if (!audioRef.current) return
    const clampedRate = Math.max(0.5, Math.min(2, rate))
    audioRef.current.playbackRate = clampedRate
    setPlaybackRateState(clampedRate)
  }

  const skipForward = () => {
    if (!audioRef.current) return
    const newTime = Math.min(currentTime + 15, duration)
    seek(newTime)
  }

  const skipBackward = () => {
    if (!audioRef.current) return
    const newTime = Math.max(currentTime - 15, 0)
    seek(newTime)
  }

  const addToQueue = (track: AudioTrack) => {
    setQueue((prev) => [...prev, track])
  }

  const removeFromQueue = (trackId: string) => {
    setQueue((prev) => prev.filter((track) => track.id !== trackId))
  }

  const clearQueue = () => {
    setQueue([])
  }

  return (
    <AudioContext.Provider
      value={{
        currentTrack,
        isPlaying,
        currentTime,
        duration,
        volume,
        playbackRate,
        queue,
        play,
        pause,
        togglePlayPause,
        seek,
        setVolume,
        setPlaybackRate,
        skipForward,
        skipBackward,
        addToQueue,
        removeFromQueue,
        clearQueue,
      }}
    >
      {children}
    </AudioContext.Provider>
  )
}
