import { Component, Input, OnInit } from '@angular/core';
import { identity } from 'rxjs';
import { MaturityService } from '../../../../services/maturity.service';

@Component({
  selector: 'app-crr-heatmap',
  templateUrl: './crr-heatmap.component.html'
})
export class CrrHeatmapComponent implements OnInit {

  @Input()
  domainAbbrev: string;

  public milHeatmaps: MilSvg[] = [];


  /**
   * 
   * @param maturitySvc 
   */
  constructor(
    public maturitySvc: MaturityService
  ) {  }

  /**
   * 
   */
  ngOnInit(): void {
    if (!this.domainAbbrev) {
      return;
    }
    
    for (var i = 1; i <= 5; i++) {
      this.maturitySvc.getMilHeatmapWidget(this.domainAbbrev, "MIL-" + i).subscribe((svg: string) => {

        // parse the SVG and read the MIL value from the root element
        var p = new DOMParser();
        var x = p.parseFromString(svg, "text/xml");
        var id = x.documentElement.getAttribute("data-mil");

        this.milHeatmaps.push({ milId: id, 'svg': svg });
      });
    }
  }

  /**
   * 
   * @param i 
   * @returns 
   */
  show(i: string): string {
    if (!this.milHeatmaps) {
      return "";
    }

    const h = this.milHeatmaps.find(h => h.milId == i);
    if (!h) {
      return "";
    }
    
    return h.svg;
  }
}

/**
 * A helper class to keep track of SVGs and their corresponding MIL IDs
 */
export class MilSvg {
  public milId: string;
  public svg: string;
}
