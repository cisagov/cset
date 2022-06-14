import { Component, Input, OnInit } from '@angular/core';
import { AssessmentService } from '../../../../../services/assessment.service';
import { ConfigService } from '../../../../../services/config.service';
import { MaturityService } from '../../../../../services/maturity.service';

@Component({
  selector: 'app-grouping-block-nested',
  templateUrl: './grouping-block-nested.component.html',
  styleUrls: ['./grouping-block-nested.component.scss']
})
export class GroupingBlockNestedComponent implements OnInit {

  @Input('grouping') grouping: any;

  title: string;

  constructor(
    public assessSvc: AssessmentService,
    public matSvc: MaturityService,
    public configSvc: ConfigService
  ) { }

  ngOnInit(): void {
    this.title = this.grouping.title;
    if (!!this.grouping.prefix) {
      this.title = this.grouping.prefix + '. ' + this.grouping.title;
    }
  }

}
