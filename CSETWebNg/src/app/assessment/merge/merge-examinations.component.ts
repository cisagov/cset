import { Component, Input, OnInit } from '@angular/core';
import { AssessmentService } from '../../services/assessment.service';
import { NCUAService } from '../../services/ncua.service';

@Component({
  selector: 'merge-examinations',
  templateUrl: './merge-examinations.component.html'
})
export class MergeExaminationsComponent implements OnInit {

  mergeList: any[] = [];
  listAsString: string = '';

  constructor(
    private ncuaSvc: NCUAService,
    private assessSvc: AssessmentService
  ) { }

  ngOnInit(): void {
    this.mergeList = this.ncuaSvc.assessmentsToMerge;
    this.listAsString = JSON.stringify(this.mergeList, null, 4); 
  }

  
  
}