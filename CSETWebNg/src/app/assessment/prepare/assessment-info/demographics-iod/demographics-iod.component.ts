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
  styleUrls: ['./demographics-iod.component.scss'],
  standalone: false
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
    private configSvc: ConfigService,
    private iodDemoSvc: DemographicIodService,
    private demoSvc2: DemographicService,
    private csiSvc: CsiService
  ) { }

  /**
   *
   */
  ngOnInit() {
    this.populateDemographicsModel()
  }

  populateDemographicsModel() {
    this.demoSvc.getDemographics().subscribe((data: DemographicsIod) => {
      this.demographicData = data;
    })
  }

  /**
   *
   */
  onChangeSector() {
    //Check if user selected null for sector and reset subsectors 
    if (!this.demographicData.sector) {
      this.demographicData.listSubsectors = [];
    } else {
      this.demoSvc.getSubsectors(this.demographicData.sector).subscribe((data: any[]) => {
        this.demographicData.listSubsectors = data;
      });
    }

    this.assessSvc.assessment.sectorId = this.demographicData.sector;

    this.demographicData.sectorDirective = 'NIPP';
    this.updateDemographics();

   //this.assessSvc.assessmentStateChanged$.next(126);
  }

  onChangeOrgType(evt: any) {
    this.demographicData.organizationType = parseInt(evt.target.value)
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

  /**
   * Set a boolean property on a model.  
   */
  setBool(model: any, prop: string, state: boolean) {
    model[prop] = state;

    if (prop == 'usesStandard' && !state) {
      model['standard1'] = null;
      model['standard2'] = null;
    }

    if (prop == 'requiredToComply' && !state) {
      model['regulationType1'] = null;
      model['regulationType2'] = null;
    }
    this.updateDemographics();
  }

  update(event: any) {
    this.updateDemographics();
  }

  updateDemographics() {
    this.configSvc.cisaAssessorWorkflow = true;
    this.demographicData.sectorDirective = 'NIPP';
    this.demoSvc.updateDemographic(this.demographicData);
  }
} 
