import { Component, OnInit } from '@angular/core';
import { AssessmentService } from '../../../services/assessment.service';

@Component({
  selector: 'app-other-remarks',
  templateUrl: './other-remarks.component.html',
  styleUrls: ['./other-remarks.component.scss']
})
export class OtherRemarksComponent implements OnInit {

  remark: string;

  /**
   * 
   */
  constructor(
    private assessSvc: AssessmentService
  ) { }

  /**
   * 
   */
  ngOnInit(): void {
    this.assessSvc.getOtherRemarks().subscribe((resp: any) => {
      this.remark = resp;
    });
  }

  /**
   * 
   */
  saveRemark(evt: any) {
    this.assessSvc.saveOtherRemarks(this.remark).subscribe();
  }
}
