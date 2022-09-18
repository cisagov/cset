import { Component, OnInit, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { AssessmentService } from '../../services/assessment.service';

@Component({
  selector: 'app-new-assessment-dialog',
  templateUrl: './new-assessment-dialog.component.html',
  styleUrls: ['./new-assessment-dialog.component.scss']
})
export class NewAssessmentDialogComponent implements OnInit {

  /**
   * The gallery item detail for this card
   */
  galleryItem: any;

  /**
   * 
   */
  constructor(
    @Inject(MAT_DIALOG_DATA) public data: any, 
    private dialog: MatDialogRef<NewAssessmentDialogComponent>,
    public assessSvc: AssessmentService
    ) { 
    this.galleryItem = data;
  }

  /**
   * 
   */
  ngOnInit(): void {
  }

  /**
   * 
   */
  launchAssessment() {
    this.dialog.close();
    this.assessSvc.newAssessmentGallery(this.galleryItem.gallery_Item_Id);
  }

  /**
   * 
   */
  close() {
    return this.dialog.close();
  }
}
