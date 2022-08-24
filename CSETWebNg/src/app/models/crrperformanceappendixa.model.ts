export interface CrrPerformanceAppendixA{
  TotalBarChart: string;
  CrrPerformanceLegend: string;
  DomainSummaryList: DomainSummary[];

}

export interface DomainSummary{
  DomainTitle:string;
  BarChart: string;
  MilHeatMapSvg1: string;
  MilHeatMapSvg2: string;
  MilHeatMapSvg3: string;
  MilHeatMapSvg4: string;
  MilHeatMapSvg5: string;
}
