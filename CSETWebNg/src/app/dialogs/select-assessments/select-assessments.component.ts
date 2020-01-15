import { Component, OnInit } from '@angular/core';
import { AssessmentService } from '../../services/assessment.service';
import { AuthenticationService } from '../../services/authentication.service';
import { AggregationService } from '../../services/aggregation.service';
import { MatDialogRef } from '@angular/material';

interface UserAssessment {
  AssessmentId: number;
  AssessmentName: string;
  AssessmentCreatedDate: string;
  Selected: boolean;
}

@Component({
  selector: 'app-select-assessments',
  templateUrl: './select-assessments.component.html'
})
export class SelectAssessmentsComponent implements OnInit {

  assessments: UserAssessment[];

  /**
   * CTOR
   * @param assessmentSvc
   * @param authSvc
   */
  constructor(
    private dialog: MatDialogRef<SelectAssessmentsComponent>,
    private assessmentSvc: AssessmentService,
    private authSvc: AuthenticationService,
    public aggregSvc: AggregationService
  ) { }

  ngOnInit() {
    // get my assessment list
    this.getAssessmentsForUser();
  }

  getAssessmentsForUser() {
    this.assessmentSvc.getAssessments().subscribe((resp: UserAssessment[]) => {
      this.assessments = resp;

      this.aggregSvc.getAssessments().subscribe((resp2: any) => {
        resp2.Assessments.forEach(selectedAssess => {
          this.assessments.find(x => x.AssessmentId === selectedAssess.AssessmentId).Selected = true;
        });
      });
    },
      error =>
        console.log(
          "Unable to get Assessments for " +
          this.authSvc.email() +
          ": " +
          (<Error>error).message
        ));
  }

  /**
   * Call the API to manage connections between aggregation and assessment.
   * @param event
   * @param assessment
   */
  toggleSelection(event, assessment) {
    this.aggregSvc.saveAssessmentSelection(event.target.checked, assessment).subscribe();
  }

  /**
   *
   */
  close() {
    return this.dialog.close();
  }

}
