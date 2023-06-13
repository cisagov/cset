import { Component, OnInit } from '@angular/core';
import { QuestionsNestedService } from '../../../../services/questions-nested.service';
import { MaturityService } from '../../../../services/maturity.service';

@Component({
  selector: 'app-sd-answer-summary',
  templateUrl: './sd-answer-summary.component.html',
  styleUrls: ['./sd-answer-summary.component.scss']
})
export class SdAnswerSummaryComponent implements OnInit {

  loading = true;
  domains: any[] = [];

  /**
   * 
   */
  constructor(
    public maturitySvc: MaturityService,
    public questionsNestedSvc: QuestionsNestedService
  ) { }

  /**
   * Get the "0" section (the top) of the questions structure.
   */
  ngOnInit(): void {
    this.questionsNestedSvc.getSection(0).subscribe((resp: any) => {
      this.domains.push(resp);
      this.loading = false;
    });
  }
}
