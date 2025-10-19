import AuthGate from "@/components/auth-gate";
import { OnboardingFlow } from "@/Frontend/t-flash/app/page";

export default function Home() {
  return (
    <AuthGate>
      <OnboardingFlow />
    </AuthGate>
  );
}
