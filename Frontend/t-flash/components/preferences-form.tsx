"use client"

import { Separator } from "@/components/ui/separator"

import { useState } from "react"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Label } from "@/components/ui/label"
import { Switch } from "@/components/ui/switch"
import { Button } from "@/components/ui/button"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Slider } from "@/components/ui/slider"
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"
import { Bell, Clock, Mic, Volume2 } from "lucide-react"

const topics = [
  { id: "technology", label: "Technology", description: "Latest tech news and innovations" },
  { id: "politics", label: "Politics", description: "Global political developments" },
  { id: "business", label: "Business", description: "Markets, finance, and economy" },
  { id: "sports", label: "Sports", description: "Scores, highlights, and analysis" },
  { id: "entertainment", label: "Entertainment", description: "Movies, music, and pop culture" },
  { id: "science", label: "Science", description: "Research and discoveries" },
  { id: "health", label: "Health", description: "Wellness and medical news" },
  { id: "world", label: "World", description: "International news and events" },
]

export function PreferencesForm() {
  const [selectedTopics, setSelectedTopics] = useState<string[]>(["technology", "business", "world"])
  const [briefingLength, setBriefingLength] = useState([15])
  const [playbackSpeed, setPlaybackSpeed] = useState([1])
  const [notifications, setNotifications] = useState(true)
  const [autoPlay, setAutoPlay] = useState(false)

  const toggleTopic = (topicId: string) => {
    setSelectedTopics((prev) => (prev.includes(topicId) ? prev.filter((id) => id !== topicId) : [...prev, topicId]))
  }

  return (
    <Tabs defaultValue="topics" className="space-y-6">
      <TabsList>
        <TabsTrigger value="topics">Topics</TabsTrigger>
        <TabsTrigger value="delivery">Delivery</TabsTrigger>
        <TabsTrigger value="playback">Playback</TabsTrigger>
        <TabsTrigger value="notifications">Notifications</TabsTrigger>
      </TabsList>

      <TabsContent value="topics" className="space-y-4">
        <Card>
          <CardHeader>
            <CardTitle>News Topics</CardTitle>
            <CardDescription>Select the topics you want to hear about in your daily briefings</CardDescription>
          </CardHeader>
          <CardContent>
            <div className="grid gap-4 sm:grid-cols-2">
              {topics.map((topic) => (
                <button
                  key={topic.id}
                  onClick={() => toggleTopic(topic.id)}
                  className="group flex items-start gap-4 rounded-sm border-2 border-border bg-card p-4 text-left transition-all hover:border-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring data-[selected=true]:border-foreground data-[selected=true]:bg-foreground data-[selected=true]:text-background"
                  data-selected={selectedTopics.includes(topic.id)}
                >
                  <Switch checked={selectedTopics.includes(topic.id)} className="mt-0.5" />
                  <div className="flex-1 space-y-1">
                    <div className="font-semibold leading-none">{topic.label}</div>
                    <div className="text-sm opacity-70">{topic.description}</div>
                  </div>
                </button>
              ))}
            </div>
            <div className="mt-6 flex items-center justify-between">
              <p className="text-sm text-muted-foreground">
                {selectedTopics.length} {selectedTopics.length === 1 ? "topic" : "topics"} selected
              </p>
              <Button>Save Topics</Button>
            </div>
          </CardContent>
        </Card>
      </TabsContent>

      <TabsContent value="delivery" className="space-y-4">
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Clock className="size-5" />
              Delivery Schedule
            </CardTitle>
            <CardDescription>Choose when you want to receive your audio briefings</CardDescription>
          </CardHeader>
          <CardContent className="space-y-6">
            <div className="space-y-4">
              <div className="flex items-center justify-between">
                <div className="space-y-0.5">
                  <Label htmlFor="morning-briefing" className="text-base">
                    Morning Briefing
                  </Label>
                  <p className="text-sm text-muted-foreground">Get your daily news at the start of your day</p>
                </div>
                <Switch id="morning-briefing" defaultChecked />
              </div>
              <div className="ml-6 space-y-2">
                <Label htmlFor="morning-time" className="text-sm">
                  Delivery Time
                </Label>
                <Select defaultValue="7am">
                  <SelectTrigger id="morning-time" className="w-[180px]">
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="6am">6:00 AM</SelectItem>
                    <SelectItem value="7am">7:00 AM</SelectItem>
                    <SelectItem value="8am">8:00 AM</SelectItem>
                    <SelectItem value="9am">9:00 AM</SelectItem>
                  </SelectContent>
                </Select>
              </div>
            </div>

            <Separator />

            <div className="space-y-4">
              <div className="flex items-center justify-between">
                <div className="space-y-0.5">
                  <Label htmlFor="afternoon-update" className="text-base">
                    Afternoon Update
                  </Label>
                  <p className="text-sm text-muted-foreground">Midday news summary</p>
                </div>
                <Switch id="afternoon-update" />
              </div>
              <div className="ml-6 space-y-2">
                <Label htmlFor="afternoon-time" className="text-sm">
                  Delivery Time
                </Label>
                <Select defaultValue="2pm">
                  <SelectTrigger id="afternoon-time" className="w-[180px]">
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="12pm">12:00 PM</SelectItem>
                    <SelectItem value="1pm">1:00 PM</SelectItem>
                    <SelectItem value="2pm">2:00 PM</SelectItem>
                    <SelectItem value="3pm">3:00 PM</SelectItem>
                  </SelectContent>
                </Select>
              </div>
            </div>

            <Separator />

            <div className="space-y-4">
              <div className="flex items-center justify-between">
                <div className="space-y-0.5">
                  <Label htmlFor="evening-digest" className="text-base">
                    Evening Digest
                  </Label>
                  <p className="text-sm text-muted-foreground">End of day news roundup</p>
                </div>
                <Switch id="evening-digest" defaultChecked />
              </div>
              <div className="ml-6 space-y-2">
                <Label htmlFor="evening-time" className="text-sm">
                  Delivery Time
                </Label>
                <Select defaultValue="6pm">
                  <SelectTrigger id="evening-time" className="w-[180px]">
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="5pm">5:00 PM</SelectItem>
                    <SelectItem value="6pm">6:00 PM</SelectItem>
                    <SelectItem value="7pm">7:00 PM</SelectItem>
                    <SelectItem value="8pm">8:00 PM</SelectItem>
                  </SelectContent>
                </Select>
              </div>
            </div>

            <Separator />

            <div className="space-y-4">
              <Label htmlFor="briefing-length">Briefing Length</Label>
              <div className="space-y-2">
                <Slider
                  id="briefing-length"
                  value={briefingLength}
                  onValueChange={setBriefingLength}
                  min={5}
                  max={30}
                  step={5}
                  className="w-full"
                />
                <div className="flex justify-between text-sm text-muted-foreground">
                  <span>5 min</span>
                  <span className="font-medium text-foreground">{briefingLength[0]} minutes</span>
                  <span>30 min</span>
                </div>
              </div>
            </div>

            <div className="flex justify-end">
              <Button>Save Schedule</Button>
            </div>
          </CardContent>
        </Card>
      </TabsContent>

      <TabsContent value="playback" className="space-y-4">
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Volume2 className="size-5" />
              Playback Settings
            </CardTitle>
            <CardDescription>Customize your audio playback experience</CardDescription>
          </CardHeader>
          <CardContent className="space-y-6">
            <div className="space-y-4">
              <Label htmlFor="playback-speed">Playback Speed</Label>
              <div className="space-y-2">
                <Slider
                  id="playback-speed"
                  value={playbackSpeed}
                  onValueChange={setPlaybackSpeed}
                  min={0.5}
                  max={2}
                  step={0.25}
                  className="w-full"
                />
                <div className="flex justify-between text-sm text-muted-foreground">
                  <span>0.5x</span>
                  <span className="font-medium text-foreground">{playbackSpeed[0]}x</span>
                  <span>2.0x</span>
                </div>
              </div>
            </div>

            <Separator />

            <div className="flex items-center justify-between">
              <div className="space-y-0.5">
                <Label htmlFor="auto-play" className="text-base">
                  Auto-play Next Episode
                </Label>
                <p className="text-sm text-muted-foreground">Automatically play the next briefing when one finishes</p>
              </div>
              <Switch id="auto-play" checked={autoPlay} onCheckedChange={setAutoPlay} />
            </div>

            <Separator />

            <div className="space-y-4">
              <Label htmlFor="voice-preference">Voice Preference</Label>
              <Select defaultValue="neutral">
                <SelectTrigger id="voice-preference">
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="neutral">
                    <div className="flex items-center gap-2">
                      <Mic className="size-4" />
                      <span>Neutral (Default)</span>
                    </div>
                  </SelectItem>
                  <SelectItem value="professional">
                    <div className="flex items-center gap-2">
                      <Mic className="size-4" />
                      <span>Professional</span>
                    </div>
                  </SelectItem>
                  <SelectItem value="casual">
                    <div className="flex items-center gap-2">
                      <Mic className="size-4" />
                      <span>Casual</span>
                    </div>
                  </SelectItem>
                  <SelectItem value="energetic">
                    <div className="flex items-center gap-2">
                      <Mic className="size-4" />
                      <span>Energetic</span>
                    </div>
                  </SelectItem>
                </SelectContent>
              </Select>
            </div>

            <div className="flex justify-end">
              <Button>Save Playback Settings</Button>
            </div>
          </CardContent>
        </Card>
      </TabsContent>

      <TabsContent value="notifications" className="space-y-4">
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Bell className="size-5" />
              Notification Preferences
            </CardTitle>
            <CardDescription>Manage how and when you receive notifications</CardDescription>
          </CardHeader>
          <CardContent className="space-y-6">
            <div className="flex items-center justify-between">
              <div className="space-y-0.5">
                <Label htmlFor="push-notifications" className="text-base">
                  Push Notifications
                </Label>
                <p className="text-sm text-muted-foreground">Receive notifications when new briefings are ready</p>
              </div>
              <Switch id="push-notifications" checked={notifications} onCheckedChange={setNotifications} />
            </div>

            <Separator />

            <div className="flex items-center justify-between">
              <div className="space-y-0.5">
                <Label htmlFor="email-notifications" className="text-base">
                  Email Notifications
                </Label>
                <p className="text-sm text-muted-foreground">Get email summaries of your briefings</p>
              </div>
              <Switch id="email-notifications" />
            </div>

            <Separator />

            <div className="flex items-center justify-between">
              <div className="space-y-0.5">
                <Label htmlFor="breaking-news" className="text-base">
                  Breaking News Alerts
                </Label>
                <p className="text-sm text-muted-foreground">Instant notifications for major breaking news</p>
              </div>
              <Switch id="breaking-news" defaultChecked />
            </div>

            <Separator />

            <div className="space-y-4">
              <Label>Quiet Hours</Label>
              <p className="text-sm text-muted-foreground">Don't send notifications during these hours</p>
              <div className="flex items-center gap-4">
                <div className="flex-1 space-y-2">
                  <Label htmlFor="quiet-start" className="text-sm">
                    Start
                  </Label>
                  <Select defaultValue="10pm">
                    <SelectTrigger id="quiet-start">
                      <SelectValue />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="9pm">9:00 PM</SelectItem>
                      <SelectItem value="10pm">10:00 PM</SelectItem>
                      <SelectItem value="11pm">11:00 PM</SelectItem>
                      <SelectItem value="12am">12:00 AM</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
                <div className="flex-1 space-y-2">
                  <Label htmlFor="quiet-end" className="text-sm">
                    End
                  </Label>
                  <Select defaultValue="7am">
                    <SelectTrigger id="quiet-end">
                      <SelectValue />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="6am">6:00 AM</SelectItem>
                      <SelectItem value="7am">7:00 AM</SelectItem>
                      <SelectItem value="8am">8:00 AM</SelectItem>
                      <SelectItem value="9am">9:00 AM</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
              </div>
            </div>

            <div className="flex justify-end">
              <Button>Save Notification Settings</Button>
            </div>
          </CardContent>
        </Card>
      </TabsContent>
    </Tabs>
  )
}
