import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { AssessmentService } from '../../../services/assessment.service';
import { Navigation2Service } from '../../../services/navigation2.service';
import { MatDialog } from '@angular/material';
import { StandardService } from '../../../services/standard.service';
import { AssessmentDetail } from '../../../models/assessment-info.model';
import { NullishCoalescePipe } from '../../../helpers/nullish-coalesce.pipe';

@Component({
  selector: 'app-assessment-config',
  templateUrl: './assessment-config.component.html'
})
export class AssessmentConfigComponent implements OnInit {
  expandedDesc: boolean[] = [];

  // the list of features that can be selected
  features: any = [    
    {
      code: 'standard',
      label: 'Standard',
      description: 'This is where we will explain why using one or more standards might be the best option for this assessment.',
      expanded: false
    },
    {
      code: 'maturity',
      label: 'Maturity Model',
      description: 'This is where we will explain why a maturity model may be the best methodology for this assessment.',
      expanded: false
    },
    {
      code: 'diagram',
      label: 'Diagram',
      description: 'A network diagram can be built in the tool. This will give you other questions.',
      expanded: false
    }
  ];

  /**
   * Constructor.
   */
  constructor(
    private router: Router,
    private assessSvc: AssessmentService,
    private standardSvc: StandardService,
    public navSvc2: Navigation2Service,
    public dialog: MatDialog
  ) { }

  /**
   * 
   */
  ngOnInit() {
    this.assessSvc.getAssessmentDetail().subscribe(
      (data: AssessmentDetail) => {
        this.assessSvc.assessment = data;

        this.features.find(x => x.code === 'standard').selected = this.assessSvc.assessment.UseStandard;
        this.features.find(x => x.code === 'maturity').selected = this.assessSvc.assessment.UseMaturity;
        this.features.find(x => x.code === 'diagram').selected = this.assessSvc.assessment.UseDiagram;
      });
  }

  /**
   * Sets the selection of a feature and posts the assesment detail to the server.
   */
  submit(feature, event: Event) {
    const value = event.srcElement.checked;

    switch (feature.code) {
      case 'standard':
        this.assessSvc.assessment.UseStandard = value;
        break;
      case 'maturity':
        this.assessSvc.assessment.UseMaturity = value;
        break;
      case 'diagram':
        this.assessSvc.assessment.UseDiagram = value;
        break;
    }
    this.assessSvc.updateAssessmentDetails(this.assessSvc.assessment);

    // tell the standard service to refresh the nav tree
    this.standardSvc.refresh();
  }


  /**
   * Toggles the open/closed style of the description div.
   */
  toggleExpansion(std) {
    this.expandedDesc[std] = !this.expandedDesc[std];
  }
}
