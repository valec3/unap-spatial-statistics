import { memo } from "react";
import { Compass } from "lucide-react";

const GisCompass = memo(() => {
  return (
    <div className="relative w-24 h-24 md:w-32 md:h-32 flex items-center justify-center opacity-40 hover:opacity-100 transition-opacity duration-700">
      {/* Outer ring */}
      <div className="absolute inset-0 rounded-full border border-primary/20 animate-[spin_12s_linear_infinite]" />
      
      {/* Middle ring with degrees */}
      <div className="absolute inset-2 rounded-full border border-dashed border-primary/40 animate-[spin_10s_linear_infinite_reverse]" />
      
      {/* Crosshairs */}
      <div className="absolute inset-0 flex items-center justify-center">
        <div className="w-full h-px bg-primary/10" />
        <div className="h-full w-px bg-primary/10" />
      </div>

      {/* Compass Needle */}
      <div className="relative animate-pulse">
        <Compass className="w-8 h-8 md:w-10 md:h-10 text-primary" />
        <span className="absolute -top-6 left-1/2 -translate-x-1/2 font-mono text-[10px] text-primary font-bold">N</span>
        <span className="absolute -bottom-6 left-1/2 -translate-x-1/2 font-mono text-[8px] text-muted-foreground uppercase tracking-widest">Azm 19.3°</span>
      </div>

      {/* Mini coordinates */}
      <div className="absolute -right-8 top-1/2 -translate-y-1/2 space-y-1 hidden lg:block">
        <div className="text-[8px] font-mono text-primary/40 leading-none">SRS: EPSG:4326</div>
        <div className="text-[8px] font-mono text-primary/40 leading-none">DATUM: WGS84</div>
        <div className="text-[8px] font-mono text-primary/40 leading-none">UNIT: DEGREE</div>
      </div>
    </div>
  );
});

export default GisCompass;
