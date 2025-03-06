import { Component, OnInit } from '@angular/core';
import { AssessmentService } from '../../../../services/assessment.service';
import { CisService } from '../../../../services/cis.service';
import { HydroService } from '../../../../services/hydro.service';
import { MaturityService } from '../../../../services/maturity.service';
import { QuestionsService } from '../../../../services/questions.service';
import { ReportService } from '../../../../services/report.service';

@Component({
    selector: 'app-hydro-impact-category',
    templateUrl: './hydro-impact-category.component.html',
    styleUrls: ['./hydro-impact-category.component.scss'],
    standalone: false
})
export class HydroImpactCategoryComponent implements OnInit {
  facilityName: string = 'My Facility';

  impactData: any[] =[];

  impactColors = {
    domain: ['#67B7DC','#6794DC','#6771DC','#8067DC'] //econ, envi, oper, safe
  };

  domainGroupNames: string[] = ['Management', 'Site and Service Control Security', 'Critical Operations', 'Dependencies'];
  view: any[] = [500, 300];
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

          let impactArray = [
            domain.impactTotals.economic,
            domain.impactTotals.environmental,
            domain.impactTotals.operational,
            domain.impactTotals.safety
          ];

          if (domain.parentSequence > i+1) {
            while (this.impactData.length < domain.parentSequence-1) {
              this.impactData.push([0,0,0,0]); // this fills the beginning domains (with no data) with blank data
            }
          }
         
          this.impactData.push(impactArray);
        }

        while (this.impactData.length != this.domainGroupNames.length) {
          this.impactData.push([0,0,0,0]); // this fills the rest of impactData with blank data
        }
        console.log(this.impactData)

        this.loading = false;
      }
    )
  }
}
