import { Component, OnInit } from '@angular/core';
import { ReportService } from '../../../../services/report.service';
import { AssessmentService } from '../../../../services/assessment.service';
import { CisService } from '../../../../services/cis.service';
import { HydroService } from '../../../../services/hydro.service';
import { MaturityService } from '../../../../services/maturity.service';
import { QuestionsService } from '../../../../services/questions.service';

@Component({
  selector: 'app-hydro-report-feasibility',
  templateUrl: './hydro-report-feasibility.component.html',
  styleUrls: ['./hydro-report-feasibility.component.scss']
})
export class HydroFeasibilityReportComponent implements OnInit {
  facilityName: string = 'My Facility';

  feasibilityData: any[] =[];

  feasibilityColors = {
    domain: ['#B4EDD2', '#7FB685', '#426A5A']
  };

  feasView: any[] = [500, 200];

  domainGroupNames: string[] = ['Management', 'Site and Service Control Security', 'Critical Operations', 'Dependencies'];

  loading: boolean = true;

  constructor(
    public reportSvc: ReportService,
    public assessSvc: AssessmentService,
    public questionsSvc: QuestionsService,
    public maturitySvc: MaturityService,
    public cisSvc: CisService,
    public hydroSvc: HydroService
  ) {}

  ngOnInit() {
    this.maturitySvc.getHydroResults().subscribe(
      (r: any) => {
        console.log(r)
        for (let i = 0; i < r.length; i++) {
          let domain = r[i];

          let feasibilityArray = [
            domain.feasibilityTotals.easy,
            domain.feasibilityTotals.medium,
            domain.feasibilityTotals.hard
          ];

          if (domain.parentSequence > i+1) {
            while (this.feasibilityData.length < domain.parentSequence-1) {
              this.feasibilityData.push([0,0,0]); // this fills the beginning domains (with no data) with blank data
            }
          }
         
          this.feasibilityData.push(feasibilityArray);
        }

        while (this.feasibilityData.length != this.domainGroupNames.length) {
          this.feasibilityData.push([0,0,0]); // this fills the beginning domains (with no data) with blank data
        }
        console.log(this.feasibilityData)

        this.loading = false;
      }
    )
  }
}
