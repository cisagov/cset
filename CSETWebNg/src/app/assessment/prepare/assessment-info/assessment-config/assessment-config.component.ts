////////////////////////////////
//
//   Copyright 2022 Battelle Energy Alliance, LLC
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
import { AfterContentInit, AfterViewInit, Component, Input, OnInit, QueryList, ViewChild, ViewChildren } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { AssessmentService } from '../../../../services/assessment.service';
import { NavigationService } from '../../../../services/navigation.service';
import { ConfigService } from '../../../../services/config.service';
import { MaturityService } from '../../../../services/maturity.service';
import { NCUAService } from '../../../../services/ncua.service';
import { FeatureOptionComponent } from './feature-option/feature-option.component';

@Component({
  selector: 'app-assessment-config',
  templateUrl: './assessment-config.component.html'
})
export class AssessmentConfigComponent implements OnInit, AfterViewInit {

  expandedDesc: boolean[] = [];

  // the list of features that can be selected
  features: any = [...[
    {
      code: 'maturity',
      label: 'Maturity Model',
      description: 'A maturity model is a formal measurement used by an organization to gauge and improve its programs and processes. Maturity models are intended to measure the degree to which an organization has institutionalized its cybersecurity practices. Implementing process maturity within an organization will ensure that practices are consistent, repeatable, and constantly being improved.',
      expanded: false
    },
    {
      code: 'standard',
      label: 'Standard',
      description: 'A CSET cybersecurity assessment examines the organization\'s cybersecurity posture against a specific standard. The assessment tests its security controls and measures how they stack up against known vulnerabilities.',
      expanded: false
    },
    {
      code: 'diagram',
      label: 'Network Diagram',
      description: 'A network diagram is a visual representation of a computer or network. It shows the components and how they interact, including routers, devices, hubs, firewalls, etc. and can help define the scope of the network for the assessment.',
      expanded: false
    }
  ], ...(this.configSvc.installationMode === 'CYOTE' ? [
    {
      code: 'cyote',
      label: 'CyOTE',
      description: 'The CyOTE methodology applies fundamental concepts of perception and comprehension to a universe of knowns and unknowns in operational technology (OT) environments.  The methodology is aimed at providing capabilities to Asset Owner Operators (AOO) to independently detect adversarial tactics, techniques, and procedures (TTPs) within their OT environments to distinguish between observables, anomalies, and triggering events.',
      expanded: false
    }
  ] : [])];

  @ViewChildren(FeatureOptionComponent) featureChildren: QueryList<FeatureOptionComponent>;


  /**
   * Constructor.
   */
  constructor(
    private assessSvc: AssessmentService,
    public navSvc: NavigationService,
    public configSvc: ConfigService,
    public dialog: MatDialog,
    public maturitySvc: MaturityService,
    public ncuaSvc: NCUAService
  ) {

  }

  /**
   *
   */
  ngOnInit() {
    this.navSvc.setCurrentPage('info1');

    this.features.find(x => x.code === 'standard').selected = this.assessSvc.assessment.useStandard;
    this.features.find(x => x.code === 'maturity').selected = this.assessSvc.assessment.useMaturity;
    this.features.find(x => x.code === 'diagram').selected = this.assessSvc.assessment.useDiagram;



  }
  
  ngAfterViewInit() {
    this.setDisabledOptions();
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


  /**
   * Make ACET, ISE and Maturity Model mutually exclusive via disabling
   */
  setDisabledOptions() {
    this.featureChildren.forEach(f => {
      f.isDisabled = false;

      // TEMP TEMP TEMP
      return;


      if (f.feature.code === 'acet' &&
        !!this.assessSvc.assessment.maturityModel &&
        this.assessSvc.assessment.maturityModel.modelName != 'ACET') {
        f.isDisabled = true;
        console.log('disabling ACET');
        return;
      }

      if (f.feature.code === 'ise' &&
        !!this.assessSvc.assessment.maturityModel &&
        this.assessSvc.assessment.maturityModel.modelName != 'ISE') {      
        f.isDisabled = true;
        return;
      }

      if (f.feature.code === 'maturity' && f.feature.selected) {
        this.featureChildren.find(x => x.feature.code == 'acet').isDisabled = true;
        this.featureChildren.find(x => x.feature.code == 'ise').isDisabled = true;
        return;
      }
    });
  }
}

