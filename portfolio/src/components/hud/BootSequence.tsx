import { useEffect, useState } from "react";

const lines = [
  "> INIT GEOSPATIAL_INTELLIGENCE_HUB v2.6.1",
  "> LOADING TOPO_VECTOR_MESH ............ OK",
  "> CALIBRATING GRID 50px x 50px ........ OK",
  "> AUTH AUTHOR_ID: VICTOR RAUL MAYE MAMANI",
  "> SYSTEM_CODE: 217397 .................. ACK",
  "> CHANNEL: ESTADISTICA_ESPACIAL/2026-I",
  "> STATUS: ONLINE",
];

const BootSequence = ({ onDone }: { onDone: () => void }) => {
  const [shown, setShown] = useState<string[]>([]);
  const [done, setDone] = useState(false);

  useEffect(() => {
    let i = 0;
    const id = setInterval(() => {
      setShown((s) => [...s, lines[i]]);
      i += 1;
      if (i >= lines.length) {
        clearInterval(id);
        setTimeout(() => {
          setDone(true);
          setTimeout(onDone, 500);
        }, 350);
      }
    }, 180);
    return () => clearInterval(id);
  }, [onDone]);

  return (
    <div
      className={`fixed inset-0 z-[100] flex items-center justify-center bg-background transition-opacity duration-500 ${
        done ? "opacity-0 pointer-events-none" : "opacity-100"
      }`}
    >
      <div className="w-[min(640px,90vw)] hud-panel hud-corner p-6">
        <div className="flex items-center justify-between border-b border-primary/30 pb-3 mb-4">
          <span className="label-tag text-primary">SYS://INITIALIZATION</span>
          <span className="label-tag text-secondary animate-ticker">● LIVE</span>
        </div>
        <div className="space-y-1.5 min-h-[180px]">
          {shown.map((l, idx) => (
            <div key={idx} className="terminal-text animate-boot">
              {l}
            </div>
          ))}
          <div className="inline-block h-3 w-2 bg-secondary animate-flicker align-middle" />
        </div>
      </div>
    </div>
  );
};

export default BootSequence;
