import { Component, Input, OnInit } from '@angular/core';
import { QuestionGrouping } from '../../../../models/questions.model';
import { AssessmentService } from '../../../../services/assessment.service';
import { ConfigService } from '../../../../services/config.service';
import { MaturityFilteringService } from '../../../../services/filtering/maturity-filtering/maturity-filtering.service';
import { MaturityService } from '../../../../services/maturity.service';

@Component({
  selector: 'app-grouping-block-cis',
  templateUrl: './grouping-block-cis.component.html'
})
export class GroupingBlockCisComponent implements OnInit {

  @Input('grouping') grouping: any;

  constructor(
    public assessSvc: AssessmentService,
    public maturityFilteringService: MaturityFilteringService,
    public matSvc: MaturityService,
    public configSvc: ConfigService
  ) { }

  ngOnInit(): void {
  }

}
