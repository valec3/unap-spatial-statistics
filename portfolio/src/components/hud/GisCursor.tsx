import { useEffect, useRef } from "react";

const GisCursor = () => {
  const cursorRef = useRef<HTMLDivElement>(null);
  const coordsRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const handleMouseMove = (e: MouseEvent) => {
      if (cursorRef.current) {
        cursorRef.current.style.transform = `translate3d(${e.clientX}px, ${e.clientY}px, 0)`;
      }
      if (coordsRef.current) {
        coordsRef.current.style.transform = `translate3d(${e.clientX}px, ${e.clientY}px, 0)`;
        coordsRef.current.innerText = `X: ${(e.clientX * 0.001).toFixed(4)} | Y: ${(e.clientY * 0.001).toFixed(4)}`;
      }
    };

    window.addEventListener("mousemove", handleMouseMove, { passive: true });
    return () => window.removeEventListener("mousemove", handleMouseMove);
  }, []);

  return (
    <div className="pointer-events-none fixed inset-0 z-[100] hidden lg:block">
      {/* Precision Frame - No-render direct DOM manipulation */}
      <div 
        ref={cursorRef}
        className="absolute h-8 w-8 -ml-4 -mt-4 border border-primary/40 rounded-full will-change-transform"
        style={{ mixBlendMode: 'difference' }}
      >
        <div className="absolute inset-0 flex items-center justify-center">
          <div className="h-0.5 w-0.5 bg-primary rounded-full shadow-[0_0_8px_hsl(var(--primary))]" />
        </div>
        <div className="absolute top-0 left-1/2 -translate-x-1/2 h-1.5 w-px bg-primary/60" />
        <div className="absolute bottom-0 left-1/2 -translate-x-1/2 h-1.5 w-px bg-primary/60" />
        <div className="absolute left-0 top-1/2 -translate-y-1/2 w-1.5 h-px bg-primary/60" />
        <div className="absolute right-0 top-1/2 -translate-y-1/2 w-1.5 h-px bg-primary/60" />
      </div>

      {/* Real-time Coords Box */}
      <div 
        ref={coordsRef}
        className="absolute pointer-events-none font-mono text-[9px] text-primary/60 whitespace-nowrap bg-background/40 px-1.5 py-0.5 border border-primary/10 ml-6 mt-6 will-change-transform"
      >
        X: 0.0000 | Y: 0.0000
      </div>
    </div>
  );
};

export default GisCursor;
