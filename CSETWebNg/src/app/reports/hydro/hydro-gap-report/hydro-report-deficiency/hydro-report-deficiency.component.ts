import { Component, Input, OnInit } from '@angular/core';
import { ReportService } from '../../../../services/report.service';
import { AssessmentService } from '../../../../services/assessment.service';
import { QuestionsService } from '../../../../services/questions.service';
import { CisService } from '../../../../services/cis.service';
import { HydroService } from '../../../../services/hydro.service';
import { MaturityService } from '../../../../services/maturity.service';

@Component({
  selector: 'app-hydro-report-deficiency',
  templateUrl: './hydro-report-deficiency.component.html',
  styleUrls: ['./hydro-report-deficiency.component.scss', '../../../acet-reports.scss']
})
export class HydroReportDeficiencyComponent implements OnInit {

  @Input() questionList: any;

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
  weightData: any[] = [];

  deficiencyMap: Map<string, any[]> = new Map<string, any[]>();

  // the any[] has 3 inner arrays: [[lowImpact], [mediumImpact], [highImpact]], 
  lowest5PerDomain: Map<string, any> = new Map<string, any>();

  loading: boolean = true;


  // magic numbers to transform the subCategory weights to the category donut
  highImpactMagic: number = 0.21724524076;
  mediumImpactMagic: number = 0.33333333333;

  assessScoresColors = {
    domain: ['#426A5A', '#7FB685', '#B4EDD2', '#D95D1E']
  };
  assessView: any[] = [[800, 150], [800, 112.5], [800, 187.5], [800, 150]];

  domainGroupNames: string[] = ['Management', 'Site and Service Control Security', 'Critical Operations', 'Dependencies'];

  constructor(
    public reportSvc: ReportService,
    public assessSvc: AssessmentService,
    public questionsSvc: QuestionsService,
    public maturitySvc: MaturityService,
    public cisSvc: CisService,
    public hydroSvc: HydroService
  ) { }

  ngOnInit() {
    let masterSubCatArray: string[] = [];

    this.hydroSvc.getHydroDonutData().subscribe(
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

        let subCatLevel = 3;
        this.questionsSvc.getAllSubGroupingQuestionCount(13, subCatLevel).subscribe(
          (counts: any) => {
            let result = counts;
            let currParentGroupId = 0;
            let currParentGroupName = '';
            let groupCount = [];
            let subCatNames = [];
            let subCatWeights = [];
            let groupWeightTotals = [0, 0, 0, 0]; // [highWeight, mediumWeight, lowWeight, unimplemented]

            for (let i = 0; i < result.length; i++) {
              let groupInfo = result[i];
              let groupDonutWeight = [];

              if (currParentGroupId != groupInfo.parentGroupingId) {
                if (i != 0) {
                  this.catCountMap.set(currParentGroupId, groupCount);
                  this.catIds.push(currParentGroupId);
                  this.catNames.push(currParentGroupName);
                  this.domainWeightData.push(this.weightData);
                  this.domainWeightTotals.push(groupWeightTotals);
                  this.subCatWeightsByCat.push(subCatWeights);
                  this.subCatNamesByCat.push(subCatNames);
                  groupWeightTotals = [0, 0, 0, 0];
                  subCatWeights = [];
                  this.weightData = [];
                }
                currParentGroupId = groupInfo.parentGroupingId;
                currParentGroupName = groupInfo.questionsWithAnswers[0].question.category;
                groupCount = [];
                subCatNames = [];
              }
              subCatNames.push(groupInfo.questionsWithAnswers[0].question.sub_Category);

              groupCount.push(groupInfo.questionsWithAnswers.length);

              let highWeightGroupTotal = 0;
              let mediumWeightGroupTotal = 0;
              let lowWeightGroupTotal = 0;

              for (let j = 0; j < groupInfo.questionsWithAnswers.length; j++) {
                let question = groupInfo.questionsWithAnswers[j].question;
                let highWeightQuestionTotal = 0;
                let mediumWeightQuestionTotal = 0;
                let lowWeightQuestionTotal = 0;

                for (let k = 0; k < question.maturitY_ANSWER_OPTIONS.length; k++) {
                  let answerOption = question.maturitY_ANSWER_OPTIONS[k];
                  if (answerOption.answer.length > 0) {
                    if (answerOption.threatType == 3) {
                      if (answerOption.threshold != null && (highWeightQuestionTotal + answerOption.weight) > answerOption.threshold) {
                        highWeightQuestionTotal = answerOption.threshold;
                      } else {
                        highWeightQuestionTotal += answerOption.weight;
                      }
                      // collecting the questions
                    } else if (answerOption.threatType == 2) {
                      mediumWeightQuestionTotal += answerOption.weight;
                    } else if (answerOption.threatType == 1) {
                      lowWeightQuestionTotal += answerOption.weight;
                    }
                  }

                  else {
                    let unansweredArray = [];
                    
                    // organizing by impact type (threatType)
                    if (answerOption.threatType == 1) {
                      if (this.lowest5PerDomain[question.category.trim() + '-Low'] != null) {
                        unansweredArray = this.lowest5PerDomain[question.category.trim() + '-Low'];
                      }
                      unansweredArray.push(answerOption);
                      this.lowest5PerDomain.set(question.category.trim() + '-Low', unansweredArray);
                    } else if (answerOption.threatType == 2) {
                      if (this.lowest5PerDomain[question.category.trim() + '-Med'] != null) {
                        unansweredArray = this.lowest5PerDomain[question.category.trim() + '-Med'];
                      }
                      unansweredArray.push(answerOption);
                      this.lowest5PerDomain.set(question.category.trim() + '-Med', unansweredArray);
                    } else if (answerOption.threatType == 3) {
                      if (this.lowest5PerDomain[question.category.trim() + '-High'] != null) {
                        unansweredArray = this.lowest5PerDomain[question.category.trim() + '-High'];
                      }
                      unansweredArray.push(answerOption);
                      this.lowest5PerDomain.set(question.category.trim() + '-High', unansweredArray);
                    }
                  }

                }

                highWeightGroupTotal += highWeightQuestionTotal;
                mediumWeightGroupTotal += mediumWeightQuestionTotal;
                lowWeightGroupTotal += lowWeightQuestionTotal;
              }

              groupDonutWeight.push(this.roundAndCheckForEdgeCase(highWeightGroupTotal));
              groupDonutWeight.push(this.roundAndCheckForEdgeCase(mediumWeightGroupTotal));
              groupDonutWeight.push(this.roundAndCheckForEdgeCase(lowWeightGroupTotal));
              groupDonutWeight.push(100 - (groupDonutWeight[0] + groupDonutWeight[1] + groupDonutWeight[2]));
              subCatWeights.push(groupDonutWeight);

              if (i > 3) {
                groupWeightTotals[0] += this.roundAndAdjust(groupDonutWeight[0], groupInfo.totalSubGroupings, 0);
                groupWeightTotals[1] += this.roundAndAdjust(groupDonutWeight[1], groupInfo.totalSubGroupings, 0);
                groupWeightTotals[2] += this.roundAndAdjust(groupDonutWeight[2], groupInfo.totalSubGroupings, 0);

              } else {
                groupWeightTotals[0] += this.roundAndAdjust(groupDonutWeight[0], 0, this.highImpactMagic);
                groupWeightTotals[1] += this.roundAndAdjust(groupDonutWeight[1], 0, this.mediumImpactMagic);
                groupWeightTotals[2] += this.roundAndAdjust(groupDonutWeight[2], 0, 1);
              }

              groupWeightTotals[3] = 100 - (groupWeightTotals[0] + groupWeightTotals[1] + groupWeightTotals[2]);

            }

            this.domainWeightTotals.push(groupWeightTotals);

            this.catCountMap.set(currParentGroupId, groupCount);
            this.catIds.push(currParentGroupId);
            this.catNames.push(currParentGroupName);
            this.domainWeightData.push(this.weightData);
            this.subCatWeightsByCat.push(subCatWeights);
            this.subCatNamesByCat.push(subCatNames);
            this.toggleCategory(""); //sets all to false
            
            this.loading = false;
          });
      }
    );

    this.fillHighest5PerDomainMap(this.questionList);
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
      return weight / 1 + Math.round(weight) % 1 * 0.01;
    }

    return weight / subGroupingsInDomain + Math.round(weight) % subGroupingsInDomain * 0.01;
  }

  roundAndCheckForEdgeCase(weight: number) {
    let roundedValue = weight / 1 + Math.round(weight % 1 * 0.01);

    if (roundedValue == 99.99 || roundedValue > 100) {
      return 100;
    }

    return roundedValue;
  }

  fillHighest5PerDomainMap(fullStructure: any) {
    this.deficiencyMap.set(this.domainGroupNames[0], []);
    this.deficiencyMap.set(this.domainGroupNames[1], []);
    this.deficiencyMap.set(this.domainGroupNames[2], []);
    this.deficiencyMap.set(this.domainGroupNames[3], []);
      
    fullStructure.groupings[0].groupings.forEach(cat => {
      cat.groupings.forEach(subcat => {
        //recursion to include followup questions
        this.getUnchosenQuestionsOptions(cat.title, subcat.title, subcat.questions);
      });
      
    });

    // sorting by descending order of threatType, then by weight
    this.deficiencyMap.set(this.domainGroupNames[0], this.deficiencyMap.get(this.domainGroupNames[0]).sort(
      (a, b) => {
        return b.option.threatType > a.option.threatType ? 1 : (a.option.threatType > b.option.threatType ? -1 : (b.option.weight > a.option.weight ? 1 : (a.option.weight > b.option.weight ? -1 : 0)))
      }
    ));
    this.deficiencyMap.set(this.domainGroupNames[1], this.deficiencyMap.get(this.domainGroupNames[1]).sort(
      (a, b) => {
        return b.option.threatType > a.option.threatType ? 1 : (a.option.threatType > b.option.threatType ? -1 : (b.option.weight > a.option.weight ? 1 : (a.option.weight > b.option.weight ? -1 : 0)))
      }
    ));
    this.deficiencyMap.set(this.domainGroupNames[2], this.deficiencyMap.get(this.domainGroupNames[2]).sort(
      (a, b) => {
        return b.option.threatType > a.option.threatType ? 1 : (a.option.threatType > b.option.threatType ? -1 : (b.option.weight > a.option.weight ? 1 : (a.option.weight > b.option.weight ? -1 : 0)))
      }
    ));
    this.deficiencyMap.set(this.domainGroupNames[3], this.deficiencyMap.get(this.domainGroupNames[3]).sort(
      (a, b) => {
        return b.option.threatType > a.option.threatType ? 1 : (a.option.threatType > b.option.threatType ? -1 : (b.option.weight > a.option.weight ? 1 : (a.option.weight > b.option.weight ? -1 : 0)))
      }
    ));

    this.deficiencyMap.set(this.domainGroupNames[0], this.deficiencyMap.get(this.domainGroupNames[0]).slice(0, 5));
    this.deficiencyMap.set(this.domainGroupNames[1], this.deficiencyMap.get(this.domainGroupNames[1]).slice(0, 5));
    this.deficiencyMap.set(this.domainGroupNames[2], this.deficiencyMap.get(this.domainGroupNames[2]).slice(0, 5));
    this.deficiencyMap.set(this.domainGroupNames[3], this.deficiencyMap.get(this.domainGroupNames[3]).slice(0, 5));
  }

  getUnchosenQuestionsOptions(catTitle: string, subcatTitle: string, questions: any) {
    questions.forEach(question => {
      let unchosenOptions = []; // array because it might be a checkbox question with multiple of the same threatType and weights
      if (this.deficiencyMap.get(catTitle.trim()).length > 0) {
        unchosenOptions = this.deficiencyMap.get(catTitle.trim());
      }     

      question.options.forEach(option => {
        // really only need to keep track of threatType and weight
        // use threatType to determine lowest 5, with weight breaking ties, 
        // and then sequence breaking any remaining ties

        if (option.threatType != null && option.weight != null && option.selected == false) {
          // including the question to give context in the table
          unchosenOptions.push({subcatTitle, question, option});
          this.deficiencyMap.set(catTitle, unchosenOptions);
        }
          
        // check for followups
        if (option.selected && option.followups.length > 0) {
          this.getUnchosenQuestionsOptions(catTitle, subcatTitle, option.followups);
        }
      });
    });
  }

  getBackgroundColor(threatType: number) {
    switch(threatType) {
      case 3:
        return 'cell high-impact';
      case 2:
        return 'cell med-impact';
      case 1:
        return 'cell low-impact';
      default:
        return 'cell';
    }
  }

}
