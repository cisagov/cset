import { Component, Input, OnInit } from '@angular/core';
import { CrrReportModel } from '../../../../models/reports.model';
import { MaturityService } from './../../../../services/maturity.service';

@Component({
  selector: 'app-crr-domain-detail',
  templateUrl: './crr-domain-detail.component.html',
  styleUrls: ['./../crr-report.component.scss']
})
export class CrrDomainDetailComponent implements OnInit {

  @Input() model: CrrReportModel;
  structureModel: any;

  constructor(private maturitySvc: MaturityService) { }

  ngOnInit(): void {
    this.maturitySvc.getStructure().subscribe((resp: any) => {
      console.log(resp);
      resp.Model.Domain.forEach(d => {
        d.Goal.forEach(g => {
          // The Question object needs to be an array for the template to work.
          // A singular question will be an object.  Create an array and push the question into it
          if (!Array.isArray(g.Question)) {
            var onlyChild = Object.assign({}, g.Question);
            g.Question = [];
            g.Question.push(onlyChild);
          }
        });
      });

      this.structureModel = resp;
    });
  }

}
