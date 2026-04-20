const TopoBackground = () => {
  return (
    <div className="pointer-events-none fixed inset-0 -z-10 overflow-hidden">
      {/* Vector topographic mesh */}
      <svg
        className="absolute inset-0 h-full w-full opacity-[0.18]"
        xmlns="http://www.w3.org/2000/svg"
        preserveAspectRatio="xMidYMid slice"
        viewBox="0 0 1600 1000"
      >
        <defs>
          <radialGradient id="topo-fade" cx="50%" cy="50%" r="60%">
            <stop offset="0%" stopColor="hsl(184 100% 50%)" stopOpacity="0.4" />
            <stop offset="100%" stopColor="hsl(184 100% 50%)" stopOpacity="0" />
          </radialGradient>
        </defs>
        <g fill="none" stroke="hsl(220 40% 35%)" strokeWidth="0.6">
          {Array.from({ length: 16 }).map((_, i) => {
            const r = 60 + i * 55;
            return (
              <ellipse
                key={`l-${i}`}
                cx="380"
                cy="520"
                rx={r}
                ry={r * 0.55}
                opacity={1 - i * 0.05}
              />
            );
          })}
          {Array.from({ length: 14 }).map((_, i) => {
            const r = 80 + i * 65;
            return (
              <ellipse
                key={`r-${i}`}
                cx="1240"
                cy="430"
                rx={r * 0.7}
                ry={r}
                opacity={1 - i * 0.06}
                transform={`rotate(28 1240 430)`}
              />
            );
          })}
        </g>
        <circle cx="800" cy="500" r="600" fill="url(#topo-fade)" />
      </svg>

      {/* Scanline overlay */}
      <div className="absolute inset-0 opacity-[0.04] [background:repeating-linear-gradient(0deg,hsl(var(--primary))_0_1px,transparent_1px_3px)]" />

      {/* Vignette */}
      <div className="absolute inset-0 [background:radial-gradient(ellipse_at_center,transparent_40%,hsl(var(--background))_100%)]" />
    </div>
  );
};

export default TopoBackground;
