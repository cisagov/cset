////////////////////////////////
//
//   Copyright 2025 Battelle Energy Alliance, LLC
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
////////////////////////////////
import { AfterViewInit, Component, ElementRef, Input, OnChanges, OnInit, SimpleChanges, ViewChild } from '@angular/core';


interface SeriesData {
  [key: string]: number;
}

interface BarData {
  name: string;
  series: SeriesData;
}

interface GroupData {
  group: string;
  bars: BarData[];
}

interface LegendItem {
  key: string;
  color: string;
}

interface ChartConfig {
  margin: { top: number; right: number; bottom: number; left: number };
  width: number;
  barHeight: number;
  barPadding: number;
  groupPadding: number;
  colors: string[];
}

interface TooltipData {
  barName: string;
  seriesKey: string;
  value: number;
  formattedValue: string;
  x: number;
  y: number;
}

interface TopBottom {
  top: number;
  bottom: number;
}


@Component({
  selector: 'app-cre-grouped-stacked-horizontal-chart',
  standalone: false,
  templateUrl: './cre-grouped-stacked-horizontal-chart.component.html',
  styleUrl: './cre-grouped-stacked-horizontal-chart.component.scss'
})
export class CreGroupedStackedHorizontalChartComponent implements OnInit, AfterViewInit, OnChanges {

  @Input() results: GroupData[] = [];
  @Input() title?: string;
  @Input() scheme: any;
  @Input() config?: Partial<ChartConfig>;
  @Input() borderRadius?: number = 0;
  @Input() dataLabelFormatting?: (value: number) => string;
  @Input() showValueInSegment = false;


  @ViewChild('chartSvg', { static: false }) chartSvg!: ElementRef<SVGSVGElement>;

  legendItems: LegendItem[] = [];
  tooltipVisible = false;
  tooltipData: TooltipData = {
    barName: '',
    seriesKey: '',
    value: 0,
    formattedValue: '',
    x: 0,
    y: 0
  };
  showTotalAtEndOfBar = false;


  // some default values in case not supplied by consumer
  private defaultConfig: ChartConfig = {
    margin: { top: 20, right: 120, bottom: 40, left: 120 },
    width: 900,
    barHeight: 35,
    barPadding: 8,
    groupPadding: 40,
    colors: [
      '#6366f1', '#8b5cf6', '#ec4899', '#f43f5e', '#f97316',
      '#eab308', '#84cc16', '#22c55e', '#14b8a6', '#06b6d4'
    ]
  };

  private chartConfig: ChartConfig;
  private seriesKeys: string[] = [];
  private colorScale: { [key: string]: string } = {};

  constructor(private elementRef: ElementRef) {
    this.chartConfig = { ...this.defaultConfig };
  }

  ngOnInit(): void {
    if (this.config) {
      this.chartConfig = { ...this.defaultConfig, ...this.config };
      if (this.scheme) {
        this.chartConfig.colors = this.scheme.domain;
      }
    }
  }

  ngAfterViewInit(): void {
    this.renderChart();
  }

  ngOnChanges(changes: SimpleChanges): void {
    if (changes['results'] && !changes['results'].firstChange) {
      this.renderChart();
    }
    if (changes['config'] && !changes['config'].firstChange) {
      this.chartConfig = { ...this.defaultConfig, ...this.config };
      this.renderChart();
    }
  }

  /**
   * 
   */
  private renderChart(): void {
    if (!this.chartSvg) return;

    if (!this.results) return;

    const svg = this.chartSvg.nativeElement;

    // Clear existing content
    while (svg.firstChild) {
      svg.removeChild(svg.firstChild);
    }

    // Extract series keys and setup colors
    this.extractSeriesKeys();
    this.setupColorScale();
    this.updateLegend();

    // Calculate dimensions
    const totalBars = this.results.reduce((acc, group) => acc + group.bars.length, 0);
    const height = this.chartConfig.barHeight * totalBars +
      this.chartConfig.barPadding * (totalBars - this.results.length) +
      this.chartConfig.groupPadding * this.results.length +
      this.chartConfig.margin.top + this.chartConfig.margin.bottom + 50;

    const innerWidth = this.chartConfig.width - this.chartConfig.margin.left - this.chartConfig.margin.right;
    const innerHeight = height - this.chartConfig.margin.top - this.chartConfig.margin.bottom;

    // Set SVG dimensions
    svg.setAttribute('width', this.chartConfig.width.toString());
    svg.setAttribute('height', height.toString());
    svg.setAttribute('viewBox', `0 0 ${this.chartConfig.width} ${height}`);

    // Calculate max value for scale
    const maxValue = this.calculateMaxValue();
    const xScale = (value: number): number => (value / maxValue) * innerWidth;

    // Draw chart
    this.drawXAxis(svg, innerWidth, height, maxValue);
    const topBottom = this.drawGroups(svg, xScale, maxValue, innerWidth, height);

    // Now that bars have been drawn, adjust some things
    this.transformToTrueSize(svg, topBottom);
  }

  /**
   * 
   */
  private extractSeriesKeys(): void {
    const keysSet = new Set<string>();
    this.results?.forEach(group => {
      group.bars.forEach(bar => {
        Object.keys(bar.series).forEach(key => keysSet.add(key));
      });
    });
    this.seriesKeys = Array.from(keysSet);
  }

  /**
   * 
   */
  private setupColorScale(): void {
    this.colorScale = {};
    this.seriesKeys.forEach((key, index) => {
      this.colorScale[key] = this.chartConfig.colors[index % this.chartConfig.colors.length];
    });
  }

  /**
   * 
   */
  private updateLegend(): void {
    this.legendItems = this.seriesKeys.map(key => ({
      key,
      color: this.colorScale[key]
    }));
  }

  /**
   * 
   */
  private calculateMaxValue(): number {
    return Math.max(...this.results.flatMap(group =>
      group.bars.map(bar =>
        Object.values(bar.series).reduce((a, b) => a + b, 0)
      )
    ));
  }

  /**
   * Draws all of the groups with their bars.
   */
  private drawGroups(svg: SVGSVGElement, xScale: (value: number) => number,
    maxValue: number, innerWidth: number, height: number): TopBottom {
    let firstBarTopY = 0;

    let yOffset = this.chartConfig.margin.top;

    let lastBarBottomY = yOffset;

    this.results.forEach((group, groupIndex) => {
      // Group label
      const groupLabel = this.createTextElement(
        0,
        yOffset + 15,
        group.group,
        'group-label',
        'start'
      );
      svg.appendChild(groupLabel);

      yOffset += 25;

      // Draw bars in group
      group.bars.forEach((bar, barIndex) => {
        // hang onto the y value of the top bar
        if (groupIndex == 0 && barIndex == 0) {
          firstBarTopY = yOffset;
        }

        this.drawBar(svg, bar, yOffset, xScale);

        yOffset += this.chartConfig.barHeight + this.chartConfig.barPadding;

        lastBarBottomY = yOffset + this.chartConfig.barHeight;
      });

      yOffset += this.chartConfig.groupPadding;
    });

    return { top: firstBarTopY, bottom: lastBarBottomY };
  }

  /**
   * 
   */
  private drawBar(svg: SVGSVGElement, bar: BarData, yOffset: number,
    xScale: (value: number) => number): void {
    // Bar label
    const barLabel = this.createTextElement(
      this.chartConfig.margin.left - 10,
      yOffset + this.chartConfig.barHeight / 2 + 5,
      bar.name,
      'bar-label',
      'end'
    );
    svg.appendChild(barLabel);

    // Draw stacked segments
    let xOffset = this.chartConfig.margin.left;

    this.seriesKeys.forEach(key => {
      const value = bar.series[key] || 0;
      if (value > 0) {
        const segmentWidth = xScale(value);

        // Create segment rectangle
        const rect = this.createRectElement(
          xOffset,
          yOffset,
          segmentWidth,
          this.chartConfig.barHeight,
          this.colorScale[key]
        );

        // Add hover handlers
        this.addHoverHandlers(rect, bar.name, key, value);
        svg.appendChild(rect);

        // apply formatting callback if specified
        let v = value.toString();
        if (this.dataLabelFormatting) {
          v = this.dataLabelFormatting(value);
        }

        // Add value label if segment is wide enough
        if (this.showValueInSegment && segmentWidth > 30) {
          const valueLabel = this.createTextElement(
            xOffset + segmentWidth / 2,
            yOffset + this.chartConfig.barHeight / 2 + 5,
            v,
            'value-label',
            'middle'
          );

          svg.appendChild(valueLabel);
        }

        xOffset += segmentWidth;
      }
    });

    // Total value at the end
    if (this.showTotalAtEndOfBar) {
      const total = Object.values(bar.series).reduce((a, b) => a + b, 0);
      const totalLabel = this.createTextElement(
        xOffset + 10,
        yOffset + this.chartConfig.barHeight / 2 + 5,
        total.toString(),
        'total-label',
        'start'
      );
      svg.appendChild(totalLabel);
    }
  }

  /**
   * 
   */
  private drawXAxis(svg: SVGSVGElement, innerWidth: number, height: number, maxValue: number): void {
    // Main axis line
    const xAxis = this.createLineElement(
      this.chartConfig.margin.left,
      height - this.chartConfig.margin.bottom,
      this.chartConfig.width - this.chartConfig.margin.right,
      height - this.chartConfig.margin.bottom,
      'axis-line'
    );

    // don't draw a line for the x-axis
    //svg.appendChild(xAxis);


    // Add ticks and labels
    const xTicks = [0, 0.2, 0.4, 0.6, 0.8, 1];
    xTicks.forEach(tick => {
      const xPos = this.chartConfig.margin.left + tick * innerWidth;
      const tickValue = Math.round(tick * maxValue);

      let tickLineTop = height - this.chartConfig.margin.bottom;
      tickLineTop = 0;

      // Tick line
      const tickLine = this.createLineElement(
        xPos,
        tickLineTop,
        xPos,
        height - this.chartConfig.margin.bottom + 5,
        'axis-line'
      );

      svg.appendChild(tickLine);

      let tickFormatted = tickValue.toString();

      // apply formatting to tick
      if (this.dataLabelFormatting) {
        tickFormatted = this.dataLabelFormatting(tickValue);
      }


      // Tick label
      const tickLabel = this.createTextElement(
        xPos,
        height - this.chartConfig.margin.bottom + 20,
        tickFormatted,
        'tick-label',
        'middle'
      );
      svg.appendChild(tickLabel);
    });
  }

  private createTextElement(x: number, y: number, text: string,
    className: string, anchor: string): SVGTextElement {
    const element = document.createElementNS('http://www.w3.org/2000/svg', 'text');
    element.setAttribute('x', x.toString());
    element.setAttribute('y', y.toString());
    element.setAttribute('text-anchor', anchor);
    element.setAttribute('class', className);
    element.textContent = text;
    return element;
  }

  private createRectElement(x: number, y: number, width: number,
    height: number, fill: string): SVGRectElement {
    const rect = document.createElementNS('http://www.w3.org/2000/svg', 'rect');
    rect.setAttribute('x', x.toString());
    rect.setAttribute('y', y.toString());
    rect.setAttribute('width', width.toString());
    rect.setAttribute('height', height.toString());
    rect.setAttribute('fill', fill);
    rect.setAttribute('class', 'bar-segment');
    rect.setAttribute('rx', this.borderRadius != null ? this.borderRadius.toString() : '0');
    return rect;
  }

  private createLineElement(x1: number, y1: number, x2: number,
    y2: number, className: string): SVGLineElement {
    const line = document.createElementNS('http://www.w3.org/2000/svg', 'line');
    line.setAttribute('x1', x1.toString());
    line.setAttribute('y1', y1.toString());
    line.setAttribute('x2', x2.toString());
    line.setAttribute('y2', y2.toString());
    line.setAttribute('class', className);
    return line;
  }

  /**
   * Reposition things based on where the bars ended up getting rendered
   */
  private transformToTrueSize(svg: SVGSVGElement, args: TopBottom) {
    // reposition the gridlines
    const gridlines = svg.getElementsByClassName('axis-line');
    Array.from(gridlines).forEach(line => {
      line.setAttribute('y1', args.top.toString());
      line.setAttribute('y2', (args.bottom - 30).toString());
    });

    // reposition the ticks
    const ticks = svg.getElementsByClassName('tick-label');
    Array.from(ticks).forEach(tick => {
      tick.setAttribute("y", (args.bottom - 10).toString());
    });

    // reevaluate height
    const newHeight = args.bottom;
    svg.setAttribute('height', newHeight.toString());
    svg.setAttribute('viewBox', `0 0 ${this.chartConfig.width} ${newHeight}`);
  }

  /**
   * 
   */
  private addHoverHandlers(element: SVGRectElement, barName: string,
    seriesKey: string, value: number): void {
    element.addEventListener('mouseenter', (event: MouseEvent) => {
      const rect = (event.currentTarget as Element).getBoundingClientRect();
      const centerX = rect.left + (rect.width / 2);
      const topY = rect.top - 10;

      this.showTooltip(barName, seriesKey, value, centerX, topY);
    });

    element.addEventListener('mouseleave', () => {
      this.hideTooltip();
    });
  }

  private showTooltip(barName: string, seriesKey: string, value: number, x: number, y: number): void {
    // apply formatting callback if specified
    let formattedValue: string = value.toString();
    if (this.dataLabelFormatting) {
      formattedValue = this.dataLabelFormatting(value);
    }

    this.tooltipData = { barName, seriesKey, value, formattedValue, x, y };
    this.tooltipVisible = true;
  }

  private hideTooltip(): void {
    this.tooltipVisible = false;
  }
}
