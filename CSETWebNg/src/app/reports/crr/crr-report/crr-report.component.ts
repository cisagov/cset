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
      this.crrModel = data
      console.log(this.crrModel);
    },
    error => console.log('Error loading CRR report: ' + (<Error>error).message)
    );
  }

}
