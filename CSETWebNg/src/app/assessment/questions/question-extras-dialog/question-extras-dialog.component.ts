import { Component, Inject, Input, OnInit } from '@angular/core';
import { MatDialog, MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';

/**
 * This component is a wrapper so that question-extras can be 
 * hosted in a dialog.
 */
@Component({
  selector: 'app-question-extras-dialog',
  templateUrl: './question-extras-dialog.component.html',
  styleUrls: ['./question-extras-dialog.component.scss']
})
export class QuestionExtrasDialogComponent implements OnInit {

  q: any;

  constructor(
    private dialog: MatDialogRef<QuestionExtrasDialogComponent>,
    @Inject(MAT_DIALOG_DATA) public data: any
  ) { 
  }
  
  ngOnInit(): void {
    this.q = this.data.question;
    
    this.q.is_Component = false;
    this.q.is_Maturity = false;
  }


  /**
   *
   */
  close() {
    return this.dialog.close();
  }
}
