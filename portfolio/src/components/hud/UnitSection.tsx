import StatusMonitor from "./StatusMonitor";
import TaskTile from "./TaskTile";

type Task = {
  taskId: string;
  date: string;
  title: string;
  description: string;
  fileSize: string;
  computeTime: string;
  variant?: "heatmap" | "cluster" | "mesh" | "vector";
  master?: boolean;
  badge?: string;
  pdfUrl?: string;
  repoUrl?: string;
};

type Props = {
  unitNumber: "01" | "02";
  unitTitle: string;
  monitorTitle: string;
  goals: string[];
  tasks: Task[];
  article: Task;
  period?: string; // New
  progressPercent?: number; // New
};

const UnitSection = ({
  unitNumber,
  unitTitle,
  monitorTitle,
  goals,
  tasks,
  article,
  period,
  progressPercent,
}: Props) => {
  return (
    <section className="relative py-20 md:py-28">
      {/* Watermark */}
      <div
        aria-hidden
        className="pointer-events-none absolute inset-0 flex items-center justify-center overflow-hidden"
      >
        <span className="font-display font-bold text-[28vw] md:text-[22vw] leading-none text-primary opacity-[0.04] select-none whitespace-nowrap">
          UNIDAD {unitNumber}
        </span>
      </div>

      <div className="container relative">
        {/* Section header */}
        <div className="flex flex-col md:flex-row md:items-end md:justify-between gap-4 mb-10">
          <div>
            <div className="flex items-center gap-3 mb-2">
              <span className="label-tag text-primary">SECTION_{unitNumber}</span>
              <span className="h-px w-16 bg-primary/40" />
              <span className="label-tag text-secondary">TRABAJOS_ENCARGADOS</span>
            </div>
            <h2 className="font-display text-3xl md:text-5xl text-foreground text-glow">
              UNIDAD <span className="text-primary">{unitNumber}</span>
              <span className="text-muted-foreground"> // </span>
              <span className="text-foreground/90">{unitTitle}</span>
            </h2>
          </div>
          <div className="hud-panel px-4 py-2 flex items-center gap-3">
            <span className="terminal-text text-[10px]">MATRIX</span>
            <span className="font-mono text-primary text-sm">
              {tasks.length + 1} NODES
            </span>
          </div>
        </div>

        {/* Status Monitor */}
        <div className="mb-10 animate-fade-in">
          <StatusMonitor 
            unitId={`U-${unitNumber}`} 
            title={monitorTitle} 
            goals={goals} 
            period={period}
            progressPercent={progressPercent}
          />
        </div>

        {/* Master Article */}
        <div className="mb-8">
          <TaskTile {...article} master badge={article.badge ?? "MASTER NODE"} />
        </div>

        {/* Task Matrix */}
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-5 md:gap-6">
          {tasks.map((t, i) => (
            <TaskTile key={t.taskId} {...t} index={i} />
          ))}
        </div>
      </div>
    </section>
  );
};

export default UnitSection;
