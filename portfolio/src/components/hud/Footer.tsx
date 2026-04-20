const Footer = () => {
  return (
    <footer className="relative border-t border-primary/20 mt-20">
      <div className="container py-10 grid grid-cols-1 md:grid-cols-3 gap-6 items-center">
        <div>
          <div className="label-tag text-primary mb-2">// END_OF_TRANSMISSION</div>
          <div className="font-display text-sm text-foreground">
            ESTADÍSTICA ESPACIAL · 2026-I
          </div>
          <div className="terminal-text text-[11px] mt-1">
            UNA — PUNO · FACULTAD DE ESTADÍSTICA E INFORMÁTICA
          </div>
        </div>

        <div className="text-center font-mono text-[10px] text-muted-foreground">
          <div className="flex items-center justify-center gap-2 mb-1">
            <span className="h-1.5 w-1.5 bg-secondary animate-flicker" />
            <span className="text-secondary">SIGNAL STABLE</span>
          </div>
          BUILD 2026.04.20 · SHA d8f2:9301:217397
        </div>

        <div className="md:text-right text-[11px] font-mono">
          <div className="text-muted-foreground">AUTHOR_ID</div>
          <div className="text-secondary text-glow-lime">VICTOR RAUL MAYE MAMANI</div>
          <div className="text-muted-foreground mt-1">CODE</div>
          <div className="text-secondary text-glow-lime">217397</div>
        </div>
      </div>
      <div className="h-1 w-full bg-[linear-gradient(90deg,transparent,hsl(var(--primary)/0.6),transparent)]" />
    </footer>
  );
};

export default Footer;
