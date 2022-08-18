import { Component, OnInit, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';

@Component({
  selector: 'app-new-assessment-dialog',
  templateUrl: './new-assessment-dialog.component.html',
  styleUrls: ['./new-assessment-dialog.component.scss']
})
export class NewAssessmentDialogComponent implements OnInit {

  constructor(@Inject(MAT_DIALOG_DATA) public data: any, private dialog: MatDialogRef<NewAssessmentDialogComponent>) { }

  ngOnInit(): void {
  }

  close() {
    return this.dialog.close();
  }
}
