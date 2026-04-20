export const FaculdadLogo = ({ className = "" }: { className?: string }) => (
  <svg
    viewBox="0 0 64 64"
    className={className}
    fill="none"
    stroke="currentColor"
    strokeWidth="1.2"
  >
    <circle cx="32" cy="32" r="28" />
    <path d="M14 32 L32 14 L50 32 L32 50 Z" />
    <path d="M22 38 L26 26 L30 38" />
    <path d="M34 26 L34 38 M34 26 L40 26 M34 32 L38 32 M34 38 L40 38" />
    <path d="M14 44 L50 44" strokeDasharray="2 2" />
    <circle cx="32" cy="32" r="2" fill="currentColor" />
  </svg>
);

export const UnaSeal = ({ className = "" }: { className?: string }) => (
  <svg
    viewBox="0 0 64 64"
    className={className}
    fill="none"
    stroke="currentColor"
    strokeWidth="1"
  >
    <circle cx="32" cy="32" r="30" />
    <circle cx="32" cy="32" r="26" strokeDasharray="1 2" />
    <circle cx="32" cy="32" r="18" />
    <path d="M32 14 L36 28 L50 28 L38 36 L42 50 L32 42 L22 50 L26 36 L14 28 L28 28 Z" />
    <text
      x="32"
      y="60"
      textAnchor="middle"
      fontSize="5"
      fill="currentColor"
      stroke="none"
      fontFamily="JetBrains Mono"
      letterSpacing="1"
    >
      UNA · PUNO
    </text>
  </svg>
);
