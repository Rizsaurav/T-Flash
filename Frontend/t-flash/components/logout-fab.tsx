"use client";
import { useRouter, usePathname } from "next/navigation";
import { supabase } from "@/lib/supabase";

export default function LogoutFab() {
  const router = useRouter();
  const pathname = usePathname();

  if (pathname?.startsWith("/auth") || pathname === "/logout") return null;

  const handleLogout = async () => {
    try {
      if (typeof window !== "undefined") localStorage.removeItem("guest_mode");
      await supabase.auth.signOut();
    } finally {
      router.replace("/auth");
    }
  };

  return (
    <div className="fixed right-6 top-6 z-50">
      <button
        onClick={handleLogout}
        className="h-9 rounded-md border px-3 text-sm hover:bg-neutral-50"
      >
        Log out
      </button>
    </div>
  );
}