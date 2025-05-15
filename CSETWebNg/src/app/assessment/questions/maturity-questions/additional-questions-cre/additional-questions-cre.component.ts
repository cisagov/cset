import { Component, OnInit } from '@angular/core';
import { MaturityService } from '../../../../services/maturity.service';

@Component({
  selector: 'app-additional-questions-cre',
  templateUrl: './additional-questions-cre.component.html',
  styleUrl: './additional-questions-cre.component.scss',
  standalone: false
})
export class AdditionalQuestionsCreComponent implements OnInit {

  domainSelected = true;
  milSelected = true;

  constructor(public maturitySvc: MaturityService) {}

  ngOnInit(): void {
    console.log(this.maturitySvc);
  }

  changeDomain(evt: any) {
    this.domainSelected = evt.target.checked;
  }

  changeMil(evt: any) {
    this.milSelected = evt.target.checked;
  }
}
