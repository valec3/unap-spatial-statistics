type Props = {
  unitId: string;
  title: string;
  goals: string[];
};

const StatusMonitor = ({ unitId, title, goals }: Props) => {
  return (
    <div className="hud-panel hud-corner p-6 md:p-8 relative">
      <div className="flex items-center justify-between border-b border-primary/30 pb-3 mb-5">
        <div className="flex items-center gap-3">
          <span className="h-2 w-2 rounded-full bg-secondary animate-pulse-ring" />
          <span className="label-tag text-primary">STATUS_MONITOR // {unitId}</span>
        </div>
        <span className="label-tag text-secondary">LEARNING_GOALS · ACTIVE</span>
      </div>

      <h3 className="font-display text-xl md:text-2xl text-foreground mb-5 text-glow">
        {title}
      </h3>

      <ul className="space-y-2.5">
        {goals.map((g, i) => (
          <li key={i} className="flex gap-3 items-start group">
            <span className="terminal-text shrink-0 mt-0.5">
              [{String(i + 1).padStart(2, "0")}]
            </span>
            <span className="text-secondary/90 font-mono text-sm leading-relaxed group-hover:text-secondary transition-colors">
              ▸ {g}
            </span>
          </li>
        ))}
      </ul>

      <div className="mt-5 pt-3 border-t border-primary/20 flex items-center justify-between text-[10px] font-mono text-muted-foreground">
        <span>EXEC: {goals.length}/{goals.length}</span>
        <span className="text-secondary animate-ticker">● COMPLETED</span>
      </div>
    </div>
  );
};

export default StatusMonitor;
