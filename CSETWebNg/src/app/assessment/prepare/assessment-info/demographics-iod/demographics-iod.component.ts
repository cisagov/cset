import { Component, Input, OnInit } from '@angular/core';
import { DemographicIodService } from '../../../../services/demographic-iod.service';
import { DemographicsIod } from '../../../../models/demographics-iod.model';
import { BehaviorSubject, Observable } from 'rxjs';
import { DomSanitizer } from '@angular/platform-browser';
import { MatDialog } from '@angular/material/dialog';
import { AssessmentService } from '../../../../services/assessment.service';
import { ConfigService } from '../../../../services/config.service';
import { DemographicService } from '../../../../services/demographic.service';
import { ServiceDemographic, AssessmentConfig, ServiceComposition, CriticalServiceInfo } from '../../../../models/assessment-info.model';
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

    this.demoSvc.updateIndividualDemographics('SECTOR', this.demographicData.sector, 'int');
    this.demoSvc.updateIndividualDemographics('SUBSECTOR', this.demographicData.subsector, 'int');

    if (this.demographicData.sector) {
      this.demoSvc.getSubsectors(this.demographicData.sector).subscribe((data: any[]) => {
        this.demographicData.listSubsectors = data;
      });
      this.assessSvc.assessment.sectorId = this.demographicData.sector;
      this.assessSvc.assessmentStateChanged$.next(126);
    }
  }

  onChangeOrgType(evt: any){
    this.demographicData.organizationType = parseInt(evt.target.value)
    this.newUpdate('ORG-TYPE', evt, 'int')
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

    let val = event.target.value;
    if (val == '0: null') {
      val = null;
    }

    this.demoSvc.updateIndividualDemographics(name, val, type)
  }
  
} 
