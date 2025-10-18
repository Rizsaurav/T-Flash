"use client"

import { useState } from "react"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Button } from "@/components/ui/button"
import { ChevronLeft, ChevronRight, Plus } from "lucide-react"
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog"
import { Label } from "@/components/ui/label"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Switch } from "@/components/ui/switch"

const daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
const months = [
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December",
]

interface ScheduledBriefing {
  date: string
  time: string
  type: "morning" | "afternoon" | "evening"
  enabled: boolean
}

const scheduledBriefings: ScheduledBriefing[] = [
  { date: "2025-01-17", time: "7:00 AM", type: "morning", enabled: true },
  { date: "2025-01-17", time: "6:00 PM", type: "evening", enabled: true },
  { date: "2025-01-18", time: "7:00 AM", type: "morning", enabled: true },
  { date: "2025-01-18", time: "6:00 PM", type: "evening", enabled: true },
  { date: "2025-01-19", time: "7:00 AM", type: "morning", enabled: true },
  { date: "2025-01-19", time: "6:00 PM", type: "evening", enabled: true },
  { date: "2025-01-20", time: "7:00 AM", type: "morning", enabled: true },
  { date: "2025-01-20", time: "2:00 PM", type: "afternoon", enabled: true },
  { date: "2025-01-20", time: "6:00 PM", type: "evening", enabled: true },
]

export function ScheduleCalendar() {
  const [currentDate, setCurrentDate] = useState(new Date(2025, 0, 17)) // January 17, 2025
  const [selectedDate, setSelectedDate] = useState<Date | null>(null)

  const getDaysInMonth = (date: Date) => {
    const year = date.getFullYear()
    const month = date.getMonth()
    const firstDay = new Date(year, month, 1)
    const lastDay = new Date(year, month + 1, 0)
    const daysInMonth = lastDay.getDate()
    const startingDayOfWeek = firstDay.getDay()

    return { daysInMonth, startingDayOfWeek }
  }

  const getBriefingsForDate = (date: Date) => {
    const dateString = date.toISOString().split("T")[0]
    return scheduledBriefings.filter((b) => b.date === dateString && b.enabled)
  }

  const { daysInMonth, startingDayOfWeek } = getDaysInMonth(currentDate)

  const previousMonth = () => {
    setCurrentDate(new Date(currentDate.getFullYear(), currentDate.getMonth() - 1, 1))
  }

  const nextMonth = () => {
    setCurrentDate(new Date(currentDate.getFullYear(), currentDate.getMonth() + 1, 1))
  }

  const renderCalendarDays = () => {
    const days = []

    // Empty cells for days before the first day of the month
    for (let i = 0; i < startingDayOfWeek; i++) {
      days.push(<div key={`empty-${i}`} className="aspect-square p-2" />)
    }

    // Days of the month
    for (let day = 1; day <= daysInMonth; day++) {
      const date = new Date(currentDate.getFullYear(), currentDate.getMonth(), day)
      const briefings = getBriefingsForDate(date)
      const isToday = date.toDateString() === new Date(2025, 0, 17).toDateString()
      const isSelected = selectedDate?.toDateString() === date.toDateString()

      days.push(
        <button
          key={day}
          onClick={() => setSelectedDate(date)}
          className="group aspect-square rounded-sm border-2 border-border p-2 transition-all hover:border-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring data-[selected=true]:border-foreground data-[selected=true]:bg-accent data-[today=true]:border-primary"
          data-selected={isSelected}
          data-today={isToday}
        >
          <div className="flex h-full flex-col">
            <span className="text-sm font-semibold group-data-[today=true]:text-primary">{day}</span>
            {briefings.length > 0 && (
              <div className="mt-auto flex flex-wrap gap-1">
                {briefings.map((briefing, idx) => (
                  <div
                    key={idx}
                    className="size-1.5 rounded-full bg-primary"
                    title={`${briefing.type} briefing at ${briefing.time}`}
                  />
                ))}
              </div>
            )}
          </div>
        </button>,
      )
    }

    return days
  }

  return (
    <Card className="flex flex-col">
      <CardHeader>
        <div className="flex items-center justify-between">
          <div>
            <CardTitle>Calendar</CardTitle>
            <CardDescription>View and manage your briefing schedule</CardDescription>
          </div>
          <Dialog>
            <DialogTrigger asChild>
              <Button size="sm" className="gap-2">
                <Plus className="size-4" />
                Add Briefing
              </Button>
            </DialogTrigger>
            <DialogContent>
              <DialogHeader>
                <DialogTitle>Schedule New Briefing</DialogTitle>
                <DialogDescription>Add a new briefing to your schedule</DialogDescription>
              </DialogHeader>
              <div className="space-y-4 py-4">
                <div className="space-y-2">
                  <Label htmlFor="briefing-type">Briefing Type</Label>
                  <Select defaultValue="morning">
                    <SelectTrigger id="briefing-type">
                      <SelectValue />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="morning">Morning Briefing</SelectItem>
                      <SelectItem value="afternoon">Afternoon Update</SelectItem>
                      <SelectItem value="evening">Evening Digest</SelectItem>
                      <SelectItem value="custom">Custom Briefing</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
                <div className="space-y-2">
                  <Label htmlFor="briefing-time">Time</Label>
                  <Select defaultValue="7am">
                    <SelectTrigger id="briefing-time">
                      <SelectValue />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="6am">6:00 AM</SelectItem>
                      <SelectItem value="7am">7:00 AM</SelectItem>
                      <SelectItem value="8am">8:00 AM</SelectItem>
                      <SelectItem value="12pm">12:00 PM</SelectItem>
                      <SelectItem value="2pm">2:00 PM</SelectItem>
                      <SelectItem value="6pm">6:00 PM</SelectItem>
                      <SelectItem value="8pm">8:00 PM</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
                <div className="space-y-2">
                  <Label>Repeat</Label>
                  <Select defaultValue="daily">
                    <SelectTrigger>
                      <SelectValue />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="once">Once</SelectItem>
                      <SelectItem value="daily">Daily</SelectItem>
                      <SelectItem value="weekdays">Weekdays</SelectItem>
                      <SelectItem value="weekends">Weekends</SelectItem>
                      <SelectItem value="custom">Custom</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
                <div className="flex items-center justify-between">
                  <Label htmlFor="enabled">Enabled</Label>
                  <Switch id="enabled" defaultChecked />
                </div>
              </div>
              <div className="flex justify-end gap-2">
                <Button variant="outline">Cancel</Button>
                <Button>Save Briefing</Button>
              </div>
            </DialogContent>
          </Dialog>
        </div>
      </CardHeader>
      <CardContent className="flex-1">
        <div className="space-y-4">
          {/* Month Navigation */}
          <div className="flex items-center justify-between">
            <Button variant="outline" size="icon" onClick={previousMonth}>
              <ChevronLeft className="size-4" />
            </Button>
            <h3 className="font-semibold">
              {months[currentDate.getMonth()]} {currentDate.getFullYear()}
            </h3>
            <Button variant="outline" size="icon" onClick={nextMonth}>
              <ChevronRight className="size-4" />
            </Button>
          </div>

          {/* Calendar Grid */}
          <div className="space-y-2">
            {/* Day Headers */}
            <div className="grid grid-cols-7 gap-2">
              {daysOfWeek.map((day) => (
                <div key={day} className="text-center text-sm font-semibold text-muted-foreground">
                  {day}
                </div>
              ))}
            </div>

            {/* Calendar Days */}
            <div className="grid grid-cols-7 gap-2">{renderCalendarDays()}</div>
          </div>

          {/* Legend */}
          <div className="flex items-center gap-4 border-t pt-4 text-sm">
            <div className="flex items-center gap-2">
              <div className="size-3 rounded-full border-2 border-primary" />
              <span className="text-muted-foreground">Today</span>
            </div>
            <div className="flex items-center gap-2">
              <div className="size-3 rounded-full bg-primary" />
              <span className="text-muted-foreground">Scheduled</span>
            </div>
          </div>
        </div>
      </CardContent>
    </Card>
  )
}
