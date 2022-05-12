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
  features: any = [];


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
