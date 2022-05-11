import { Component, Input, OnInit, ViewChild } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { AssessmentService } from '../../../../services/assessment.service';
import { NavigationService } from '../../../../services/navigation.service';
import { ConfigService } from '../../../../services/config.service';
import { MaturityService } from '../../../../services/maturity.service';
import { TsaService } from '../../../../services/tsa.service';


@Component({
  selector: 'app-assessment-config-tsa',
  templateUrl: './assessment-config-tsa.component.html',
  styleUrls: ['./assessment-config-tsa.component.scss']
})
export class AssessmentConfigTsaComponent implements OnInit {


  expandedDesc: boolean[] = [];

  // the list of features that can be selected
  features: any = [
    // {
    //   code: 'rra',
    //   label: 'Ransomware Readiness Assessment (RRA)',
    //   description: 'Take the Ransomware Readiness Assessment (RRA) to understand your cybersecurity posture and assess how well your organization is equipped to defend and recover from a ransomware incident.',
    //   expanded: false
    // },
    // {
    //   code: 'crr',
    //   label: 'Cyber Resilience Review (CRR)',
    //   description: 'The CRR is a no-cost, voluntary, non-technical assessment to evaluate an organization’s operational resilience and cybersecurity practices.',
    //   expanded: false
    // },
    // {
    //   code: 'vadr',
    //   label: 'Validated Architecture Design Reviews (VADR)',
    //   description: 'The VADR maturity model enables participants to perform assessments virtually. Virtual assessments include the same elements that make up a traditional VADR: Architecture Design Review,  System Configuration and Log Review, as well as Network Traffic Analysis.',
    //   expanded: false
    // },
    // {
    //   code: 'TSA2018',
    //   label: 'TSA Pipeline Security Guidelines March 2018 with April 2021 revision',
    //   description: 'Utilizing an industry and government collaborative approach, TSA develops guidelines to help advance security measures for the physical and cyber security space. The security measures in this assessment and related guidance provide the basis for TSA’s Pipeline Security Program Corporate Security Reviews and Critical Facility Security Reviews.',
    //   expanded: false
    // },
    // {
    //   code: 'CSC_V8',
    //   label: 'CIS v8 (Critical Security Controls)',
    //   description: 'The CIS controls v8 (Critical Security Controls (CIS Controls)) are a prioritized set of Safeguards to mitigate the most prevalent cyber-attacks against systems and networks. They are mapped to and referenced by multiple legal, regulatory, and policy frameworks and contains controls to address movement to cloud-based computing, virtualization, mobility, outsourcing and Work-from-Home environments.',
    //   expanded: false
    // },
    // {
    //   code: 'APTA_Rail_V1',
    //   label: 'Light Rail Transit Standards',
    //   description: 'Defining a Security Zone Architecture for Rail Transit and Protecting Critical Zones. Securing Control and Communications Systems in Rail Transit Environments.',
    //   expanded: false
    // }
  ];


  /**
   * Constructor.
   */
  constructor(
    private assessSvc: AssessmentService,
    public navSvc: NavigationService,
    public configSvc: ConfigService,
    public dialog: MatDialog,
    public maturitySvc: MaturityService,
    public tsaSvc:TsaService
  ) {

  }

  /**
   *
   */
  ngOnInit() {
    // this.navSvc.setCurrentPage('info1');
    this.navSvc.setCurrentPage('info-tsa');
    this.tsaSvc.TSAGetModelsName().subscribe((data)=>{
     this.features=data;
     console.log(this.features)
    this.features.forEach(element => {
      if(element.set_Name && !element.model_Name){
        this.assessSvc.assessment.useStandard;
      }else if(!element.set_Name && element.model_Name)
      {
        this.assessSvc.assessment.useMaturity;
      }
    });
    //  this.features.find(x => x.name === 'RRA').selected = this.assessSvc.assessment.useMaturity;
    //  this.features.find(x => x.name === 'CRR').selected = this.assessSvc.assessment.useMaturity;
    //  this.features.find(x => x.name === 'VADR').selected = this.assessSvc.assessment.useMaturity;
    //  this.features.find(x => x.name === 'TSA2018').selected = this.assessSvc.assessment.useStandard;
    //  this.features.find(x => x.name === 'CSC_V8').selected = this.assessSvc.assessment.useStandard;
    //  this.features.find(x => x.name === 'APTA_Rail_V1').selected = this.assessSvc.assessment.useStandard;
    })

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
