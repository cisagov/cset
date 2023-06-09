import { Component, OnInit } from '@angular/core';
import { QuestionsNestedService } from '../../../../services/questions-nested.service';
import { MaturityService } from '../../../../services/maturity.service';

@Component({
  selector: 'app-report-card-sd-results',
  templateUrl: './report-card-sd-results.component.html',
  styleUrls: ['./report-card-sd-results.component.scss']
})
export class ReportCardSdResultsComponent implements OnInit {

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
