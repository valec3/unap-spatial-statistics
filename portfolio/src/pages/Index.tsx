import { useState, useMemo } from "react";
import TopoBackground from "@/components/hud/TopoBackground";
import BootSequence from "@/components/hud/BootSequence";
import Hero from "@/components/hud/Hero";
import UnitSection from "@/components/hud/UnitSection";
import Footer from "@/components/hud/Footer";
import FormulaWatermark from "@/components/hud/FormulaWatermark";
import GisCursor from "@/components/hud/GisCursor";
import { allUnits, Task } from "@/data/units";
import { Filter, LayoutGrid, Layers } from "lucide-react";
import { useEffect, Suspense, lazy } from "react";

// Performance: Lazy load heavy components
const ProjectModal = lazy(() => import("@/components/hud/ProjectModal"));

const Index = () => {
  const [booted, setBooted] = useState(false);
  const [activeFilter, setActiveFilter] = useState<"all" | "01" | "02">("all");
  const [selectedTask, setSelectedTask] = useState<Task | null>(null);

  const filteredUnits = useMemo(() => {
    if (activeFilter === "all") return allUnits;
    return allUnits.filter((u) => u.unitNumber === activeFilter);
  }, [activeFilter]);

  return (
    <>
      <BootSequence onDone={() => setBooted(true)} />
      <TopoBackground />
      <FormulaWatermark />

      <main className={booted ? "opacity-100" : "opacity-0 transition-opacity duration-1000"}>
        {/* Top status ticker */}
        <div className="border-b border-primary/20 bg-background/60 backdrop-blur-sm sticky top-0 z-40">
          <div className="container flex items-center justify-between py-2 text-[10px] font-mono">
            <div className="flex items-center gap-4 text-muted-foreground">
              <span className="text-primary animate-pulse">◈ GEOSPATIAL_INTEL_HUB</span>
              <span className="hidden md:inline">v2.6.2</span>
            </div>
            <div className="flex items-center gap-6">
               {/* Tactical Filters */}
               <div className="hidden sm:flex items-center gap-1 bg-primary/5 border border-primary/20 p-0.5 rounded">
                  <button 
                    onClick={() => setActiveFilter("all")}
                    className={`px-3 py-1 flex items-center gap-1.5 transition-all ${activeFilter === "all" ? "bg-primary text-primary-foreground" : "text-primary hover:bg-primary/10"}`}
                  >
                    <LayoutGrid className="w-3 h-3" /> <span className="uppercase">All</span>
                  </button>
                  <button 
                    onClick={() => setActiveFilter("01")}
                    className={`px-3 py-1 flex items-center gap-1.5 transition-all ${activeFilter === "01" ? "bg-primary text-primary-foreground" : "text-primary hover:bg-primary/10"}`}
                  >
                    <Layers className="w-3 h-3" /> <span className="uppercase">U01</span>
                  </button>
               </div>

              <div className="flex items-center gap-4">
                <span className="text-muted-foreground hidden lg:inline">
                  LAT -15.8402 · LON -70.0219
                </span>
                <span className="flex items-center gap-1.5 text-secondary">
                  <span className="h-1.5 w-1.5 bg-secondary animate-flicker" />
                  ONLINE
                </span>
              </div>
            </div>
          </div>
        </div>

        <Hero />

        {/* Mobile Filters */}
        <div className="sm:hidden container mt-8 flex justify-center">
            <div className="flex items-center gap-1 bg-primary/5 border border-primary/20 p-1 rounded-sm w-full max-w-xs">
                <button 
                  onClick={() => setActiveFilter("all")}
                  className={`flex-1 py-2 font-mono text-[10px] uppercase transition-all ${activeFilter === "all" ? "bg-primary text-primary-foreground" : "text-primary"}`}
                >
                  All
                </button>
                <button 
                  onClick={() => setActiveFilter("01")}
                  className={`flex-1 py-2 font-mono text-[10px] uppercase transition-all ${activeFilter === "01" ? "bg-primary text-primary-foreground" : "text-primary"}`}
                >
                  Unit 01
                </button>
            </div>
        </div>

        <div className="space-y-10">
          {filteredUnits.length > 0 ? (
            filteredUnits.map((unit) => (
              <UnitSection
                key={unit.unitNumber}
                {...unit}
                unitNumber={unit.unitNumber as "01" | "02"}
                onTaskClick={(task) => setSelectedTask(task)}
              />
            ))
          ) : (
            <div className="container py-20 text-center">
              <div className="label-tag text-primary animate-pulse inline-block p-4 border border-primary/20">
                [ ACCESS_DENIED // NO_NODES_FOUND_IN_THIS_SECTOR ]
              </div>
            </div>
          )}
        </div>

        <Footer />
        
        <Suspense fallback={null}>
          <ProjectModal 
            task={selectedTask} 
            isOpen={!!selectedTask} 
            onClose={() => setSelectedTask(null)} 
          />
        </Suspense>

        <GisCursor />
      </main>
    </>
  );
};

export default Index;
