"use client";
import { useEffect } from "react";
import { useRouter, useSearchParams } from "next/navigation";
import { supabase } from "../../../lib/supabase";

export default function AuthCallback() {
  const router = useRouter();
  const searchParams = useSearchParams();

  useEffect(() => {
    const code = searchParams.get("code");

    if (!code) {
      router.replace("/auth");
      return;
    }

    const handleAuth = async () => {
      const { error } = await supabase.auth.exchangeCodeForSession(code);
      if (error) {
        console.error(error);
        router.replace("/auth");
      } else {
        router.replace("/");
      }
    };

    handleAuth();
  }, [router, searchParams]);

  return <main className="p-6">Signing you in…</main>;
}
