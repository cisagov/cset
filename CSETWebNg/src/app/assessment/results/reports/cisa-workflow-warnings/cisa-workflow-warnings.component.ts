import { Component, Input } from '@angular/core';
import { TranslocoService } from '@jsverse/transloco';

/**
 * A warning block that displays when the user is in CISA Assessor Workflow mode and 
 * one or more of the required fields are not complete.
 */
@Component({
    selector: 'app-cisa-workflow-warnings',
    templateUrl: './cisa-workflow-warnings.component.html',
    standalone: false
})
export class CisaWorkflowWarningsComponent {

  @Input()
  invalidFields: any[];

  constructor(
    public tSvc: TranslocoService
  ) {}
}
