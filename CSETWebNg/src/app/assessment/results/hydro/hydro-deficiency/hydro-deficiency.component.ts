import { Component, Input, OnInit } from '@angular/core';
import { ReportService } from '../../../../services/report.service';
import { AssessmentService } from '../../../../services/assessment.service';
import { QuestionsService } from '../../../../services/questions.service';
import { CisService } from '../../../../services/cis.service';

@Component({
  selector: 'app-hydro-deficiency',
  templateUrl: './hydro-deficiency.component.html',
  styleUrls: ['./hydro-deficiency.component.scss']
})
export class HydroDeficiencyComponent implements OnInit {

  @Input() questionDistribution: any;
  allDonutData: any;
  catMap: Map<string, Map<string, any[]>> = new Map<string, Map<string, any[]>>();
  subCatMap: Map<string, any[]> = new Map<string, any[]>();
  subCatCountMap: Map<string, number> = new Map<string, number>();

  constructor(
    public reportSvc: ReportService,
    public assessSvc: AssessmentService,
    public questionsSvc: QuestionsService,
    public cisSvc: CisService
  ) {}

  ngOnInit() {
    let masterSubCatArray: string[] = [];

    this.reportSvc.getHydroDonutData().subscribe(
      (r: any) => {
        this.allDonutData = r;
        //console.log(this.allDonutData)
        console.log(this.assessSvc.assessment)
        let prevCat = "";
        let prevSubCat = "";
        let subCatArray = [];

        for (let i = 0; i < this.allDonutData.length; i++) {
          let currItem = this.allDonutData[i];

          if (currItem.question.sub_Category != prevSubCat) { //checks if the subCat needs to updated
            if (prevSubCat != "") {
              this.subCatMap.set(prevSubCat, subCatArray); //sets the previously filled 
            }

            prevSubCat = currItem.question.sub_Category;
            masterSubCatArray.push(prevSubCat);
            subCatArray = [];

            if (currItem.question.category != prevCat) { //checks if the cat needs to updated
              if (prevCat != "") {
                this.catMap.set(prevCat, this.subCatMap);
              }

              prevCat = currItem.question.category;
            }
          }

          subCatArray.push(currItem);
        }

        this.subCatMap.set(prevSubCat, subCatArray);
        this.catMap.set(prevCat, this.subCatMap);
        
        console.log(this.catMap)

        this.questionsSvc.getSubGroupingQuestionCount(masterSubCatArray, 13).subscribe(
          (counts: any) => {
            for(let i = 0; i < masterSubCatArray.length; i++) {
              this.subCatCountMap.set(masterSubCatArray[i], counts[i]);
            }

            console.log(this.subCatCountMap)
        });
      }
    );

    this.cisSvc.getCisSection(2578).subscribe(
      (r: any) => {
        console.log(r)
      }
    );
  }

  

}
