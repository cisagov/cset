export interface CrrPerformanceAppendixA{
  totalBarChart: string;
  crrPerformanceLegend: string;
  domainSummaryList: DomainSummary[];

}

export interface DomainSummary{
  domainTitle:string;
  barChart: string;
  milHeatMapSvg1: string;
  milHeatMapSvg2: string;
  milHeatMapSvg3: string;
  milHeatMapSvg4: string;
  milHeatMapSvg5: string;
}
