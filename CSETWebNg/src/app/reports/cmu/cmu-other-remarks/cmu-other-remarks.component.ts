import { Component, OnInit } from '@angular/core';
import { AssessmentService } from '../../../services/assessment.service';

@Component({
  selector: 'app-cmu-other-remarks',
  templateUrl: './cmu-other-remarks.component.html',
  styleUrls: ['./cmu-other-remarks.component.scss']
})
export class CmuOtherRemarksComponent implements OnInit {
  remarks: string;

  constructor(
    private assessSvc: AssessmentService
  ) {}

  ngOnInit(): void {
    this.assessSvc.getOtherRemarks().subscribe((resp: any) => {
      this.remarks = resp;
    });
  }
}
