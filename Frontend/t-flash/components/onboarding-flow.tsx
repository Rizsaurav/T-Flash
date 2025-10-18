"use client"

import { useState } from "react"
import { Button } from "@/components/ui/button"
import { Card } from "@/components/ui/card"
import { Label } from "@/components/ui/label"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Check, Sparkles } from "lucide-react"
import { useRouter } from "next/navigation"

const topics = [
  { id: "technology", label: "Technology" },
  { id: "politics", label: "Politics" },
  { id: "business", label: "Business" },
  { id: "sports", label: "Sports" },
  { id: "entertainment", label: "Entertainment" },
  { id: "science", label: "Science" },
  { id: "health", label: "Health" },
  { id: "world", label: "World News" },
  { id: "climate", label: "Climate" },
  { id: "culture", label: "Culture" },
]

export function OnboardingFlow() {
  const router = useRouter()
  const [selectedTopics, setSelectedTopics] = useState<string[]>([])
  const [deliveryTime, setDeliveryTime] = useState("8:00 AM")
  const [briefingLength, setBriefingLength] = useState("10")
  const [isGenerating, setIsGenerating] = useState(false)

  const toggleTopic = (topicId: string) => {
    setSelectedTopics((prev) => (prev.includes(topicId) ? prev.filter((id) => id !== topicId) : [...prev, topicId]))
  }

  const handleGetStarted = () => {
    router.push("/dashboard")
  }

  const handleGetNewsNow = async () => {
    setIsGenerating(true)
    
    try {
      const response = await fetch(process.env.NEXT_PUBLIC_N8N_WEBHOOK_URL!, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          event: 'generate_news_now',
          topics: selectedTopics,
          briefingLength: briefingLength,
          deliveryTime: deliveryTime
        })
      })

      const result = await response.json()
      console.log('[n8n triggered]', result)
      
      setTimeout(() => {
        router.push('/dashboard')
      }, 1500)
      
    } catch (error) {
      console.error('[n8n error]', error)
      setTimeout(() => {
        router.push('/dashboard')
      }, 1500)
    }
  }

  // Get labels for selected topics
  const selectedTopicLabels = selectedTopics
    .slice(0, 3)
    .map((id) => topics.find((t) => t.id === id)?.label)
    .filter(Boolean)
    .join(", ")

  return (
    <div className="flex min-h-screen flex-col items-center justify-center px-4 py-12">
      <div className="w-full max-w-4xl space-y-12">
        <div className="space-y-4 text-center">
          <h1 className="font-mono text-5xl font-bold tracking-tight text-balance md:text-6xl lg:text-7xl">
            InsidePulse
          </h1>
          <p className="text-xl text-muted-foreground text-balance md:text-2xl">
            Personalized audio news, delivered on your schedule
          </p>
        </div>

        <div className="space-y-8">
          {/* Topics Section */}
          <div className="space-y-4">
            <div className="space-y-2">
              <h2 className="text-2xl font-bold tracking-tight">What interests you?</h2>
              <p className="text-muted-foreground">
                Select topics to personalize your daily briefing. Tap to add or remove.
              </p>
            </div>

            <div className="flex flex-wrap gap-3">
              {topics.map((topic) => {
                const isSelected = selectedTopics.includes(topic.id)
                return (
                  <button
                    key={topic.id}
                    onClick={() => toggleTopic(topic.id)}
                    className="group relative inline-flex items-center gap-2 rounded-full border-2 border-border bg-background px-6 py-3 text-sm font-medium transition-all hover:border-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring data-[selected=true]:border-foreground data-[selected=true]:bg-foreground data-[selected=true]:text-background"
                    data-selected={isSelected}
                  >
                    {isSelected && <Check className="h-4 w-4" />}
                    {topic.label}
                  </button>
                )
              })}
            </div>

            {selectedTopics.length > 0 && (
              <p className="text-sm text-muted-foreground">
                {selectedTopics.length} {selectedTopics.length === 1 ? "topic" : "topics"} selected
              </p>
            )}
          </div>

          {/* Instant News Generation Section */}
          {selectedTopics.length > 0 && (
            <Card className="border-2 border-foreground bg-foreground p-6 text-background md:p-8">
              <div className="flex flex-col items-center gap-4 text-center">
                <Sparkles className="h-8 w-8" />
                <div className="space-y-2">
                  <h3 className="text-xl font-bold tracking-tight">Want news right now?</h3>
                  <p className="text-sm text-background/80">
                    Get an instant briefing on {selectedTopicLabels}
                    {selectedTopics.length > 3 && ` and ${selectedTopics.length - 3} more`}
                  </p>
                </div>
                <Button
                  size="lg"
                  variant="secondary"
                  onClick={handleGetNewsNow}
                  disabled={isGenerating}
                  className="h-12 px-8 text-base font-semibold"
                >
                  {isGenerating ? "Generating Your Briefing..." : "Get News Now"}
                </Button>
              </div>
            </Card>
          )}

          {/* Schedule Section */}
          <Card className="border-2 border-border p-6 md:p-8">
            <div className="space-y-6">
              <div className="space-y-2">
                <h2 className="text-2xl font-bold tracking-tight">Set your schedule</h2>
                <p className="text-muted-foreground">Choose when you want to receive your daily briefing</p>
              </div>

              <div className="grid gap-6 sm:grid-cols-2">
                <div className="space-y-3">
                  <Label htmlFor="delivery-time" className="text-base font-semibold">
                    Delivery Time
                  </Label>
                  <Select value={deliveryTime} onValueChange={setDeliveryTime}>
                    <SelectTrigger id="delivery-time" className="h-12 border-2">
                      <SelectValue />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="6:00 AM">6:00 AM</SelectItem>
                      <SelectItem value="7:00 AM">7:00 AM</SelectItem>
                      <SelectItem value="8:00 AM">8:00 AM</SelectItem>
                      <SelectItem value="9:00 AM">9:00 AM</SelectItem>
                      <SelectItem value="12:00 PM">12:00 PM</SelectItem>
                      <SelectItem value="5:00 PM">5:00 PM</SelectItem>
                      <SelectItem value="6:00 PM">6:00 PM</SelectItem>
                      <SelectItem value="7:00 PM">7:00 PM</SelectItem>
                    </SelectContent>
                  </Select>
                </div>

                <div className="space-y-3">
                  <Label htmlFor="briefing-length" className="text-base font-semibold">
                    Briefing Length
                  </Label>
                  <Select value={briefingLength} onValueChange={setBriefingLength}>
                    <SelectTrigger id="briefing-length" className="h-12 border-2">
                      <SelectValue />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="5">5 minutes</SelectItem>
                      <SelectItem value="10">10 minutes</SelectItem>
                      <SelectItem value="15">15 minutes</SelectItem>
                      <SelectItem value="20">20 minutes</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
              </div>
            </div>
          </Card>

          <div className="flex flex-col items-center gap-4 pt-4">
            <Button
              size="lg"
              disabled={selectedTopics.length === 0}
              onClick={handleGetStarted}
              className="h-14 px-12 text-lg font-semibold"
            >
              Get Started
            </Button>
            {selectedTopics.length === 0 && (
              <p className="text-sm text-muted-foreground">Select at least one topic to continue</p>
            )}
          </div>
        </div>

        <p className="text-center text-sm text-muted-foreground">
          You can customize these preferences anytime in settings
        </p>
      </div>
    </div>
  )
}
