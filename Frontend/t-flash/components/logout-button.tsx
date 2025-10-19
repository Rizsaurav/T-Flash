"use client";
import { useRouter } from "next/navigation";
import { Button } from "@/components/ui/button";
import { supabase } from "@/lib/supabase";

export default function LogoutButton({ className }: { className?: string }) {
  const router = useRouter();
  const handleLogout = async () => {
    try {
      if (typeof window !== "undefined") localStorage.removeItem("guest_mode");
      await supabase.auth.signOut();
    } finally {
      router.replace("/auth");
    }
  };
  return (
    <Button variant="outline" size="sm" className={className} onClick={handleLogout}>
      Log out
    </Button>
  );
}
