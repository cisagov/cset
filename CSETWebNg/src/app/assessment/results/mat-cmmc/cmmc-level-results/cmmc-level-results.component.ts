import { Component, OnInit } from '@angular/core';
import { NavigationService } from '../../../../services/navigation.service';
import { Title, DomSanitizer, SafeHtml } from '@angular/platform-browser';
import { MaturityService } from '../../../../../app/services/maturity.service';

@Component({
  selector: 'app-cmmc-level-results',
  templateUrl: './cmmc-level-results.component.html',
  styleUrls: ['/sass/cmmc-results.scss'],
  // tslint:disable-next-line:use-host-property-decorator
  host: { class: 'd-flex flex-column flex-11a' },
})
export class CmmcLevelResultsComponent implements OnInit {

  initialized = false;
  dataError = false;

  response;
  cmmcModel;
  
  whiteText= "rgba(255,255,255,1)"
  blueText= "rgba(31,82,132,1)"

  constructor(
    public navSvc: NavigationService,
    public maturitySvc: MaturityService,
    private titleService: Title,
  ) { }

  ngOnInit(): void {
    this.maturitySvc.getResultsData('sitesummarycmmc').subscribe(
      (r: any) => {
        this.response = r;
        if(r.MaturityModels){
          r.MaturityModels.forEach(model => {
            if(model.MaturityModelName == "CMMC"){
              this.cmmcModel = model
              //this.statsByLevel = this.generateStatsByLevel(this.cmmcModel.StatsByLevel)
              // this.statsByDomain = this.cmmcModel.StatsByDomain
              // this.statsByDomainAtUnderTarget = this.cmmcModel.StatsByDomainAtUnderTarget;
              // this.stackBarChartData = this.generateStackedBarChartData(this.statsByLevel)
              // this.complianceLevelAcheivedData = this.getComplianceLevelAcheivedData(this.statsByLevel)
            }            
          });    
          window.dispatchEvent(new Event('resize'));
        }        
        this.initialized = true;
      },
      error => {
        this.dataError = true;
        this.initialized = true;
        console.log('Site Summary report load Error: ' + (<Error>error).message)
      }
    ),(finish) => {
    };
  }
  
  //Pyramid Chart
  getPyramidRowColor(level){
    let backgroundColor = this.getGradient("blue",.1);
    let textColor = this.blueText
    if(this.cmmcModel?.TargetLevel){
      if(level == this.cmmcModel?.TargetLevel){
        backgroundColor = this.getGradient("green")
        textColor = this.whiteText
      }
      else if(level < this.cmmcModel?.TargetLevel){
        backgroundColor = this.getGradient("blue")
        textColor = this.whiteText
      } else {        
        backgroundColor = this.getGradient("blue-5")
        textColor = this.blueText
      }
    }
    return {
      background: backgroundColor,
      color: textColor
    }
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
