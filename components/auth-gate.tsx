"use client";
import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { supabase } from "@/lib/supabase";

export default function AuthGate({ children }: { children: React.ReactNode }) {
  const router = useRouter();
  const [ready, setReady] = useState(false);
  useEffect(() => {
    (async () => {
      const guest = typeof window !== "undefined" && localStorage.getItem("guest_mode") === "1";
      const { data } = await supabase.auth.getSession();
      if (!guest && !data.session) { router.replace("/auth"); return; }
      setReady(true);
    })();
  }, [router]);
  if (!ready) return null;
  return <>{children}</>;
}
