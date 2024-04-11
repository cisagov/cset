////////////////////////////////
//
//   Copyright 2024 Battelle Energy Alliance, LLC
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
////////////////////////////////
import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { AssessmentService } from '../../../../services/assessment.service';
import { ConfigService } from '../../../../services/config.service';
import { MaturityService } from '../../../../services/maturity.service';
import { NavigationService } from '../../../../services/navigation/navigation.service';

@Component({
  selector: 'app-assessment-config',
  templateUrl: './assessment-config.component.html'
})
export class AssessmentConfigComponent implements OnInit {

  expandedDesc: boolean[] = [];

  // the list of categories that can be selected
  features: any = [...[
    {
      code: 'maturity',
      label: 'Cybersecurity Assessment Module',
      description: "A CSET cybersecurity module is based on:</br><ul style=\"margin-block-end: 0;\"><li>Organizational Maturity (Maturity Models)</li><li>Best Practices and Critical Infrastructure/Industry</li></ul>",
      expanded: false
    },
    {
      code: 'standard',
      label: 'Standard-Based Assessment',
      description: "A CSET standard-based assessment is based on industry standards like NIST SP 800 series, the CSF, NERC, NISTIR and other industry authorities. The assessment examines the organization's cybersecurity posture against the standard, tests its security controls, and measures how they stack up against known vulnerabilities. Multiple standards can be selected so the user can facilitate a combination of standards during one CSET assessment.",
      expanded: false
    },
    {
      code: 'diagram',
      label: 'Network Diagram',
      description: 'A network diagram is a visual representation of a computer or network. It shows the components and how they interact, including routers, devices, hubs, firewalls, etc. and can help define the scope of the network for the assessment.',
      expanded: false
    }
  ]];


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
    this.features.find(x => x.code === 'standard').selected = this.assessSvc.assessment.useStandard;
    this.features.find(x => x.code === 'maturity').selected = this.assessSvc.assessment.useMaturity;
    this.features.find(x => x.code === 'diagram').selected = this.assessSvc.assessment.useDiagram;
  }



  /**
   * Returns the URL of the page in the user guide.
   */
  helpDocUrl() {
    switch (this.configSvc.installationMode || '') {
      case "ACET":
        return this.configSvc.docUrl + 'htmlhelp_acet/assessment_configuration.htm';
        break;
      default:
        return this.configSvc.docUrl + 'htmlhelp/prepare_assessment_info.htm';
    }
  }
}

