import { FileText, Github } from "lucide-react";
import HeatmapThumb from "./HeatmapThumb";

type Props = {
  taskId: string;
  date: string;
  title: string;
  description: string;
  fileSize: string;
  computeTime: string;
  variant?: "heatmap" | "cluster" | "mesh" | "vector";
  master?: boolean;
  badge?: string;
  pdfUrl?: string; // Updated
  repoUrl?: string; // Updated
  imageUrl?: string;
  index?: number;
  onClick?: () => void;
};

const TaskTile = ({
  taskId,
  date,
  title,
  description,
  fileSize,
  computeTime,
  variant = "heatmap",
  master = false,
  badge,
  pdfUrl,
  repoUrl,
  imageUrl,
  index = 0,
  onClick,
}: Props) => {
  return (
    <div
      onClick={onClick}
      className={`group relative block scan-line transition-all duration-300 cursor-pointer ${
        master
          ? "hud-panel hud-master p-6 md:p-7"
          : "hud-panel hud-corner p-5 hover:-translate-y-1"
      }`}
      style={{ animationDelay: `${index * 60}ms` }}
    >
      {/* Hover metadata corners */}
      <span className="pointer-events-none absolute top-1.5 right-2 text-[10px] font-mono text-primary/0 group-hover:text-primary/90 transition-opacity">
        {fileSize}
      </span>
      <span className="pointer-events-none absolute bottom-1.5 left-2 text-[10px] font-mono text-primary/0 group-hover:text-primary/90 transition-opacity">
        Δt {computeTime}
      </span>

      {/* Metadata Header */}
      <div className="flex items-center justify-between mb-3">
        <span className="label-tag text-primary">{taskId}</span>
        <span className="label-tag text-muted-foreground">{date}</span>
      </div>

      {/* Visual Preview */}
      <div
        className={`relative border border-primary/20 mb-4 overflow-hidden ${
          master ? "h-60" : "h-48"
        }`}
      >
        {imageUrl ? (
          <img 
            src={imageUrl} 
            alt={title} 
            className="w-full h-full object-cover opacity-80 group-hover:opacity-100 transition-opacity"
          />
        ) : (
          <HeatmapThumb seed={index + 1} variant={variant} />
        )}
        <HeatmapThumb seed={index + 1} variant={variant} className={imageUrl ? "sr-only" : ""} />
        {/* corner ticks */}
        <span className="absolute top-1 left-1 h-1.5 w-1.5 border-t border-l border-primary" />
        <span className="absolute top-1 right-1 h-1.5 w-1.5 border-t border-r border-primary" />
        <span className="absolute bottom-1 left-1 h-1.5 w-1.5 border-b border-l border-primary" />
        <span className="absolute bottom-1 right-1 h-1.5 w-1.5 border-b border-r border-primary" />

        {badge && (
          <span className="absolute top-2 right-2 px-2 py-0.5 text-[9px] font-mono uppercase tracking-widest bg-primary/20 border border-primary text-primary text-glow">
            {badge}
          </span>
        )}
      </div>

      {/* Title */}
      <h4
        className={`font-display ${
          master ? "text-base md:text-lg" : "text-sm"
        } text-foreground mb-2 leading-snug uppercase`}
      >
        {title}
      </h4>

      <p className="text-sm md:text-[14px] text-muted-foreground/90 font-mono leading-relaxed mb-4">
        {description}
      </p>

      {/* Action Node */}
      <div className="flex items-center justify-between border-t border-primary/20 pt-3">
        <div className="flex items-center gap-2">
          <span className="h-1.5 w-1.5 bg-secondary animate-flicker" />
          <span className="terminal-text text-[10px]">READY</span>
        </div>
        
        <div className="flex items-center gap-2">
          {pdfUrl && (
            <a
              href={pdfUrl}
              target="_blank"
              rel="noopener noreferrer"
              className="p-1.5 rounded border border-primary/30 text-primary hover:bg-primary hover:text-primary-foreground hover:shadow-[var(--glow-cyan)] transition-all"
              title="Ver PDF"
            >
              <FileText className="w-4 h-4" />
            </a>
          )}
          {repoUrl && (
            <a
              href={repoUrl}
              target="_blank"
              rel="noopener noreferrer"
              className="p-1.5 rounded border border-secondary/30 text-secondary hover:bg-secondary hover:text-secondary-foreground hover:shadow-[var(--glow-lime)] transition-all"
              title="Ver Código"
            >
              <Github className="w-4 h-4" />
            </a>
          )}
        </div>
      </div>
    </div>
  );
};

export default TaskTile;
