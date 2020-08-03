import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { AssessmentService } from '../../../services/assessment.service';
import { Navigation2Service } from '../../../services/navigation2.service';
import { MatDialog } from '@angular/material';

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
    public navSvc2: Navigation2Service,
    public dialog: MatDialog
  ) { }

  /**
   * 
   */
  ngOnInit() {
  }

  /**
   * Builds a list of selected features and post it to the server.
   */
  submit(standard, event: Event) {
    // this.assessSvc
    // .postSelections(selectedStandards)
    // .subscribe((counts: QuestionRequirementCounts) => {
    //   this.standards.QuestionCount = counts.QuestionCount;
    //   this.standards.RequirementCount = counts.RequirementCount;
    // });
  }


  /**
   * Toggles the open/closed style of the description div.
   */
  toggleExpansion(std) {
    this.expandedDesc[std] = !this.expandedDesc[std];
  }
}
