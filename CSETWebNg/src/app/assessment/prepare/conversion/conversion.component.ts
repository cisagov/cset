import { Component } from '@angular/core';
import { AssessmentService } from '../../../services/assessment.service';

@Component({
  selector: 'app-conversion',
  templateUrl: './conversion.component.html',
  styleUrls: ['./conversion.component.scss']
})
export class ConversionComponent {

  constructor (
    public assessSvc: AssessmentService
  ) {}
}
