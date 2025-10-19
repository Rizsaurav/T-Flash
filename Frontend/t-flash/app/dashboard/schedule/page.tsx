import { SidebarInset, SidebarTrigger } from "@/components/ui/sidebar"
import { Separator } from "@/components/ui/separator"
import {
  Breadcrumb,
  BreadcrumbList,
  BreadcrumbItem,
  BreadcrumbLink,
  BreadcrumbSeparator,
  BreadcrumbPage,
} from "@/components/ui/breadcrumb"
import { ScheduleCalendar } from "@/components/schedule-calendar"
import { UpcomingBriefings } from "@/components/upcoming-briefings"

export default function SchedulePage() {
  return (
    <SidebarInset>
      <header className="flex h-16 shrink-0 items-center gap-2 border-b px-4">
        <SidebarTrigger className="-ml-1" />
        <Separator orientation="vertical" className="mr-2 h-4" />
        <Breadcrumb>
          <BreadcrumbList>
            <BreadcrumbItem>
              <BreadcrumbLink href="/dashboard">Dashboard</BreadcrumbLink>
            </BreadcrumbItem>
            <BreadcrumbSeparator />
            <BreadcrumbItem>
              <BreadcrumbPage className="font-semibold">Schedule</BreadcrumbPage>
            </BreadcrumbItem>
          </BreadcrumbList>
        </Breadcrumb>
      </header>
      <div className="flex flex-1 flex-col gap-4 p-4 md:p-6">
        <div className="space-y-2">
          <h1 className="text-3xl font-bold tracking-tight">Briefing Schedule</h1>
          <p className="text-muted-foreground">Manage when you receive your personalized audio news briefings</p>
        </div>
        <div className="grid gap-4 lg:grid-cols-[1fr_400px]">
          <ScheduleCalendar />
          <UpcomingBriefings />
        </div>
      </div>
    </SidebarInset>
  )
}
