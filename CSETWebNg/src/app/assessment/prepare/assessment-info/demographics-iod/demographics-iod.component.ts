import { Component, Input, OnInit } from '@angular/core';
import { DemographicIodService } from '../../../../services/demographic-iod.service';
import { DemographicsIod } from '../../../../models/demographics-iod.model';
import { Observable } from 'rxjs';
import { DomSanitizer } from '@angular/platform-browser';
import { OkayComponent } from '../../../../dialogs/okay/okay.component';
import { MatDialog } from '@angular/material/dialog';
import { AssessmentService } from '../../../../services/assessment.service';
import { Config } from 'protractor';
import { ConfigService } from '../../../../services/config.service';
import { DemographicService } from '../../../../services/demographic.service';
import { Demographic, ServiceDemographic, AssessmentConfig, ServiceComposition, CriticalServiceInfo } from '../../../../models/assessment-info.model';
import { CsiService } from '../../../../services/cis-csi.service';


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
  @Input() demographicData: DemographicsIod = {};
  assessmentConfig: AssessmentConfig; 
  serviceDemographics: ServiceDemographic; 
  serviceComposition: ServiceComposition; 
  criticalServiceInfo: CriticalServiceInfo; 


  constructor(public demoSvc: DemographicIodService, 
    private assessSvc: AssessmentService,
    private sanitizer: DomSanitizer,
    public dialog: MatDialog,
    private configSvc : ConfigService, 
    private iodDemoSvc: DemographicIodService,
    private demoSvc2: DemographicService, 
    private csiSvc: CsiService
    ) {}

  /**
   *
   */
  ngOnInit() {
    this.populateDemographicsModel()
  }

  populateDemographicsModel() {
    this.demoSvc.getDemographics().subscribe((data: any) => {
      this.demographicData = data;
    })
  }


  ngOnDestroy() {
    this.eventsSubscription?.unsubscribe();
  }

  /**
   *
   */
  onChangeSector(evt: any) {
    this.demographicData.subsector = null;
    this.newUpdate('SECTOR', evt, 'int')
    if (this.demographicData.sector) {
      this.demoSvc.getSubsectors(this.demographicData.sector).subscribe((data: any[]) => {
        this.demographicData.listSubsectors = data;
      });
      
    }
  }

  changeUsesStandard(val: boolean) {
    this.demographicData.usesStandard = val;
    this.demoSvc.updateIndividualDemographics('STANDARD-USED', val, 'bool')
  }

  setRequireComply(val: boolean) {
    this.demographicData.requiredToComply = val;
    this.demoSvc.updateIndividualDemographics('REGULATION-REQD', val, 'bool')
  }

  changeRegType1(o: any, evt: any) {
    this.demographicData.regulationType1 = o.optionValue;
    this.demoSvc.updateIndividualDemographics('REG-TYPE1', o.optionValue, 'int');
  }

  changeRegType2(o: any, evt: any) {
    this.demographicData.regulationType2 = o.optionValue;
    this.demoSvc.updateIndividualDemographics('REG-TYPE2', o.optionValue, 'int');
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
    this.configSvc.cisaAssessorWorkflow = true;
    this.demoSvc.updateDemographic(this.demographicData);
  }

  newUpdate(name: string, event: any, type: string){
    this.configSvc.cisaAssessorWorkflow = true;
    this.demoSvc.updateIndividualDemographics(name, event.target.value, type)
  }
} 
