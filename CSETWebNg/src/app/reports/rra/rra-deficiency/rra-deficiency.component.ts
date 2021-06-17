import { Component, OnInit } from '@angular/core';
import { Title } from '@angular/platform-browser';
import { ConfigService } from '../../../services/config.service';
import { MaturityService } from '../../../services/maturity.service';
import { ReportAnalysisService } from '../../../services/report-analysis.service';
import { ReportService } from '../../../services/report.service';

@Component({
  selector: 'app-rra-deficiency',
  templateUrl: './rra-deficiency.component.html',
  styleUrls: ['../../reports.scss', '../../acet-reports.scss']
})
export class RraDeficiencyComponent implements OnInit {

  response: any;

  constructor(
    public analysisSvc: ReportAnalysisService,
      public reportSvc: ReportService,
      public configSvc: ConfigService,
      private titleService: Title,
      public maturitySvc: MaturityService
    ) { }
  
    ngOnInit() {
      this.titleService.setTitle("Deficiency Report - RRA");
  
      this.maturitySvc.getMaturityDeficiency("RRA").subscribe(
        (r: any) => {
          this.response = r;          
          //run through the deficiencies add them to three groups
          //then dump out three tables.  DeficiencesList

        },
        error => console.log('Deficiency Report Error: ' + (<Error>error).message)
      );
    }

    previous = 0; 
    shouldDisplay(next){
      if(next==this.previous){
        return false;
      }
      else{
        this.previous = next;
        return true;
      }
    }

    getStringLevel(levelNumber: number){
      //this should come from db eventually.
      var levelsList = {
        11:"Basic",
        12:"Intermediate",
        13:"Advanced"
      };
      return levelsList[levelNumber];
    }
}
