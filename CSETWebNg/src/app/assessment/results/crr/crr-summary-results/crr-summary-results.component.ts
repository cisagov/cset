import { Component, OnInit, ViewChild } from '@angular/core';
import { CrrService } from '../../../../services/crr.service';

@Component({
  selector: 'app-crr-summary-results',
  templateUrl: './crr-summary-results.component.html'
})
export class CrrSummaryResultsComponent implements OnInit {

  public crrChart:any;

  constructor(private crrSvc: CrrService) { }
 
  ngOnInit(): void {
    this.crrSvc.getCrrHtml("_CrrPercentageOfPractices").subscribe((data:any) =>{
      this.crrChart = data.html;
    
    });
  }
}
