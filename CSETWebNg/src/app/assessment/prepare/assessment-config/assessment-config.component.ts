import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { AssessmentService } from '../../../services/assessment.service';
import { Navigation2Service } from '../../../services/navigation2.service';
import { MatDialog } from '@angular/material';
import { StandardService } from '../../../services/standard.service';

@Component({
  selector: 'app-assessment-config',
  templateUrl: './assessment-config.component.html'
})
export class AssessmentConfigComponent implements OnInit {
  expandedDesc: boolean[] = [];

  // the list of features that can be selected
  features: any = [
    {
      code: 'diagram',
      label: 'Diagram',
      description: 'A network diagram can be built in the tool. This will give you other questions.',
      expanded: false
    },
    {
      code: 'standards',
      label: 'Standards',
      description: 'If you want to use a standard, then use this.',
      expanded: false
    },
    {
      code: 'maturity',
      label: 'Maturity Model',
      description: 'You may want to use a maturity model.',
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
    this.features.forEach(f => {
      if (this.assessSvc.assessmentFeatures.indexOf(f.code) >= 0) {
        f.selected = true;
      }
    });
  }

  /**
   * Builds a list of selected features and post it to the server.
   */
  submit(feature, event: Event) {
    this.assessSvc.changeFeature(feature.code, event.srcElement.checked);
    this.standardSvc.refresh();
  }


  /**
   * Toggles the open/closed style of the description div.
   */
  toggleExpansion(std) {
    this.expandedDesc[std] = !this.expandedDesc[std];
  }
}
