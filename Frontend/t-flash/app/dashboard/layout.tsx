import type React from "react"
import { SidebarProvider } from "@/components/ui/sidebar"
import { DashboardSidebar } from "@/components/dashboard-sidebar"
import { AudioProvider } from "@/lib/audio-context"
import { AudioPlayerBar } from "@/components/audio-player-bar"

export default function DashboardLayout({ children }: { children: React.ReactNode }) {
  return (
    <AudioProvider>
      <SidebarProvider defaultOpen={true}>
        <DashboardSidebar />
        {children}
        <AudioPlayerBar />
      </SidebarProvider>
    </AudioProvider>
  )
}
