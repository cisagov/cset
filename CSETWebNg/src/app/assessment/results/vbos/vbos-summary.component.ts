import { Component, OnInit, HostListener, ViewChild, ElementRef, Input } from '@angular/core';
import { NavigationService } from '../../../services/navigation.service';
import { MaturityService } from '../../../services/maturity.service';
import { AssessmentService } from '../../../services/assessment.service';
import { ReportAnalysisService } from '../../../services/report-analysis.service';
import { ReportService } from '../../../services/report.service';
import { VbosDataService } from '../../../services/vbos-data.service';
import * as $ from 'jquery';



// New Custom TS to match SP
@Component({
	selector: 'app-vbos-summary',
	templateUrl: './vbos-summary.component.html',
	//styleUrls: 
	//host: {}
})
export class VbosSummaryComponent implements OnInit {
	
  initialized = false;
	dataError = false;

  answerCountsByLevel = [];
  maxLevel = [];
  achievedLevelList = [];
	statsByCategoryList = [];
  categoriesList = ["Asset Management", "Configuration Management", "Access Control", "Flaw Remediation", "Malicious Code Detection", "System Integrity",
  "Continuous Monitoring", "Incident Response and Recovery Planning", "Architecture and Development", "Supply Chain Risk Management"];

  chartItems =
  {
    "labels": [
      "Asset Management",
      "Configuration Management",
      "Access Control",
      "Flaw Remediation",
      "Malicious Code Detection",
      "System Integrity",
      "Continuous Monitoring",
      "Incident Response and Recovery Planning",
      "Architecture and Development",
      "Supply Chain Risk Management"
    ],
    "data": [
      3,
      2,
      2,
      1,
      3,
      2,
      3,
      1,
      2,
      1
    ]
  }

  //secondary data objectives
  categoryCountsList;
  statsByLevelList;

constructor(
  public maturitySvc: MaturityService, 
  public assessmentSvc: AssessmentService,
  public navSvc: NavigationService
){}

ngOnInit(): void {
  this.maturitySvc.getResultsData('vbosSiteSummary').subscribe((r: any) => {
    
    console.log(r);
    // this.achievedLevel(r);
    // this.statsByCategory(r);
    });
  }


  //main data objective
  achievedLevel(data) {
	let outputData = data.filter(obj => obj.modelLevel != "Aggregate");
    // outputData.sort((a, b) => (a.modelLevel > b.modelLevel) ? 1 : -1);

    let levels: number[] = [];
    outputData.forEach(o => levels.push(o.level)); 

    // Minimum of Entire Data-Set Function
    // this.achievedLevelList = [];
    let achievedLevel = Math.min(...levels);
    console.log(achievedLevel);
	return achievedLevel;
    // outputData.forEach(element => {
    //   achievedLevel += element assessmentLevel;
    //   element["achievedLevel"] = achievedLevel;
    // });
	// return outputData;
}

//answer data distributed by sections
statsByCategory(data) {
	let outputData = data.filter(obj => obj.modelLevel != "Aggregate");
    outputData.sort((a, b) => (a.modelLevel > b.modelLevel) ? 1 : -1);
    let categoryList = [];
    
    // Check Hardcoded Array in vbos data service

	return outputData;	
}

//secondary data objectives
categoryCounts(data) {
	let outputData = [];	
	return outputData;
}


}

// Previous TS attempt 

// @Component({
//   selector: 'app-vbos-summary',
//   templateUrl: './vbos-summary.component.html',
//   styleUrls: ['./rra-summary-all.component.scss']
//   host: { class: 'd-flex flex-column flex-11a' }
// })
// export class VbosSummaryComponent implements OnInit {
//   @Input() title = "VBOS Performance Summary";
//   @Input() showNav = true;

//   initialized = false;

//   sAxisTicks = [0, 5, 10, 15, 18];
//   maxLevel = 0;
//   answerCountsByLevel = [];
//   answerDistribColorScheme = { domain: ['#28A745', '#DC3545', '#c3c3c3'] };

//   complianceByGoal = [];
//   answerDistribByGoal = [];
//   answerDistribByLevel = [];

//   colorScheme1 = { domain: ['#007BFF'] };
//   xAxisTicks = [0, 25, 50, 75, 100];

//   constructor(
//     public VbosDataSvc: VbosDataService,
//     public navSvc: NavigationService,
//     public maturitySvc: MaturityService,
//     public assessmentSvc: AssessmentService
//   ) { }

//   ngOnInit(): void {
//     this.VbosDataSvc.getVBOSDetail().subscribe((r: any) => {
//       this.createAnswerCountsByLevel(r);
//       this.createAnswerDistribByLevel(r);
//     });
//   }

//   createAnswerCountsByLevel(r: any) {
//     let levelList = [];

//     r.vbosSummary.forEach(element => {
//       let level = levelList.find(x => x.name == element.level_Name);
//       if (!level) {
//         level = {
//           name: element.level_Name, series: [
//             { name: 'Yes', value: 0 },
//             { name: 'No', value: 0 },
//             { name: 'Unanswered', value: 0 },
//           ]
//         };
//         levelList.push(level);
//       }

//       var p = level.series.find(x => x.name == element.answer_Full_Name);
//       p.value = element.qc;
//     });
//     this.answerCountsByLevel = levelList;
//     this.findMaxLength();
//   }

//   findMaxLength(){
//     let mLength = 0;
//     this.answerCountsByLevel.forEach(x =>{
//       let length = 0;
//       x.series.forEach(y => {
//         length += y.value;
//       });
//       if(mLength < length){
//         mLength = length;
//       }
//     })
//     this.maxLevel = mLength;
//   }
//   createAnswerDistribByLevel(r: any) {
//     let levelList = [];
//     r.vbosSummary.forEach(element => {
//       let level = levelList.find(x => x.name == element.level_Name);
//       if (!level) {
//         level = {
//           name: element.level_Name, series: [
//             { name: 'Yes', value: 0 },
//             { name: 'No', value: 0 },
//             { name: 'Unanswered', value: 0 },
//           ]
//         };
//         levelList.push(level);
//       }

//       var p = level.series.find(x => x.name == element.answer_Full_Name);
//       p.value = element.percent;
//     });

//     this.answerDistribByLevel = levelList;
//   }

//   formatPercent(x: any) {
//     return x + '.0';
//   }

// }
// }
