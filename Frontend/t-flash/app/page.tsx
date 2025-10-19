import AuthGate from "@/components/auth-gate";
import { OnboardingFlow } from "@/components/onboarding-flow";

export default function Home() {
  return (
    <AuthGate>
      <OnboardingFlow />
    </AuthGate>
  );
}
