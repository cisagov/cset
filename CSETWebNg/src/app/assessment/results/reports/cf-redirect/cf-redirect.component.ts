import { Component } from '@angular/core';
import { CyberFloridaService } from '../../../../services/cyberflorida.service';

@Component({
  selector: 'app-cf-redirect',  
  templateUrl: './cf-redirect.component.html',
  styleUrl: './cf-redirect.component.scss'
})
export class CfRedirectComponent {

  constructor(
    private cfSvc:CyberFloridaService
  ){

  }
  
  clickExportToCF(){
    this.cfSvc.sendToOtherGroup().subscribe(
      {
        next: value => {
          console.log(value);
          window.open(value['url'],"_blank");
          }
          ,
        error: err => console.error('Observable emitted an error: ' + err),
        complete: () => console.log('Observable emitted the complete notification')
      }
    );

  }
}
