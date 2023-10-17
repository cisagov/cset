import { Component, Input, OnInit } from '@angular/core';
import { DemographicIodService } from '../../../../services/demographic-iod.service';
import { DemographicsIod } from '../../../../models/demographics-iod.model';
import { Observable } from 'rxjs';
import { DomSanitizer } from '@angular/platform-browser';
import { saveAs } from 'file-saver';


@Component({
  selector: 'app-demographics-iod',
  templateUrl: './demographics-iod.component.html',
  styleUrls: ['./demographics-iod.component.scss']
})
export class DemographicsIodComponent implements OnInit {

  @Input() events: Observable<void>;

  private eventsSubscription: any;
  
  /**
   * The principal model for this page
   */
  demographicData: DemographicsIod = {};

  constructor(public demoSvc: DemographicIodService, 
    private sanitizer: DomSanitizer
    ) {}

  /**
   *
   */
  ngOnInit() {
    this.demoSvc.getDemographics().subscribe((data: any) => {
      this.demographicData = data;
    });

    this.eventsSubscription = this.events.subscribe((importExportFlag) => this.importExport(importExportFlag));

  }


  ngOnDestroy() {
    this.eventsSubscription.unsubscribe();
  }

  importProfile(file){
    console.log(file)
  }

  importExport(importExportObject){
    if (importExportObject.flag == "import"){
      this.demographicData = importExportObject.data;
    } else {
        this.demographicData.version = 1;
        
        if (this.demographicData.organizationName){

          //verify org name

          var FileSaver = require('file-saver');
          var demoString = JSON.stringify(this.demographicData);
          const blob = new Blob([demoString], { type: 'application/json' });
          
          try {
            FileSaver.saveAs(blob, this.demographicData.organizationName + ".json");
          } catch (error) {
            console.error("Error during file download:", error);
          }

        } else {
          if(confirm("Organization name required to export")){
          }
        }
        
      }
    
  }

  /**
   *
   */
  onChangeSector(evt: any) {
    this.demographicData.subsector = null;
    this.updateDemographics();
    if (this.demographicData.sector) {
      this.demoSvc.getSubsectors(this.demographicData.sector).subscribe((data: any[]) => {
        this.demographicData.listSubsectors = data;
      });
    }
  }

  changeUsesStandard(val: boolean) {
    this.demographicData.usesStandard = val;
    this.updateDemographics();
  }

  setRequireComply(val: boolean) {
    this.demographicData.requiredToComply = val;
    this.updateDemographics();
  }

  changeRegType1(o: any, evt: any) {
    this.demographicData.regulationType1 = o.optionValue;
    this.updateDemographics();
  }

  changeRegType2(o: any, evt: any) {
    this.demographicData.regulationType2 = o.optionValue;
    this.updateDemographics();
  }

  changeShareOrg(org: any, evt: any) {
    org.selected = evt.target.checked;
    if (org.selected) {
      this.demographicData.shareOrgs.push(org.optionValue);
    } else {
      this.demographicData.shareOrgs.splice(this.demographicData.shareOrgs.indexOf(org.optionValue, 0), 1);
    }
    this.updateDemographics();
  }

  isSharedOrgChecked(org): boolean {
    return this.demographicData.shareOrgs.includes(org.optionValue);
  }

  update(event: any) {
    this.updateDemographics();
  }

  updateDemographics() {
    this.demoSvc.updateDemographic(this.demographicData);
  }
}
