type Props = { seed?: number; variant?: "heatmap" | "cluster" | "mesh" | "vector" };

const HeatmapThumb = ({ seed = 1, variant = "heatmap" }: Props) => {
  // deterministic pseudo-random
  const rand = (i: number) => {
    const x = Math.sin(seed * 9301 + i * 49297) * 233280;
    return x - Math.floor(x);
  };

  if (variant === "cluster") {
    return (
      <svg viewBox="0 0 100 60" className="w-full h-full">
        <rect width="100" height="60" fill="hsl(var(--hud-panel))" />
        {Array.from({ length: 40 }).map((_, i) => (
          <circle
            key={i}
            cx={rand(i) * 100}
            cy={rand(i + 99) * 60}
            r={1 + rand(i + 7) * 2}
            fill={`hsl(184 100% ${40 + rand(i) * 40}%)`}
            opacity={0.5 + rand(i + 3) * 0.5}
          />
        ))}
        <line x1="0" y1="30" x2="100" y2="30" stroke="hsl(var(--primary)/0.2)" strokeDasharray="1 2" />
        <line x1="50" y1="0" x2="50" y2="60" stroke="hsl(var(--primary)/0.2)" strokeDasharray="1 2" />
      </svg>
    );
  }

  if (variant === "mesh") {
    return (
      <svg viewBox="0 0 100 60" className="w-full h-full">
        <rect width="100" height="60" fill="hsl(var(--hud-panel))" />
        <g fill="none" stroke="hsl(var(--primary)/0.5)" strokeWidth="0.3">
          {Array.from({ length: 12 }).map((_, i) => (
            <path
              key={i}
              d={`M0 ${5 + i * 5} Q 25 ${5 + i * 5 + (rand(i) - 0.5) * 8} 50 ${
                5 + i * 5
              } T 100 ${5 + i * 5}`}
            />
          ))}
        </g>
      </svg>
    );
  }

  if (variant === "vector") {
    return (
      <svg viewBox="0 0 100 60" className="w-full h-full">
        <rect width="100" height="60" fill="hsl(var(--hud-panel))" />
        <g stroke="hsl(var(--secondary)/0.7)" strokeWidth="0.4" fill="none">
          {Array.from({ length: 60 }).map((_, i) => {
            const x = (i % 10) * 10 + 5;
            const y = Math.floor(i / 10) * 10 + 5;
            const a = rand(i) * Math.PI * 2;
            return (
              <line
                key={i}
                x1={x}
                y1={y}
                x2={x + Math.cos(a) * 3}
                y2={y + Math.sin(a) * 3}
              />
            );
          })}
        </g>
      </svg>
    );
  }

  // heatmap default
  return (
    <svg viewBox="0 0 100 60" className="w-full h-full">
      <rect width="100" height="60" fill="hsl(var(--hud-panel))" />
      {Array.from({ length: 10 }).map((_, y) =>
        Array.from({ length: 16 }).map((_, x) => {
          const v = rand(y * 16 + x);
          return (
            <rect
              key={`${x}-${y}`}
              x={x * 6.25}
              y={y * 6}
              width="6.25"
              height="6"
              fill={`hsl(${184 - v * 60} 100% ${20 + v * 50}%)`}
              opacity={0.2 + v * 0.8}
            />
          );
        })
      )}
    </svg>
  );
};

export default HeatmapThumb;
