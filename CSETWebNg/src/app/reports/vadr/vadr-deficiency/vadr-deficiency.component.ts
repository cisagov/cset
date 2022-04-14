import { Component, OnInit } from '@angular/core';
import { Title } from '@angular/platform-browser';
import { ConfigService } from '../../../services/config.service';
import { MaturityService } from '../../../services/maturity.service';
import { ReportAnalysisService } from '../../../services/report-analysis.service';
import { ReportService } from '../../../services/report.service';
//import { RraDataService } from '../../../services/rra-data.service';

@Component({
  selector: 'app-vadr-deficiency',
  templateUrl: './vadr-deficiency.component.html',
  styleUrls: ['../../reports.scss', '../../acet-reports.scss']
})
export class VadrDeficiencyComponent implements OnInit {

  response: any;

  colorSchemeRed = { domain: ['#DC3545'] };
  xAxisTicks = [0, 25, 50, 75, 100];

  answerDistribByGoal = [];
  topRankedGoals = [];

  constructor(
    public analysisSvc: ReportAnalysisService,
    public reportSvc: ReportService,
    public configSvc: ConfigService,
    private titleService: Title,
    public maturitySvc: MaturityService
  ) { }

  ngOnInit() {
    this.titleService.setTitle("Deficiency Report - VADR");

    this.maturitySvc.getMaturityDeficiency("VADR").subscribe(
      (r: any) => {
        this.response = r;   

        // remove any child questions - they are not Y/N
        this.response.deficienciesList = this.response.deficienciesList.filter(x => x.mat.parent_Question_Id == null);
        
        console.log(this.response);
      },
      error => console.log('Deficiency Report Error: ' + (<Error>error).message)
    );
  }


  previous = 0;
  shouldDisplay(next) {
    if (next == this.previous) {
      return false;
    }
    else {
      this.previous = next;
      return true;
    }
  }


}
