import { X, FileText, Github, Cpu, Calendar, Database, ExternalLink } from "lucide-react";
import { Task } from "@/data/units";
import { useEffect } from "react";

type Props = {
  task: Task | null;
  isOpen: boolean;
  onClose: () => void;
};

const ProjectModal = ({ task, isOpen, onClose }: Props) => {
  useEffect(() => {
    if (isOpen) {
      document.body.style.overflow = "hidden";
    } else {
      document.body.style.overflow = "unset";
    }
    return () => {
      document.body.style.overflow = "unset";
    };
  }, [isOpen]);

  if (!isOpen || !task) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 md:p-6 backdrop-blur-md bg-background/80 animate-in fade-in duration-300">
      <div 
        className="absolute inset-0 z-0" 
        onClick={onClose} 
      />
      
      <div className="relative z-10 w-full max-w-4xl max-h-[90vh] overflow-hidden hud-panel hud-corner flex flex-col animate-boot">
        {/* Header */}
        <div className="flex items-center justify-between p-4 md:p-6 border-b border-primary/30 bg-background/40">
          <div className="flex items-center gap-3">
            <span className="label-tag text-primary">{task.taskId}</span>
            <h2 className="font-display text-lg md:text-xl text-foreground text-glow uppercase tracking-wider">
              {task.title}
            </h2>
          </div>
          <button 
            onClick={onClose}
            className="p-2 rounded border border-primary/20 text-primary hover:bg-primary/20 transition-all hover:scale-105"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Content Body */}
        <div className="flex-1 overflow-y-auto p-4 md:p-8 custom-scrollbar">
          <div className="grid grid-cols-1 lg:grid-cols-5 gap-8">
            {/* Visual Column */}
            <div className="lg:col-span-3 space-y-6">
              <div className="relative aspect-video border border-primary/30 overflow-hidden bg-muted/20">
                {task.imageUrl ? (
                  <img 
                    src={task.imageUrl} 
                    alt={task.title} 
                    className="w-full h-full object-cover"
                  />
                ) : (
                  <div className="w-full h-full flex items-center justify-center text-primary/30">
                    <Database className="w-16 h-16 animate-pulse" />
                  </div>
                )}
                <div className="absolute inset-0 pointer-events-none border-[10px] border-primary/5" />
                <span className="absolute top-2 left-2 label-tag bg-background/60 px-1 font-mono text-[9px]">ENCODED_STREAM_V2</span>
              </div>

              <div className="hud-panel p-4 bg-primary/5 border-primary/10">
                <h4 className="label-tag text-primary mb-3">TECHNICAL_SPECIFICATION</h4>
                <p className="text-sm md:text-base text-muted-foreground font-mono leading-relaxed lowercase">
                  {task.description}
                </p>
              </div>
            </div>

            {/* Meta Column */}
            <div className="lg:col-span-2 space-y-6">
              <div className="space-y-4">
                <div className="flex items-center justify-between border-b border-primary/20 pb-2">
                  <div className="flex items-center gap-2 label-tag text-muted-foreground">
                    <Calendar className="w-3 h-3" /> DATE
                  </div>
                  <span className="font-mono text-sm text-foreground">{task.date}</span>
                </div>
                <div className="flex items-center justify-between border-b border-primary/20 pb-2">
                  <div className="flex items-center gap-2 label-tag text-muted-foreground">
                    <Cpu className="w-3 h-3" /> COMPUTE
                  </div>
                  <span className="font-mono text-sm text-secondary">{task.computeTime}</span>
                </div>
                <div className="flex items-center justify-between border-b border-primary/20 pb-2">
                  <div className="flex items-center gap-2 label-tag text-muted-foreground">
                    <Database className="w-3 h-3" /> SIZE
                  </div>
                  <span className="font-mono text-sm text-primary">{task.fileSize}</span>
                </div>
              </div>

              {task.stack && (
                <div className="space-y-3">
                  <h4 className="label-tag text-primary">PROJECT_STACK</h4>
                  <div className="flex flex-wrap gap-2">
                    {task.stack.map((tech) => (
                      <span 
                        key={tech}
                        className="px-2 py-1 text-[10px] font-mono border border-secondary/30 text-secondary bg-secondary/5"
                      >
                        {tech}
                      </span>
                    ))}
                  </div>
                </div>
              )}

              <div className="pt-6 space-y-3">
                <h4 className="label-tag text-primary">SECURE_LINKS</h4>
                <div className="grid grid-cols-1 gap-3">
                  {task.pdfUrl && (
                    <a
                      href={task.pdfUrl}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="flex items-center justify-between p-3 border border-primary/30 bg-primary/5 hover:bg-primary/20 transition-all group"
                    >
                      <div className="flex items-center gap-3">
                        <FileText className="w-5 h-5 text-primary" />
                        <span className="font-mono text-xs uppercase text-foreground">View Documentation</span>
                      </div>
                      <span className="text-primary group-hover:translate-x-1 transition-transform">→</span>
                    </a>
                  )}
                  {task.webUrl && (
                    <a
                      href={task.webUrl}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="flex items-center justify-between p-3 border border-accent/40 bg-accent/5 hover:bg-accent/20 transition-all group"
                    >
                      <div className="flex items-center gap-3">
                        <ExternalLink className="w-5 h-5 text-accent" />
                        <span className="font-mono text-xs uppercase text-foreground">Launch Dashboard</span>
                      </div>
                      <span className="text-accent group-hover:translate-x-1 transition-transform">→</span>
                    </a>
                  )}
                  {task.repoUrl && (
                    <a
                      href={task.repoUrl}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="flex items-center justify-between p-3 border border-secondary/30 bg-secondary/5 hover:bg-secondary/20 transition-all group"
                    >
                      <div className="flex items-center gap-3">
                        <Github className="w-5 h-5 text-secondary" />
                        <span className="font-mono text-xs uppercase text-foreground">Access Repository</span>
                      </div>
                      <span className="text-secondary group-hover:translate-x-1 transition-transform">→</span>
                    </a>
                  )}
                </div>
              </div>

              <div className="mt-8 flex items-center gap-2 justify-center">
                 <span className="h-2 w-2 rounded-full bg-secondary animate-flicker" />
                 <span className="label-tag text-secondary">INTEGRITY_VERIFIED</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default ProjectModal;
