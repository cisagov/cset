import { Component } from '@angular/core';
import { Subject } from 'rxjs';
import { DemographicService } from '../../../../services/demographic.service';


interface ImportExportData {
  flag: string;
  data: any; 
}

@Component({
  selector: 'app-assessment-demog-iod',
  templateUrl: './assessment-demog-iod.component.html',
  styleUrls: ['./assessment-demog-iod.component.scss']
})

  
export class AssessmentDemogIodComponent {

  eventImportExport: Subject<ImportExportData> = new Subject<ImportExportData>();

  constructor(
    public demoSvc: DemographicService
    
    ) {}

  importClick(evt){
    console.log("import")
    this.demoSvc.importDemographics(evt)
  }




  exportClick(){
    console.log("export")
    this.demoSvc.exportDemographics()
}

}
