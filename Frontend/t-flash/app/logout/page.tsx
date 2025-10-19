"use client";
import { useEffect } from "react";
import { useRouter } from "next/navigation";
import { supabase } from "@/lib/supabase";

export default function Logout() {
  const router = useRouter();
  useEffect(() => {
    (async () => {
      try {
        if (typeof window !== "undefined") localStorage.removeItem("guest_mode");
        await supabase.auth.signOut();
      } finally {
        router.replace("/auth");
      }
    })();
  }, [router]);
  return <main className="p-6">Signing you out…</main>;
}