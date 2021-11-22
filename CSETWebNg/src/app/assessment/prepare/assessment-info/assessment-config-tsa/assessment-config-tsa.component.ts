import { Component, Input, OnInit, ViewChild } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { AssessmentService } from '../../../../services/assessment.service';
import { NavigationService } from '../../../../services/navigation.service';
import { ConfigService } from '../../../../services/config.service';
import { MaturityService } from '../../../../services/maturity.service';

@Component({
  selector: 'app-assessment-config-tsa',
  templateUrl: './assessment-config-tsa.component.html',
  styleUrls: ['./assessment-config-tsa.component.scss']
})
export class AssessmentConfigTsaComponent implements OnInit {

  
  expandedDesc: boolean[] = [];

  // the list of features that can be selected
  features: any = [
    {
      code: 'rra',
      label: 'RRA',
      description: 'A maturity model is a formal measurement used by an organization to gauge and improve its programs and processes. Maturity models are intended to measure the degree to which an organization has institutionalized its cybersecurity practices. Implementing process maturity within an organization will ensure that practices are consistent, repeatable, and constantly being improved.',
      expanded: false
    },
    {
      code: 'crr',
      label: 'CRRR',
      description: 'A CSET cybersecurity assessment examines the organization\'s cybersecurity posture against a specific standard. The assessment tests its security controls and measures how they stack up against known vulnerabilities.',
      expanded: false
    },
    {
      code: 'standar',
      label: 'TSA Pipeline',
      description: 'A network diagram is a visual representation of a computer or network. It shows the components and how they interact, including routers, devices, hubs, firewalls, etc. and can help define the scope of the network for the assessment.',
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
    public dialog: MatDialog,
    public maturitySvc: MaturityService
  ) {

  }

  /**
   * 
   */
  ngOnInit() {
    this.navSvc.setCurrentPage('info1');

    this.features.find(x => x.code === 'rra').selected = this.assessSvc.assessment.useMaturity;
    this.features.find(x => x.code === 'crr').selected = this.assessSvc.assessment.useMaturity;
    this.features.find(x => x.code === 'standar').selected = this.assessSvc.assessment.useStandard;
  }



  /**
   * Returns the URL of the page in the user guide.
   */
  helpDocUrl() {
    switch(this.configSvc.installationMode || '')
    {
      case "ACET":
        return this.configSvc.docUrl + 'htmlhelp_acet/assessment_configuration.htm';
        break;
      default:
        return this.configSvc.docUrl + 'htmlhelp/prepare_assessment_info.htm';
    }
  }

}
