import { Component, Input, OnInit } from '@angular/core';
import { ReportService } from '../../../../services/report.service';
import { AssessmentService } from '../../../../services/assessment.service';
import { QuestionsService } from '../../../../services/questions.service';
import { CisService } from '../../../../services/cis.service';
import { HydroService } from '../../../../services/hydro.service';
import { MaturityService } from '../../../../services/maturity.service';

@Component({
  selector: 'app-hydro-actions',
  templateUrl: './hydro-actions.component.html',
  styleUrls: ['./hydro-actions.component.scss']
})
export class HydroActionsComponent implements OnInit {

  allDonutData: any;
  catMap: Map<string, Map<string, any[]>> = new Map<string, Map<string, any[]>>();
  masterArray: any[] = [];
  catArray: any[] = [];

  subCatMap: Map<string, any[]> = new Map<string, any[]>();
  subCatCountMap: Map<string, number> = new Map<string, number>();
  subCatWeightsByCat: any[] = [];
  subCatNamesByCat: any[] = [];

  catCountMap: Map<number, number[]> = new Map<number, number[]>();
  catExpandedMap: Map<string, boolean> = new Map<string, boolean>();
  catIds: number[] = [];
  catNames: string[] = [];

  donutData: any[] = [];
  domainWeightData: any[] = [];
  domainWeightTotals: any[] = []
  weightData: any[] =[];
  loading: boolean = true;


  // magic numbers to transform the subCategory weights to the category donut
  highImpactMagic: number = 0.21724524076;
  mediumImpactMagic: number = 0.33333333333;

  assessScoresColors = {
    domain: ['#426A5A', '#7FB685', '#B4EDD2', '#D95D1E']
  };
  assessView: any[] = [800, 150];

  domainGroupNames: string[] = ['Management', 'Site and Service Control Security', 'Critical Operations', 'Dependencies'];

  constructor(
    public reportSvc: ReportService,
    public assessSvc: AssessmentService,
    public questionsSvc: QuestionsService,
    public maturitySvc: MaturityService,
    public cisSvc: CisService,
    public hydroSvc: HydroService
  ) {}

  ngOnInit() {
    let masterSubCatArray: string[] = [];

    this.reportSvc.getHydroDonutData().subscribe(
      (r: any) => {
        this.allDonutData = r;

        let prevCat = "";
        let prevSubCat = "";
        let subCatArray = [];
        let subCatIds = [];

        for (let i = 0; i < this.allDonutData.length; i++) {
          let currItem = this.allDonutData[i];

          if (currItem.question.sub_Category != prevSubCat) { //checks if the subCat needs to updated
            if (prevSubCat != "") {
              this.subCatMap.set(prevSubCat, subCatArray); //sets the previously filled 
              this.catArray.push(subCatArray);
            }

            prevSubCat = currItem.question.sub_Category;
            masterSubCatArray.push(prevSubCat);
            subCatIds.push(currItem.question.grouping_Id.toString());
            subCatArray = [];

            if (currItem.question.category != prevCat) { //checks if the cat needs to updated
              if (prevCat != "") {
                this.catMap.set(prevCat, this.subCatMap);
                this.masterArray.push(this.catArray);
              }

              prevCat = currItem.question.category;
            }
          }

          subCatArray.push(currItem);
        }

        this.subCatMap.set(prevSubCat, subCatArray);
        this.catArray.push(subCatArray);
        this.catMap.set(prevCat, this.subCatMap);
        this.masterArray.push(this.catArray);

        this.loading = false;
      }
    );
  }

  toggleCategory(catName: string) {
    let currValue = false;
    if (this.catExpandedMap.has(catName)) {
      currValue = this.catExpandedMap.get(catName);
    }
    for (let i = 0; i < this.catNames.length; i++) {
      this.catExpandedMap.set(this.catNames[i], false);
    }
    if (this.catExpandedMap.has(catName)) {
      this.catExpandedMap.set(catName, !currValue);
    }
  }

  roundAndAdjust(weight: number, subGroupingsInDomain: number, magic: number) {
    
    if (magic != 0) {
      weight *= magic;
      return weight/1 + Math.round(weight)%1*0.01;
    }

    return weight/subGroupingsInDomain + Math.round(weight)%subGroupingsInDomain*0.01;
  }

  roundAndCheckForEdgeCase(weight: number) {
    let roundedValue = weight/1 + Math.round(weight%1*0.01);

    if (roundedValue == 99.99 || roundedValue > 100) {
      return 100;
    }

    return roundedValue;
  }

}
