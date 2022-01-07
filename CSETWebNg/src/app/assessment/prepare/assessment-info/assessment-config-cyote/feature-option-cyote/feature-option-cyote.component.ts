import { Component, Input, OnInit } from '@angular/core';
import { AssessmentDetail, MaturityModel } from '../../../../../models/assessment-info.model';
import { AssessmentService } from '../../../../../services/assessment.service';
import { ConfigService } from '../../../../../services/config.service';
import { MaturityService } from '../../../../../services/maturity.service';
import { NavigationService } from '../../../../../services/navigation.service';
import { CyoteService } from '../../../../../services/cyote.service';
@Component({
  selector: 'app-feature-option-cyote',
  templateUrl: './feature-option-cyote.component.html',
  styleUrls: ['./feature-option-cyote.component.scss']
})
export class FeatureOptionCyoteComponent implements OnInit {
  modelSelected:string;
  @Input()
  feature: any;
  // code
  // label
  // description
  // expanded
  @Input()
  features: any;

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
    public cyoteSvc: CyoteService
  ) {

  }

  ngOnInit(): void {
    if( this.assessSvc.assessment.maturityModel.modelName=="CRR" && this.features.find(x => x.code === 'crr').selected == true){

      this.features.find(x => x.code === 'rra').selected = false;
    }
    else if (this.assessSvc.assessment.maturityModel.modelName=="RRA" &&  this.features.find(x => x.code === 'rra').selected == true){
     ;
      this.features.find(x => x.code === 'crr').selected = false;
    }
    else{
      this.features.find(x => x.code === 'crr').selected = false;
      this.features.find(x => x.code === 'rra').selected = false;
    }
  }

  /**
  * Sets the selection of a feature and posts the assesment detail to the server.
  */
  submitcyote(feature, event: any) {
    const value = event.srcElement.checked;
   const model=this.assessSvc.assessment;
   feature.selected=value;
    switch (feature.code) {
      case 'crr':{
        if(value){
          this.features.find(x => x.code === 'rra').selected = false;
        }

        this.assessSvc.assessment.useMaturity = value;
        this.cyoteSvc.cyotetogglecrr(model).subscribe(response => {
          console.log(response)
          this.assessSvc.assessment.maturityModel = response;
          // tell the nav service to refresh the nav tree
          localStorage.removeItem('tree');
          this.navSvc.buildTree(this.navSvc.getMagic());
        });

        break;
      }

        case 'rra':{
          if(value){
            this.features.find(x => x.code === 'crr').selected = false;
          }
          this.assessSvc.assessment.useMaturity = value;
          this.cyoteSvc.cyotetogglerra(model).subscribe((response)=>{
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
        this.cyoteSvc.cyotetogglestandard(model).subscribe(response=>{
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
