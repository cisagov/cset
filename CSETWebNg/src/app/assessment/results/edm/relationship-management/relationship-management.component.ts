import { Component, OnInit } from '@angular/core';
import { MaturityService } from '../../../../services/maturity.service';
import { MaturityQuestionResponse } from '../../../../models/questions.model';

@Component({
  selector: 'app-relationship-management',
  templateUrl: './relationship-management.component.html',
  styleUrls: ['./relationship-management.component.scss']
})
export class RelationshipManagementComponent implements OnInit {

  constructor(private maturitySvc: MaturityService) { }

  ngOnInit(): void {
    this.getQuestions();
  }

  getQuestions() {
    this.maturitySvc.getQuestionsList(false, true).subscribe((resp: MaturityQuestionResponse) => {

      this.maturitySvc.domains = resp.Groupings.filter(x => x.GroupingType == 'Domain');

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
