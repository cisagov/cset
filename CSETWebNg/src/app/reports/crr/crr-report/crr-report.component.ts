import { Component, OnInit } from '@angular/core';
import { CrrService } from './../../../services/crr.service';
import { CrrReportModel } from '../../../models/reports.model';
import { Title } from '@angular/platform-browser';

@Component({
  selector: 'app-crr-report',
  templateUrl: './crr-report.component.html',
  styleUrls: ['./crr-report.component.scss']
})
export class CrrReportComponent implements OnInit {

  crrModel: CrrReportModel;

  constructor(private crrSvc: CrrService, private titleSvc: Title) { }

  ngOnInit(): void {
    this.titleSvc.setTitle('CRR Report - CSET');
    this.crrSvc.getCrrModel().subscribe((data: CrrReportModel) => {

      data.structure.Model.Domain.forEach(d => {
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

      this.crrModel = data
      console.log(this.crrModel);
    },
    error => console.log('Error loading CRR report: ' + (<Error>error).message)
    );
  }

}
