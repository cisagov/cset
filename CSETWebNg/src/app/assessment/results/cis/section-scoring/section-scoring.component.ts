import { Component, OnInit } from '@angular/core';
import { CisService } from '../../../../services/cis.service';
import { MaturityService } from '../../../../services/maturity.service';

@Component({
  selector: 'app-section-scoring',
  templateUrl: './section-scoring.component.html'
})
export class SectionScoringComponent implements OnInit {
  
  baselineAssessmentName: string;
  myModel: any;
  loading:boolean = true;

  constructor(
    public maturitySvc: MaturityService,
    public cisSvc: CisService
  ) { }

  /**
   * 
   */
  ngOnInit(): void {
    this.cisSvc.getCisSectionScoring().subscribe((resp: any) => {
      this.myModel = resp.myModel;
      this.loading = false;
    });
  }

}
