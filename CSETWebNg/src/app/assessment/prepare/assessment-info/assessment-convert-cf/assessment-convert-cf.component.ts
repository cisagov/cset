import { Component } from '@angular/core';
import { AssessmentService } from '../../../../services/assessment.service';

@Component({
  selector: 'app-assessment-convert-cf',
  templateUrl: './assessment-convert-cf.component.html'
})
export class AssessmentConvertCfComponent {

  constructor(
    private assessSvc: AssessmentService,
    private conversionSvc: ConversionService
    ) {

  }

  convert() {
    console.log('convert!');

    // Call an endpoint that handles conversions
    // The endpoint:
    //   1 - Adds a DETAILS_DEMOGRAPHICS record that says this used to be a limited CF 
    //   2 - Delete the MATURITY-SUBMODEL 'CF RRA' record
    //   3 - Swap out the AVAILABLE_SETS record for the full CSF record
    // 
    // Reload the assessment [AssessmentService.loadAssessment()]

    const assessmentId = this.assessSvc.assessment.id;

    this.conversionSvc.convertCfSub().subscribe(resp => {
      this.assessSvc.loadAssessment(assessmentId);
    });
  }
}
