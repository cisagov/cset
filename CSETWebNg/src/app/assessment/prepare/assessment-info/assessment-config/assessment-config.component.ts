import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { MatDialog } from '@angular/material/dialog';
import { AssessmentService } from '../../../../services/assessment.service';
import { StandardService } from '../../../../services/standard.service';
import { AssessmentDetail } from '../../../../models/assessment-info.model';
import { NavigationService } from '../../../../services/navigation.service';
import { ConfigService } from '../../../../services/config.service';

@Component({
  selector: 'app-assessment-config',
  templateUrl: './assessment-config.component.html'
})
export class AssessmentConfigComponent implements OnInit {
  expandedDesc: boolean[] = [];

  // the list of features that can be selected
  features: any = [
    {
      code: 'maturity',
      label: 'Maturity Model',
      description: 'A maturity model is a formal measurement used by an organization to gauge and improve its programs and processes. Maturity models are intended to measure the degree to which an organization has institutionalized its cybersecurity practices. Implementing process maturity within an organization will ensure that practices are consistent, repeatable, and constantly being improved.',
      expanded: false
    },
    {
      code: 'standard',
      label: 'Standard',
      description: 'A CSET cybersecurity assessment examines your cybersecurity posture against a specific standard. The assessment tests your security controls and measures how they stack up against known vulnerabilities.',
      expanded: false
    },
    {
      code: 'diagram',
      label: 'Network Diagram',
      description: 'A network diagram is a visual representation of a computer or network. It shows the components and how they interact, including routers, devices, hubs, firewalls, etc. and can help you define the scope of your network for your assessment.',
      expanded: false
    }
  ];

  /**
   * Constructor.
   */
  constructor(
    private assessSvc: AssessmentService,
    public navSvc: NavigationService,
    public configSvc: ConfigService,
    public dialog: MatDialog
  ) { }

  /**
   * 
   */
  ngOnInit() {
    this.assessSvc.getAssessmentDetail().subscribe(
      (data: AssessmentDetail) => {
        this.assessSvc.assessment = data;

        this.navSvc.setCurrentPage('info1');

        this.features.find(x => x.code === 'standard').selected = this.assessSvc.assessment.UseStandard;
        this.features.find(x => x.code === 'maturity').selected = this.assessSvc.assessment.UseMaturity;
        this.features.find(x => x.code === 'diagram').selected = this.assessSvc.assessment.UseDiagram;
      });
  }

  /**
   * Sets the selection of a feature and posts the assesment detail to the server.
   */
  submit(feature, event: any) {
    const value = event.srcElement.checked;

    switch (feature.code) {
      case 'maturity':
        this.assessSvc.assessment.UseMaturity = value;
        break;
      case 'standard':
        this.assessSvc.assessment.UseStandard = value;
        break;
      case 'diagram':
        this.assessSvc.assessment.UseDiagram = value;
        break;
    }
    this.assessSvc.updateAssessmentDetails(this.assessSvc.assessment);
    sessionStorage.removeItem('tree');
    // tell the standard service to refresh the nav tree
    this.navSvc.buildTree(this.navSvc.getMagic());
  }


  /**
   * Toggles the open/closed style of the description div.
   */
  toggleExpansion(std) {
    this.expandedDesc[std] = !this.expandedDesc[std];
  }

  /**
 * Returns the URL of the Questions page in the user guide.
 */
  helpDocUrl() {
    return this.configSvc.docUrl + 'htmlhelp/prepare_assessment_info.htm';
  }
}

