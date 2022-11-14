import { Component, OnInit } from '@angular/core';
import { Title } from '@angular/platform-browser';
import { RraDataService } from '../../../services/rra-data.service';

@Component({
  selector: 'app-cpg-report',
  templateUrl: './cpg-report.component.html',
  styleUrls: ['./cpg-report.component.scss', '../../reports.scss']
})
export class CpgReportComponent implements OnInit {

  loading = false;

  assessmentName: string;
  assessmentDate: string;
  assessorName: string;

  /**
   * 
   */
  constructor(
    public rraDataSvc: RraDataService,
    public titleSvc: Title
  ) { }

  /**
   * 
   */
  ngOnInit(): void {
    this.titleSvc.setTitle("CPGs Report - CSET");

    this.rraDataSvc.getRRADetail().subscribe(resp => {
      console.log(resp);
    });
  }

}
