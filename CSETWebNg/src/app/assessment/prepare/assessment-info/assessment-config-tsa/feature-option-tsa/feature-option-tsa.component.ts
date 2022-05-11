import { Component, Input, OnInit } from '@angular/core';
import { AssessmentDetail, MaturityModel } from '../../../../../models/assessment-info.model';
import { AssessmentService } from '../../../../../services/assessment.service';
import { ConfigService } from '../../../../../services/config.service';
import { MaturityService } from '../../../../../services/maturity.service';
import { NavigationService } from '../../../../../services/navigation.service';
import { TsaService } from '../../../../../services/tsa.service';
import { QuestionRequirementCounts, StandardsBlock } from "../../../../../models/standards.model";
import { StandardService } from '../../../../../services/standard.service';
import { data } from 'jquery';
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
  @Input()
  features: any;
  standards: StandardsBlock;
  /**
   * Indicates if the description is expanded
   */
  expandedDesc: boolean;
  counts:QuestionRequirementCounts= Object.create(null);

  /**
   * Indicates the expanded state of the ACET Only description
   */
  expandedAcet: boolean;

  constructor(
    public assessSvc: AssessmentService,
    public navSvc: NavigationService,
    public configSvc: ConfigService,
    public maturitySvc: MaturityService,
    public tsaSvc:TsaService,
    private standardSvc: StandardService,
  ) {

  }

  ngOnInit(): void {
      if(this.assessSvc.assessment.standards?.find(x=>x==='TSA2018')){
        this.features.find(x => x.name === 'TSA2018').selected = true;
      }
      if(this.assessSvc.assessment.standards?.find(x=>x==='CSC_V8')){
        this.features.find(x => x.name === 'CSC_V8').selected = true;
      }
      if(this.assessSvc.assessment.standards?.find(x=>x==='APTA_Rail_V1')){
        this.features.find(x => x.name === 'APTA_Rail_V1').selected = true;
      }
      if( this.assessSvc.assessment.maturityModel?.modelName=="CRR"){
        this.features.find(x => x.name === 'CRR').selected = true;
        this.features.find(x => x.name === 'RRA').selected = false;
        this.features.find(x => x.name === 'VADR').selected = false;
      }
      else if (this.assessSvc.assessment.maturityModel?.modelName=="RRA"){
        this.features.find(x => x.name === 'RRA').selected = true;
        this.features.find(x => x.name === 'CRR').selected = false;
        this.features.find(x => x.name === 'VADR').selected = false;
      }
      else if( this.assessSvc.assessment.maturityModel?.modelName=="VADR"){
        this.features.find(x => x.name === 'VADR').selected = true;
        this.features.find(x => x.name === 'RRA').selected = false;
        this.features.find(x => x.name === 'CRR').selected = false;
      }
      else{
        this.features.find(x => x.name === 'CRR').selected = false;
        this.features.find(x => x.name === 'RRA').selected = false;
        this.features.find(x => x.name === 'VADR').selected = false;
      }



    this.loadStandards();
  }

  /**
  * Sets the selection of a feature and posts the assesment detail to the server.
  */
  submittsa(feature, event: any) {
    const value = event.srcElement.checked;

   const model=this.assessSvc.assessment;

   const selectedStandards: string[] = [];
   this.features.forEach(x=>{
     if(x.name=='TSA2018' && x.selected){

       selectedStandards.push(x.name);
     }else if(x.name=='CSC_V8' && x.selected){
      selectedStandards.push(x.name);
     }else if(x.name=='APTA_Rail_V1' && x.selected){
      selectedStandards.push(x.name);
     }
   })
   this.assessSvc.assessment.standards = selectedStandards;
   feature.selected=value;
    switch (feature.name) {
      case 'CRR':{
        if(value){
          this.features.find(x => x.name === 'RRA').selected = false;
          this.features.find(x => x.name === 'VADR').selected = false;
        }

        this.assessSvc.assessment.useMaturity = value;
        this.tsaSvc.TSAtogglecrr(model).subscribe(response => {
          this.assessSvc.assessment.maturityModel = response;
          // tell the nav service to refresh the nav tree
          localStorage.removeItem('tree');
          this.navSvc.buildTree(this.navSvc.getMagic());
        });

        break;
      }

        case 'RRA':{
          if(value){
            this.features.find(x => x.name === 'CRR').selected = false;
            this.features.find(x => x.name === 'VADR').selected = false;
          }
          this.assessSvc.assessment.useMaturity = value;
          this.tsaSvc.TSAtogglerra(model).subscribe((response)=>{
            this.assessSvc.assessment.maturityModel = response;
            // tell the nav service to refresh the nav tree
            localStorage.removeItem('tree');
            this.navSvc.buildTree(this.navSvc.getMagic());
          })
        break;
        }
        case 'VADR':{
          if(value){
            this.features.find(x => x.name === 'CRR').selected = false;
            this.features.find(x => x.name === 'RRA').selected = false;
          }
          this.assessSvc.assessment.useMaturity = value;
          this.tsaSvc.TSAtogglevadr(model).subscribe((response)=>{
            this.assessSvc.assessment.maturityModel = response;
            // tell the nav service to refresh the nav tree
            localStorage.removeItem('tree');
            this.navSvc.buildTree(this.navSvc.getMagic());
          })
        break;
        }

      case 'TSA2018':{
        this.assessSvc.assessment.useStandard = value;
        this.tsaSvc.postSelections(selectedStandards)
        .subscribe((counts: QuestionRequirementCounts) => {
          this.standards.questionCount = counts.questionCount;
          this.standards.requirementCount = counts.requirementCount;
        });

    this.navSvc.setQuestionsTree();
        break;
    }
    case 'CSC_V8':{
      this.assessSvc.assessment.useStandard = value;
      this.tsaSvc.postSelections(selectedStandards)
      .subscribe((counts: QuestionRequirementCounts) => {
        this.standards.questionCount = counts.questionCount;
        this.standards.requirementCount = counts.requirementCount;
      });

    this.navSvc.setQuestionsTree();
      break;
  }
  case 'APTA_Rail_V1':{
    this.assessSvc.assessment.useStandard = value;
       this.tsaSvc.postSelections(selectedStandards)
       .subscribe((counts: QuestionRequirementCounts) => {
        this.standards.questionCount = counts.questionCount;
        this.standards.requirementCount = counts.requirementCount;
      });

    this.navSvc.setQuestionsTree();
    break;
}
   }
  }
  loadStandards(){
    this.standardSvc.getStandardsList().subscribe(
      (data: StandardsBlock) => {
        this.standards = data;
  })}
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
