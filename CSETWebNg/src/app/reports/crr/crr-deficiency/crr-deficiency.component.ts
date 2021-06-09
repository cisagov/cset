import { Component, OnInit } from '@angular/core';
import { Title } from '@angular/platform-browser';
import { ConfigService } from '../../../services/config.service';
import { MaturityService } from '../../../services/maturity.service';
import { ReportAnalysisService } from '../../../services/report-analysis.service';
import { ReportService } from '../../../services/report.service';

@Component({
  selector: 'app-crr-deficiency',
  templateUrl: './crr-deficiency.component.html',
  styleUrls: ['../../reports.scss', '../../acet-reports.scss']
})
export class CrrDeficiencyComponent implements OnInit {

  response: any;

  constructor(
    public analysisSvc: ReportAnalysisService,
      public reportSvc: ReportService,
      public configSvc: ConfigService,
      private titleService: Title,
      public maturitySvc: MaturityService
    ) { }
  
    ngOnInit() {
      this.titleService.setTitle("Deficiency Report - CRR");
  
      this.maturitySvc.getMaturityDeficiency("CMMC").subscribe(
        (r: any) => {
          this.response = r;        
        },
        error => console.log('Deficiency Report Error: ' + (<Error>error).message)
      );
    }
}
