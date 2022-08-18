import { Component, Input, OnChanges} from '@angular/core';
import { CrrReportModel } from '../../../../models/reports.model';

@Component({
  selector: 'app-crr-domain-detail',
  templateUrl: './crr-domain-detail.component.html',
  styleUrls: ['./../crr-report.component.scss']
})
export class CrrDomainDetailComponent implements OnChanges {

  @Input() model: CrrReportModel;

  constructor() { }

  ngOnChanges(): void {
  }

}
