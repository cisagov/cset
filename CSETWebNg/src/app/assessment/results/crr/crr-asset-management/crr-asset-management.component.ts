import { Component, OnInit } from '@angular/core';
import { MaturityQuestionResponse } from '../../../../models/questions.model';
import { ConfigService } from '../../../../services/config.service';
import { MaturityService } from '../../../../services/maturity.service';
import { ReportService } from '../../../../services/report.service';

@Component({
  selector: 'app-crr-asset-management',
  templateUrl: './crr-asset-management.component.html',
  styleUrls: ['../../../../reports/reports.scss']
})
export class CrrAssetManagementComponent implements OnInit {

  public domain: any;
  public svg = "";

  constructor(
    private maturitySvc: MaturityService,
    private reportSvc: ReportService,
    public configSvc: ConfigService
  ) { }

  /**
   * 
   */
  ngOnInit(): void {
    this.getQuestions();
    this.getHeatmap();
  }

  getQuestions() {
    this.maturitySvc.getQuestionsList(false, true).subscribe((resp: MaturityQuestionResponse) => {
      this.maturitySvc.domains = resp.groupings.filter(x => x.groupingType == 'Domain');

      this.maturitySvc.getReferenceText('CRR').subscribe((resp: any[]) => {
        this.maturitySvc.ofc = resp;
      });
    });
  }

  /**
   * 
   */
  getHeatmap() {
    this.maturitySvc.getMilHeatmapWidget("AM", "MIL-1").subscribe((svg: string) => {
      this.svg = svg;
    });
  }

  /**
   * 
   * @param abbrev 
   * @returns 
   */
  findDomain(abbrev: string) {
    if (!this.maturitySvc.domains) {
      return null;
    }

    let domain = this.maturitySvc.domains.find(d => d.abbreviation == abbrev);
    console.log(domain);
    return domain;
  }
}
