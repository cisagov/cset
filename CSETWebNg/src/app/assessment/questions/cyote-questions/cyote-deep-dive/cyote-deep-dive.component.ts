////////////////////////////////
//
//   Copyright 2022 Battelle Energy Alliance, LLC
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
////////////////////////////////
import { AfterContentInit, Component, Inject, Input, OnInit } from '@angular/core';
import { Router, ActivatedRoute, ParamMap } from '@angular/router';
import {ArrayDataSource} from '@angular/cdk/collections';
import {FlatTreeControl} from '@angular/cdk/tree';

import { AssessmentService } from '../../../../services/assessment.service';
import { CdkDragDrop, moveItemInArray } from '@angular/cdk/drag-drop';
import { CyoteService } from '../../../../services/cyote.service';
import { CyoteObservable } from '../../../../models/cyote.model';
import { NumericDictionaryIteratee } from 'lodash';
import { MatDialog, MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';

  /** Flat node with expandable and level information */
  interface CyOTEFlatNode {
    expandable: boolean;
    question_title: string;
    question_text: string;
    mat_question_type: string;     
    isExpanded?: boolean;
    answer_Id: number;    
    answer_Text: string;
    comment: string;    
    free_Response_Answer: string;
    mat_Question_Id: number;
    mat_Question_Type: string;
    question_Level: number;    
    sequence: number;
    supplemental_Info: string;
  }
  
  export interface DialogData {
    htmlString:string;
  }

  @Component({
    selector: 'dialog-supplemental',
    templateUrl: './dialog-supplemental.html',
  })
  export class DialogCyOTEGuidance implements AfterContentInit {
  
    constructor(
      public dialogRef: MatDialogRef<DialogCyOTEGuidance>,
      @Inject(MAT_DIALOG_DATA) public data: DialogData) {
       
      }
    ngAfterContentInit(): void {
      this.dialogRef.updateSize('80vw','80vh');
    }
  
    onNoClick(): void {
      this.dialogRef.close();
    }
  
  }

@Component({
  selector: 'app-cyote-deep-dive',
  templateUrl: './cyote-deep-dive.component.html',
  styleUrls: ['../cyote-questions.component.scss']
})
export class CyoteDeepDiveComponent implements OnInit {

  @Input() anomaly: CyoteObservable;

  topQuestion;


  /**
   * 
   */
  constructor(
    private route: ActivatedRoute,
    public assessSvc: AssessmentService,
    public cyoteSvc: CyoteService,
    public dialog: MatDialog
  ) { }

  index = 0;

  /**
   * 
   */
  ngOnInit(): void {
    this.anomaly = this.cyoteSvc.anomalies[this.index];
    this.dataSource = new ArrayDataSource(this.anomaly.deepDiveQuestions);

    this.cyoteSvc.getQuestion(0).subscribe((x: any) => {
      console.log(x);
      this.topQuestion = x.question;
    });
  }

  setBlockAnswer(answer_Text){
    
  }

  /**
   * 
   */
  nextObservation() {
    if (this.index == this.cyoteSvc.anomalies.length - 1) {
      this.index = 0;
    } else {
      this.index++;
    }

    this.anomaly = this.cyoteSvc.anomalies[this.index];
    this.dataSource = new ArrayDataSource(this.anomaly.deepDiveQuestions);
  }

  /**
   * 
   */
  prevObservation() {
    if (this.index == 0) {
      this.index = this.cyoteSvc.anomalies.length - 1;
    } else {
      this.index--;
    }

    this.anomaly = this.cyoteSvc.anomalies[this.index];
    this.dataSource = new ArrayDataSource(this.anomaly.deepDiveQuestions);
  }

  treeControl = new FlatTreeControl<CyOTEFlatNode>(
    node => node.question_Level,
    node => node.expandable,
  );

  dataSource: ArrayDataSource<CyOTEFlatNode>;

  hasChild = (_: number, node: CyOTEFlatNode) => node.expandable;

  getParentNode(node: CyOTEFlatNode) {
    const nodeIndex = this.anomaly.deepDiveQuestions.indexOf(node);

    for (let i = nodeIndex - 1; i >= 0; i--) {      
      if (this.anomaly.deepDiveQuestions[i].question_Level === node.question_Level - 1) {
        return this.anomaly.deepDiveQuestions[i];
      }
    }

    return null;
  }

  shouldRender(node: CyOTEFlatNode) {
    let parent = this.getParentNode(node);
    while (parent) {
      if (!parent.isExpanded) {
        return false;
      }
      parent = this.getParentNode(parent);
    }
    return true;
  }

  /**
   * 
   */
  showSupplemental(node: CyOTEFlatNode) {
    // pop some kind of modal?
    
    const dialogRef = this.dialog.open(DialogCyOTEGuidance, {
      width: '500px',
      maxHeight: '80%',      
      data: {htmlString: node.supplemental_Info}
    });

    dialogRef.afterClosed().subscribe(result => {
      console.log('The dialog was closed');      
    });
  }
}
