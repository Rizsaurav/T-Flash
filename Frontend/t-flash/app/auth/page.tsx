"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { AuthService } from "../../lib/authServiceSupabase";

export default function AuthPage() {
  const router = useRouter();
  const authService = new AuthService();

  const [email, setEmail] = useState("");
  const [pw, setPw] = useState("");
  const [isSignUp, setIsSignUp] = useState(false);
  const [loading, setLoading] = useState(false);
  const [err, setErr] = useState<string | null>(null);

  async function handleEmailAuth(e: React.FormEvent) {
    e.preventDefault();
    setErr(null);
    if (!email || !pw) { setErr("Please enter email and password"); return; }
    setLoading(true);
    try {
      if (isSignUp) await authService.signUpWithEmail(email.trim(), pw);
      else await authService.signInWithEmail(email.trim(), pw);
      router.replace("/");
    } catch (e: any) {
      setErr(e?.message ?? "Authentication failed");
    } finally {
      setLoading(false);
    }
  }

  async function handleGuest() {
    await authService.enableGuestMode();
    router.replace("/");
  }

  async function handleGoogle() {
    try {
      await authService.signInWithGoogle(); // redirects to /auth/callback
    } catch (e: any) {
      setErr(e?.message ?? "Google sign-in failed");
    }
  }

  return (
    <main className="min-h-screen bg-white">
      <div className="max-w-md mx-auto px-8 py-16">
        <div className="flex flex-col items-center text-center">
          <div className="rounded-full h-16 w-16 flex items-center justify-center border border-neutral-200">
            <span className="text-3xl">📻</span>
          </div>
          <h1 className="mt-6 text-3xl font-bold text-neutral-900">T-Flash</h1>
          <p className="mt-2 text-sm text-neutral-500">Your personalized news briefings</p>
        </div>

        <form onSubmit={handleEmailAuth} className="mt-10 space-y-4">
          <div>
            <label className="block text-sm mb-1 text-neutral-700">Email</label>
            <input
              type="email"
              value={email}
              onChange={(e)=>setEmail(e.target.value)}
              placeholder="you@example.com"
              className="w-full rounded-lg border border-neutral-300 px-3 py-2 outline-none focus:ring-2 focus:ring-black/80"
              required
            />
          </div>

          <div>
            <label className="block text-sm mb-1 text-neutral-700">Password</label>
            <input
              type="password"
              value={pw}
              onChange={(e)=>setPw(e.target.value)}
              placeholder="••••••••"
              className="w-full rounded-lg border border-neutral-300 px-3 py-2 outline-none focus:ring-2 focus:ring-black/80"
              required
            />
          </div>

          {err && <p className="text-sm text-red-600">{err}</p>}

          <button
            type="submit"
            disabled={loading}
            className="w-full h-12 rounded-lg bg-black text-white disabled:opacity-60"
          >
            {loading ? "Please wait…" : (isSignUp ? "Create Account" : "Sign In")}
          </button>
        </form>

        <div className="mt-3 text-center">
          <button
            onClick={()=>setIsSignUp(!isSignUp)}
            className="text-sm text-neutral-700 underline"
          >
            {isSignUp ? "Have an account? Sign in" : "Need an account? Sign up"}
          </button>
        </div>

        <div className="my-8 flex items-center gap-2 text-xs text-neutral-500">
          <div className="h-px w-full bg-neutral-200" />
          <span>or</span>
          <div className="h-px w-full bg-neutral-200" />
        </div>

        <div className="flex flex-col gap-3">
          <button onClick={handleGoogle} className="w-full h-12 rounded-lg border border-neutral-300">
            Continue with Google
          </button>
          <button onClick={handleGuest} className="w-full h-12 rounded-lg border border-neutral-300 text-neutral-800">
            Continue as Guest
          </button>
        </div>

        <p className="mt-3 text-center text-xs text-neutral-500">
          Guest mode: 7-day trial • No login required
        </p>
      </div>
    </main>
  );
}