import { Component, Input, OnInit } from '@angular/core';
import { DemographicIodService } from '../../../../services/demographic-iod.service';
import { DemographicsIod } from '../../../../models/demographics-iod.model';
import { Observable } from 'rxjs';
import { DomSanitizer } from '@angular/platform-browser';
import { OkayComponent } from '../../../../dialogs/okay/okay.component';
import { MatDialog } from '@angular/material/dialog';
import { AssessmentService } from '../../../../services/assessment.service';


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
    private assessSvc: AssessmentService,
    private sanitizer: DomSanitizer,
    public dialog: MatDialog
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
      this.updateDemographics();
    } else {
        this.demographicData.version = 1;
        
        if (this.demographicData.organizationName){
            //File name will be saved with '_' instead of any invalid characters
            //Could implement functionality that replaces invalid characters manually           
            var FileSaver = require('file-saver');            
            var demoString = JSON.stringify(this.demographicData);
            const blob = new Blob([demoString], { type: 'application/json' });
            var fileName = this.demographicData.organizationName.replaceAll("[<>:\"\/\\|?*]","_");            
            try {
              FileSaver.saveAs(blob, fileName + ".json");
            } catch (error) {
              console.error("Error during file download:", error);
            }
          
        } else {
          const msg2 = 'Name of organization required before export';
          const titleComplete = 'Organization Name Required'
          const dlgOkay = this.dialog.open(OkayComponent, { data: { title: titleComplete, messageText: msg2 } });
          dlgOkay.componentInstance.hasHeader = true;
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
    this.assessSvc.updateAssessmentName();
  }

  updateDemographics() {
    this.demoSvc.updateDemographic(this.demographicData);
  }
}
