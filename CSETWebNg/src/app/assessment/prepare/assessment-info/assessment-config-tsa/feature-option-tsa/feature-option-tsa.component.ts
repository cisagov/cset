import { Component, Input, OnInit } from '@angular/core';
import { AssessmentDetail, MaturityModel } from '../../../../../models/assessment-info.model';
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
  submittsa(feature, event: any) {
    const value = event.srcElement.checked;
   const model=this.assessSvc.assessment;
    switch (feature.code) {
      case 'crr':{
        this.assessSvc.assessment.useMaturity = value;
        this.tsaSvc.TSAtogglecrr(model).subscribe(response => {
          console.log(response)
          this.assessSvc.assessment.maturityModel = response;
          // tell the nav service to refresh the nav tree
          localStorage.removeItem('tree');
          this.navSvc.buildTree(this.navSvc.getMagic()); 
        });
        
        break;
      }
        
        case 'rra':{
          this.assessSvc.assessment.useMaturity = value;
          this.tsaSvc.TSAtogglerra(model).subscribe((response)=>{
            console.log(response)
            this.assessSvc.assessment.maturityModel = response;
            // tell the nav service to refresh the nav tree
            localStorage.removeItem('tree');
            this.navSvc.buildTree(this.navSvc.getMagic());
          })
        break;
        }
        
      case 'standar':{
        this.assessSvc.assessment.useStandard = value;
        this.tsaSvc.TSAtogglestandard(model).subscribe(response=>{
          console.log(response)
          this.assessSvc.assessment.standards= response;
          // tell the nav service to refresh the nav tree
          localStorage.removeItem('tree');
          this.navSvc.buildTree(this.navSvc.getMagic());
        })
        break;
    }
   }
  }
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
