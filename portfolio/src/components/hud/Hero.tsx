import { FaculdadLogo, UnaSeal } from "./Logos";
import GisCompass from "./GisCompass";

const Hero = () => {
  return (
    <header className="relative w-full pt-8 pb-16 md:pt-10 md:pb-24 overflow-hidden">
      {/* Top bar */}
      <div className="container flex items-start justify-between mb-12 md:mb-20 animate-boot">
        <div className="flex items-center gap-4">
          <FaculdadLogo className="w-14 h-14 md:w-16 md:h-16 text-primary text-glow" />
          <div className="hidden sm:block border-l border-primary/30 pl-4">
            <div className="label-tag text-primary">FACULTAD</div>
            <div className="font-display text-[10px] md:text-xs text-foreground leading-tight">
              ESTADÍSTICA
              <br />E INFORMÁTICA
            </div>
          </div>
        </div>

        {/* Center status */}
        <div className="hidden lg:flex flex-col items-center gap-1">
          <GisCompass />
        </div>

        <div className="flex items-center gap-4">
          <div className="hidden sm:block border-r border-primary/30 pr-4 text-right">
            <div className="label-tag text-primary">UNIVERSIDAD</div>
            <div className="font-display text-[10px] md:text-xs text-foreground leading-tight">
              NACIONAL
              <br />
              DEL ALTIPLANO
            </div>
          </div>
          <UnaSeal className="w-14 h-14 md:w-16 md:h-16 text-foreground/90" />
        </div>
      </div>

      {/* Title block */}
      <div className="container relative">
        {/* coordinate lines */}
        <div className="absolute -left-4 top-1/2 -translate-y-1/2 hidden lg:block">
          <div className="terminal-text text-[10px] rotate-180 [writing-mode:vertical-rl]">
            LAT -15.8402° · LON -70.0219°
          </div>
        </div>
        <div className="absolute -right-4 top-1/2 -translate-y-1/2 hidden lg:block">
          <div className="terminal-text text-[10px] [writing-mode:vertical-rl]">
            ALT 3827m · ZONE 19L
          </div>
        </div>

        <div className="text-center animate-boot delay-300">
          <div className="label-tag mb-8">[ COURSE_MODULE // 2026-I ]</div>

          <h1 className="font-display font-bold text-foreground text-[10vw] md:text-[7.5vw] leading-[0.95] tracking-[0.04em] text-glow">
            ESTADÍSTICA
            <br />
            <span className="text-primary">ESPACIAL</span>
          </h1>

          <div className="mt-6 flex items-center justify-center gap-3 text-xs md:text-sm font-mono text-muted-foreground">
            <span className="h-px w-12 bg-primary/50" />
            <span className="uppercase tracking-[0.3em]">
              Ing. Fred Torres Cruz
            </span>
            <span className="h-px w-12 bg-primary/50" />
          </div>
        </div>

        {/* Identity Module */}
        <div className="mt-12 max-w-2xl mx-auto hud-panel hud-corner p-5 md:p-6 animate-boot delay-500">
          <div className="flex items-center justify-between border-b border-primary/30 pb-2 mb-3">
            <span className="label-tag text-primary">IDENTITY_MODULE</span>
            <div className="flex items-center gap-1.5">
              <span className="h-1.5 w-1.5 bg-secondary animate-flicker" />
              <span className="terminal-text text-[10px]">VERIFIED</span>
            </div>
          </div>
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <div>
              <div className="label-tag text-muted-foreground mb-1">
                AUTHOR_ID
              </div>
              <div className="font-mono text-secondary text-glow-lime text-sm md:text-base">
                [ VICTOR RAUL MAYE MAMANI ]
              </div>
            </div>
            <div className="sm:text-right">
              <div className="label-tag text-muted-foreground mb-1">
                SYSTEM_CODE
              </div>
              <div className="font-mono text-secondary text-glow-lime text-sm md:text-base">
                [ 217397 ]
              </div>
            </div>
          </div>
          <div className="mt-4 pt-3 border-t border-primary/20 grid grid-cols-3 gap-2 text-[11px] font-mono font-medium">
            <div>
              <span className="text-muted-foreground/80 uppercase text-[9px] block mb-0.5">CYCLE</span>
              <div className="text-primary">2026-I</div>
            </div>
            <div className="text-center">
              <span className="text-muted-foreground/80 uppercase text-[9px] block mb-0.5">UNITS</span>
              <div className="text-primary">02 / 02</div>
            </div>
            <div className="text-right">
              <span className="text-muted-foreground/80 uppercase text-[9px] block mb-0.5">UPTIME</span>
              <div className="text-primary animate-ticker">99.97%</div>
            </div>
          </div>
        </div>
      </div>
    </header>
  );
};

export default Hero;
