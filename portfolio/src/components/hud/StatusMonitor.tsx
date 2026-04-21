type Props = {
  unitId: string;
  title: string;
  goals: string[];
  progressPercent?: number; // New
  period?: string; // New
};

const StatusMonitor = ({ unitId, title, goals, progressPercent = 0, period }: Props) => {
  return (
    <div className="hud-panel hud-corner p-6 md:p-8 relative">
      <div className="flex items-center justify-between border-b border-primary/30 pb-3 mb-5">
        <div className="flex items-center gap-3">
          <span className="h-2 w-2 rounded-full bg-secondary animate-pulse-ring" />
          <span className="label-tag text-primary">STATUS_MONITOR // {unitId}</span>
        </div>
        <div className="flex flex-col items-end">
          <span className="label-tag text-secondary">LEARNING_GOALS · ACTIVE</span>
          {period && (
            <span className="text-[10px] font-mono text-muted-foreground/80 uppercase mt-1">
              {period}
            </span>
          )}
        </div>
      </div>

      <h3 className="font-display text-xl md:text-2xl text-foreground mb-5 text-glow leading-snug">
        {title}
      </h3>

      <ul className="space-y-3.5">
        {goals.map((g, i) => (
          <li key={i} className="flex gap-3 items-start group">
            <span className="terminal-text shrink-0 mt-0.5">
              [{String(i + 1).padStart(2, "0")}]
            </span>
            <span className="text-secondary/95 font-mono text-[15px] leading-relaxed group-hover:text-secondary transition-colors">
              ▸ {g}
            </span>
          </li>
        ))}
      </ul>

      {/* Progress Section */}
      <div className="mt-8 pt-4 border-t border-primary/20">
        <div className="flex items-center justify-between mb-2 text-[10px] font-mono">
          <span className="text-muted-foreground">TOTAL_ADVANCE</span>
          <span className="text-primary">{progressPercent}%</span>
        </div>
        <div className="h-1.5 w-full bg-primary/10 border border-primary/20 overflow-hidden relative">
          <div 
            className="h-full bg-primary transition-all duration-1000 ease-out shadow-[0_0_10px_hsl(var(--primary))]"
            style={{ width: `${progressPercent}%` }}
          />
        </div>
        <div className="mt-3 flex items-center justify-between text-[10px] font-mono text-muted-foreground">
          <span>NODES: {goals.length}</span>
          <span className={`${progressPercent === 100 ? "text-secondary" : "text-primary"} animate-ticker uppercase`}>
            ● {progressPercent === 100 ? "Completed" : "In Progress"}
          </span>
        </div>
      </div>
    </div>
  );
};

export default StatusMonitor;
