"use client";
import { supabase } from "./supabase";

export class AuthService {
  async signInWithEmail(email: string, password: string) {
    const { data, error } = await supabase.auth.signInWithPassword({ email, password });
    if (error) throw error;
    return data.user;
  }

  async signUpWithEmail(email: string, password: string) {
    const { data, error } = await supabase.auth.signUp({ email, password });
    if (error) throw error;

    // If no session yet (varies by project settings), just sign in.
    if (!data.session) {
      const r = await supabase.auth.signInWithPassword({ email, password });
      if (r.error) throw r.error;
      return r.data.user;
    }
    return data.user;
  }

  async signInWithGoogle() {
    const { error } = await supabase.auth.signInWithOAuth({
      provider: "google",
      options: { redirectTo: `${location.origin}/auth/callback` },
    });
    if (error) throw error;
  }

  async enableGuestMode() {
    localStorage.setItem("guest_mode", "1");
    await supabase.auth.signOut();
    return true;
  }

  async signOut() {
    await supabase.auth.signOut();
    localStorage.removeItem("guest_mode");
  }

  async getSession() {
    const { data } = await supabase.auth.getSession();
    return data.session;
  }
}