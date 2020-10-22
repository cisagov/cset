import { Component, OnInit } from '@angular/core';
import { NavigationService } from '../../../../services/navigation.service';
import { Title, DomSanitizer, SafeHtml } from '@angular/platform-browser';
import { MaturityService } from '../../../../../app/services/maturity.service';

@Component({
  selector: 'app-cmmc-level-drilldown',
  templateUrl: './cmmc-level-drilldown.component.html',
  styleUrls: ['../cmmc-results.scss'],
  // tslint:disable-next-line:use-host-property-decorator
  host: { class: 'd-flex flex-column flex-11a' }
})
export class CmmcLevelDrilldownComponent implements OnInit {

  initialized = false;

  response;
  cmmcModel;
  statsByLevel;
  pieColorYes = "#ffc107";

  //Level descriptions for pie charts
  levelDescriptions = {
    1: "Safeguard Federal Contract Information (FCI)",
    2: "Serves as transition step in cybersecurity maturity progression to protect CUI",
    3: "Protect Controlled Unclassified Information (CUI)",
    4: "Protect CUI and reduce risk of Advanced Persistent Threats (APTs)",
    5: "Protect CUI and reduce risk of Advanced Persistent Threats (APTs)",
  }
  
  constructor(
    public navSvc: NavigationService,
    public maturitySvc: MaturityService,
    private titleService: Title,
  ) { }

  
  ngOnInit(): void {
    this.titleService.setTitle("Site Summary Report - CSET");

    this.maturitySvc.getResultsData('sitesummarycmmc').subscribe(
      (r: any) => {
        this.response = r;
        if(r.MaturityModels){
          r.MaturityModels.forEach(model => {
            if(model.MaturityModelName == "CMMC"){
              this.cmmcModel = model
              this.statsByLevel = this.generateStatsByLevel(this.cmmcModel.StatsByLevel)
              // this.statsByDomain = this.cmmcModel.StatsByDomain
              // this.statsByDomainAtUnderTarget = this.cmmcModel.StatsByDomainAtUnderTarget;
              // this.stackBarChartData = this.generateStackedBarChartData(this.statsByLevel)
              // this.complianceLevelAcheivedData = this.getComplianceLevelAcheivedData(this.statsByLevel)
            }            
          });    
          console.log(this.cmmcModel)
          window.dispatchEvent(new Event('resize'));
        }        
        this.initialized = true;
      },
      error => console.log('Site Summary report load Error: ' + (<Error>error).message)
    ),(finish) => {
    };
  }
  generateStatsByLevel(data){
    let outputData = data.filter(obj => obj.ModelLevel != "Aggregate")
    outputData.sort((a,b) => (a.ModelLevel < b.ModelLevel) ? 1: -1)
    let totalAnsweredCount = 0
    let totalUnansweredCount = 0
    outputData.forEach(element => {
      totalUnansweredCount += element.questionUnAnswered;
      totalAnsweredCount += element.questionAnswered;
      element["totalUnansweredCount"] = totalUnansweredCount;
      element["totalAnsweredCount"] = totalAnsweredCount;
    });
    return outputData
  }
  
  getRadi(i){
    let degreeOfNo = Math.round(i.questionUnAnswered / i.questionCount * 360)
    let val = {
      backgroundImage: `conic-gradient(${this.pieColorYes} ${degreeOfNo}deg, rgba(0,0,0,0) 0 1deg)`
    }
    return val
  }
  getBorder(input){
    return `solid ${input} black`
  }

  getBarSettings(input){
    let width = Math.round(input.questionAnswered / input.questionCount * 100)
    let color = "linear-gradient(5deg, rgba(100,100,100,1) 0%, rgba(200,200,200,1) 100%)"
    if(input.ModelLevel < this.cmmcModel.TargetLevel){
      color = this.getGradient("blue");
    }else if(input.ModelLevel == this.cmmcModel.TargetLevel){
      color = this.getGradient("green");
    } else {
      color = this.getGradient("grey");
    }
    let val = {
      width: `${width}%`,
      background: color
    }
    return val
  }

  isWithinModelLevel(level){
    if(level.ModelLevel == "CMMC"){ return false;}
    let val = Number(level.ModelLevel)
    if(!isNaN(val)){
      if(val <= this.cmmcModel.TargetLevel){
        return true;
      }
    }
    return false;
  }

  
  getGradient(color,alpha=1,reverse=false){
    let vals = {
      color_one: "",
      color_two: ""
    }
    alpha = 1
    switch(color){      
      case "blue":
      case "blue-1":{        
        vals["color_one"] = `rgba(31,82,132,${alpha})`
        vals["color_two"] = `rgba(58,128,194,${alpha})`
        break;
      }    
      case "blue-2":{        
        vals["color_one"] = `rgba(75,116,156,${alpha})`
        vals["color_two"] = `rgba(97,153,206,${alpha})`
        break;
      }    
      case "blue-3":{        
        vals["color_one"] = `rgba(120,151,156,${alpha})`
        vals["color_two"] = `rgba(137,179,218,${alpha})`
        break;
      }    
      case "blue-4":{        
        vals["color_one"] = `rgba(165,185,205,${alpha})`
        vals["color_two"] = `rgba(176,204,230,${alpha})`
        break;
      }    
      case "blue-5":{        
        vals["color_one"] = `rgba(210,220,230,${alpha})`
        vals["color_two"] = `rgba(216,229,243,${alpha})`
        break;
      }
      case "green":{
        vals["color_one"] = `rgba(98,154,109,${alpha})`
        vals["color_two"] = `rgba(31,77,67,${alpha})`
        break;
      }
      case "grey":{
        vals["color_one"] = `rgba(98,98,98,${alpha})`
        vals["color_two"] = `rgba(120,120,120,${alpha})`
        break;
      }
      case "orange":{
        vals["color_one"] = `rgba(255,190,41,${alpha})`
        vals["color_two"] = `rgba(224,217,98,${alpha})`
        break;
      }
    }
    if(reverse){
      let tempcolor = vals["color_one"]
      vals["color_one"] = vals["color_two"]
      vals["color_two"] = tempcolor
    }
    return `linear-gradient(5deg,${vals['color_one']} 0%, ${vals['color_two']} 100%)`
  }
  

}
