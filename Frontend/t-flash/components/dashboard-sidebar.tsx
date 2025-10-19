"use client"

import { Home, Library, Clock, Settings, Radio, TrendingUp, CalendarDays } from "lucide-react"
import {
  Sidebar,
  SidebarContent,
  SidebarFooter,
  SidebarGroup,
  SidebarGroupContent,
  SidebarGroupLabel,
  SidebarHeader,
  SidebarMenu,
  SidebarMenuButton,
  SidebarMenuItem,
  SidebarRail,
} from "@/components/ui/sidebar"
import { Avatar, AvatarFallback } from "@/components/ui/avatar"

const menuItems = [
  { title: "Dashboard", icon: Home, url: "/dashboard" },
  { title: "Library", icon: Library, url: "/dashboard/library" },
  { title: "Schedule", icon: CalendarDays, url: "/dashboard/schedule" },
  { title: "Trending", icon: TrendingUp, url: "/dashboard/trending" },
  { title: "Live", icon: Radio, url: "/dashboard/live" },
  { title: "History", icon: Clock, url: "/dashboard/history" },
]

export function DashboardSidebar() {
  return (
    <Sidebar collapsible="icon">
      <SidebarHeader className="border-b">
        <div className="flex items-center gap-2 px-2 py-1">
          <div className="flex size-8 items-center justify-center rounded-sm bg-foreground text-background">
            <Radio className="size-4" />
          </div>
          <div className="flex flex-col gap-0.5 leading-none">
            <span className="font-mono font-semibold">InsidePulse</span>
            <span className="text-xs text-muted-foreground">Audio News</span>
          </div>
        </div>
      </SidebarHeader>
      <SidebarContent>
        <SidebarGroup>
          <SidebarGroupLabel>Navigation</SidebarGroupLabel>
          <SidebarGroupContent>
            <SidebarMenu>
              {menuItems.map((item) => (
                <SidebarMenuItem key={item.title}>
                  <SidebarMenuButton asChild isActive={item.url === "/dashboard"}>
                    <a href={item.url}>
                      <item.icon />
                      <span>{item.title}</span>
                    </a>
                  </SidebarMenuButton>
                </SidebarMenuItem>
              ))}
            </SidebarMenu>
          </SidebarGroupContent>
        </SidebarGroup>
      </SidebarContent>
      <SidebarFooter className="border-t">
        <SidebarMenu>
          <SidebarMenuItem>
            <SidebarMenuButton asChild>
              <a href="/dashboard/settings">
                <Settings />
                <span>Settings</span>
              </a>
            </SidebarMenuButton>
          </SidebarMenuItem>
          <SidebarMenuItem>
            <div className="flex items-center gap-2 px-2 py-1.5">
              <Avatar className="size-8">
                <AvatarFallback className="bg-primary text-primary-foreground text-xs">JD</AvatarFallback>
              </Avatar>
              <div className="flex flex-col gap-0.5 leading-none">
                <span className="text-sm font-medium">John Doe</span>
                <span className="text-xs text-muted-foreground">john@example.com</span>
              </div>
            </div>
          </SidebarMenuItem>
        </SidebarMenu>
      </SidebarFooter>
      <SidebarRail />
    </Sidebar>
  )
}
