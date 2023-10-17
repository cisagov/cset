import { Component } from '@angular/core';
import { Subject } from 'rxjs';

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

  importClick(evt){
    const fileReader = new FileReader();
    fileReader.readAsText(evt.target.files[0], "UTF-8");
    fileReader.onload = () => {
    this.eventImportExport.next({ flag: 'import', data: JSON.parse(String(fileReader.result))});
    }
    fileReader.onerror = (error) => {
      console.log(error);
    }
  }




  exportClick(){
    this.eventImportExport.next({flag: 'export', data: null});

}

}
