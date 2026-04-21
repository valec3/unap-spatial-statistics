import { memo } from "react";

const FormulaWatermark = memo(() => {
  return (
    <div className="pointer-events-none absolute inset-0 -z-5 overflow-hidden opacity-[0.03]">
      {/* Moran's I Formula */}
      <svg
        viewBox="0 0 400 100"
        className="absolute top-[15%] left-[5%] w-[400px] h-auto rotate-[-8deg]"
      >
        <text
          x="0"
          y="50"
          fill="currentColor"
          className="font-mono text-xs italic"
        >
          I = (n / W) * [ ΣΣ w_ij (z_i * z_j) / Σ (z_i)^2 ]
        </text>
        <text x="0" y="70" fill="currentColor" className="font-mono text-[8px] uppercase tracking-widest opacity-50">
          MORAN_INDEX_GLOBAL_COEFFICIENT
        </text>
      </svg>

      {/* LISA Formula */}
      <svg
        viewBox="0 0 300 80"
        className="absolute top-[60%] right-[3%] w-[300px] h-auto rotate-[6deg]"
      >
        <text
          x="0"
          y="40"
          fill="currentColor"
          className="font-mono text-xs italic"
        >
          I_i = z_i * Σ_j w_ij * z_j
        </text>
        <text x="0" y="55" fill="currentColor" className="font-mono text-[8px] uppercase tracking-widest opacity-50">
          LOCAL_INDICATORS_ASSOCIATION (LISA)
        </text>
      </svg>

      {/* Variogram Formula */}
      <svg
        viewBox="0 0 400 100"
        className="absolute bottom-[10%] left-[8%] w-[350px] h-auto rotate-[2deg]"
      >
        <text
          x="0"
          y="50"
          fill="currentColor"
          className="font-mono text-xs italic"
        >
          γ(h) = 1/2N(h) * Σ [z(x) - z(x+h)]^2
        </text>
        <text x="0" y="70" fill="currentColor" className="font-mono text-[8px] uppercase tracking-widest opacity-50">
          SEMI_VARIOGRAM_GEOSTATISTICAL_MODEL
        </text>
      </svg>

      {/* Grid Decals */}
      <div className="absolute top-1/4 right-[20%] font-mono text-[10px] text-primary/30 uppercase tracking-[0.4em] [writing-mode:vertical-rl]">
        SPATIAL_DEPENDENCY_PROTOCOL
      </div>
    </div>
  );
});

export default FormulaWatermark;
