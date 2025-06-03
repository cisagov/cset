import { Component, Input, OnInit } from '@angular/core';
import { MaturityService } from '../../../../services/maturity.service';

@Component({
  selector: 'app-cre-question-selector',
  templateUrl: './cre-question-selector.component.html',
  styleUrl: './cre-question-selector.component.scss',
  standalone: false
})
export class CreQuestionSelectorComponent implements OnInit {
  //@Input() groupings;

  selectedDomains: number[] = [];
  selectedSubdomains: number[] = [];

  domainSelected = true;
  milSelected = true;

  /**
   * 
   * @param maturitySvc 
   */
  constructor(public maturitySvc: MaturityService) {}

  /**
   * 
   */
  ngOnInit(): void {
   // console.log(this.maturitySvc);
    console.log('cre-question-control, selectableGroupings in service', this.maturitySvc.selectableGroupings);
  }

  changeDomain(gi: number, evt: any) {
    this.maturitySvc.selectableGroupings[gi].selected = evt.target.checked;
  }

  changeSubdomain(gi: number, sgi: number, evt: any) {
    this.maturitySvc.selectableGroupings[gi].subGroupings[sgi].selected = evt.target.checked;
  }
}
