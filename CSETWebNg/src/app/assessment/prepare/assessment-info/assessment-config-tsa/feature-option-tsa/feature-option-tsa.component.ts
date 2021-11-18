import { Component, Input, OnInit } from '@angular/core';
import { MaturityModel } from '../../../../../models/assessment-info.model';
import { AssessmentService } from '../../../../../services/assessment.service';
import { ConfigService } from '../../../../../services/config.service';
import { MaturityService } from '../../../../../services/maturity.service';
import { NavigationService } from '../../../../../services/navigation.service';
import { TsaService } from '../../../../../services/tsa.service';
@Component({
  selector: 'app-feature-option-tsa',
  templateUrl: './feature-option-tsa.component.html',
  styleUrls: ['./feature-option-tsa.component.scss']
})
export class FeatureOptionTsaComponent implements OnInit {
  modelSelected:string;
  @Input()
  feature: any;
  // code
  // label
  // description
  // expanded

  /**
   * Indicates if the description is expanded
   */
  expandedDesc: boolean;

  /**
   * Indicates the expanded state of the ACET Only description
   */
  expandedAcet: boolean;

  constructor(
    public assessSvc: AssessmentService,
    public navSvc: NavigationService,
    public configSvc: ConfigService,
    public maturitySvc: MaturityService,
    public tsaSvc:TsaService
  ) { }

  ngOnInit(): void {
  }

  /**
  * Sets the selection of a feature and posts the assesment detail to the server.
  */
  submit(feature, event: any) {
    const value = event.srcElement.checked;
   const model=this.assessSvc.assessment;
    switch (feature.code) {
      case 'crr':{
        this.assessSvc.assessment.useMaturity = value;
        this.tsaSvc.TSAtogglecrr(model).subscribe((response: MaturityModel) => {
          this.assessSvc.assessment.maturityModel = response;
          // tell the nav service to refresh the nav tree
          localStorage.removeItem('tree');
          this.navSvc.buildTree(this.navSvc.getMagic()); });
        
        break;
      }
        
        case 'rra':{
          this.assessSvc.assessment.useMaturity = value;
          this.tsaSvc.TSAtogglerra(model).subscribe((response:MaturityModel)=>{
            this.assessSvc.assessment.maturityModel = response;
            // tell the nav service to refresh the nav tree
            localStorage.removeItem('tree');
            this.navSvc.buildTree(this.navSvc.getMagic());
          })
        break;
        }
        
      case 'standard':{
        this.assessSvc.assessment.useStandard = value;
        // this.tsaSvc.TSAtogglestandard(model).subscribe((response:model)=>{
        //   this.assessSvc.assessment.maturityModel = response;
        //   // tell the nav service to refresh the nav tree
        //   localStorage.removeItem('tree');
        //   this.navSvc.buildTree(this.navSvc.getMagic());
        // })
        break;
    }
   }
  }
    
    // special case for acet-only
    // if (feature == 'acet-only') {
    //     this.assessSvc.assessment.isAcetOnly = value

    //     if (value) {
    //       this.assessSvc.setAcetDefaults();
    //     }
    // }


    // if (this.assessSvc.assessment.useMaturity) {
    //   if (this.assessSvc.assessment.maturityModel == undefined) {
    //     switch(this.configSvc.installationMode || '') {
    //       case "ACET":
    //         this.assessSvc.assessment.maturityModel = this.maturitySvc.getModel("ACET");
    //         break;
    //       default:
    //         this.assessSvc.assessment.maturityModel = this.maturitySvc.getModel("EDM");
    //     }
    //   }
    //   if (this.assessSvc.assessment.maturityModel?.maturityTargetLevel
    //     || this.assessSvc.assessment.maturityModel?.maturityTargetLevel == 0) {
    //     this.assessSvc.assessment.maturityModel.maturityTargetLevel = 1;
    //   }
    // } else {
    //   this.assessSvc.assessment.isAcetOnly = false;
    // }
    
    // this.assessSvc.updateAssessmentDetails(this.assessSvc.assessment);

    
    
  


  /**
   * Toggles the open/closed style of the description div.
   */
  toggleExpansion() {
    this.expandedDesc = !this.expandedDesc;
  }

  /**
   * 
   */
  toggleExpansionAcet() {
    this.expandedAcet = !this.expandedAcet;
  }
}
