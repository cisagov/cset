import { Component, OnInit } from '@angular/core';
import { CrrService } from './../../../services/crr.service';

@Component({
  selector: 'app-crr-report',
  templateUrl: './crr-report.component.html',
  styleUrls: ['./crr-report.component.scss']
})
export class CrrReportComponent implements OnInit {

  crrModel: any;

  constructor(private crrSvc: CrrService) { }

  ngOnInit(): void {
    this.crrSvc.getCrrModel().subscribe((data: any) => {
      this.crrModel = data
    },
    error => console.log('Error loading CRR report: ' + (<Error>error).message)
    );
  }

}
