import { Component, OnInit } from '@angular/core';
import { MaturityService } from '../../../../services/maturity.service';
import { MaturityQuestionResponse } from '../../../../models/questions.model';

@Component({
  selector: 'app-maturity-indicator-levels',
  templateUrl: './maturity-indicator-levels.component.html',
  styleUrls: ['./maturity-indicator-levels.component.scss']
})
export class MaturityIndicatorLevelsComponent implements OnInit {

  constructor(private maturitySvc: MaturityService) { }

  ngOnInit(): void {
    this.getQuestions();
  }

  getQuestions() {
    this.maturitySvc.getQuestionsList(false, true).subscribe((resp: MaturityQuestionResponse) => {

      this.maturitySvc.domains = resp.groupings.filter(x => x.groupingType == 'Domain');

      this.maturitySvc.getReferenceText('EDM').subscribe((resp: any[]) => {
        this.maturitySvc.ofc = resp;
      });
    });
  }

  findDomain(abbrev: string) {
    if (!this.maturitySvc.domains) {
      return null;
    }

    let domain = this.maturitySvc.domains.find(d => d.Abbreviation == abbrev);
    return domain;
  }

}
